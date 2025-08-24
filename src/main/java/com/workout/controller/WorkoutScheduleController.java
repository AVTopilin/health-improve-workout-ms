package com.workout.controller;

import com.workout.dto.WorkoutDto;
import com.workout.dto.WorkoutScheduleDto;
import com.workout.dto.WorkoutScheduleExerciseDto;
import com.workout.dto.ScheduleGenerationRequestDto;
import com.workout.entity.User;
import com.workout.entity.WorkoutSchedule;
import com.workout.service.UserService;
import com.workout.service.WorkoutService;
import com.workout.service.WorkoutScheduleGenerationService;
import com.workout.service.WorkoutScheduleService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.format.annotation.DateTimeFormat;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Контроллер для управления расписанием тренировок
 */
@Slf4j
@RestController
@RequestMapping("/api/schedule")
@CrossOrigin(origins = "*")
public class WorkoutScheduleController extends BaseController {
    
    private final WorkoutScheduleService workoutScheduleService;
    private final WorkoutScheduleGenerationService scheduleGenerationService;
    private final WorkoutService workoutService;
    
    public WorkoutScheduleController(
            WorkoutScheduleService workoutScheduleService,
            WorkoutScheduleGenerationService scheduleGenerationService,
            WorkoutService workoutService,
            UserService userService) {
        super(userService);
        this.workoutScheduleService = workoutScheduleService;
        this.scheduleGenerationService = scheduleGenerationService;
        this.workoutService = workoutService;
    }
    
    /**
     * Получить все расписания пользователя
     */
    @GetMapping
    public ResponseEntity<List<WorkoutScheduleDto>> getSchedules(@AuthenticationPrincipal Jwt jwt) {
        log.info("=== GET /api/schedule - GET ALL SCHEDULES ===");
        User user = getCurrentUser(jwt);
        List<WorkoutSchedule> schedules = workoutScheduleService.getSchedulesByUserId(user.getId());
        List<WorkoutScheduleDto> scheduleDtos = schedules.stream()
                .map(WorkoutScheduleDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(scheduleDtos);
    }
    
    /**
     * Получить расписание по ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<WorkoutScheduleDto> getSchedule(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        log.info("=== GET /api/schedule/{} - GET SCHEDULE BY ID ===", id);
        User user = getCurrentUser(jwt);
        WorkoutSchedule schedule = workoutScheduleService.getScheduleById(id, user.getId());
        return ResponseEntity.ok(WorkoutScheduleDto.fromEntity(schedule));
    }
    
    /**
     * Получить расписание для конкретной тренировки
     */
    @GetMapping("/workout/{workoutId}")
    public ResponseEntity<List<WorkoutScheduleDto>> getSchedulesByWorkout(
            @PathVariable Long workoutId, 
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== GET /api/schedule/workout/{} - GET SCHEDULES BY WORKOUT ===", workoutId);
        User user = getCurrentUser(jwt);
        List<WorkoutSchedule> schedules = workoutScheduleService.getSchedulesByWorkoutId(workoutId, user.getId());
        List<WorkoutScheduleDto> scheduleDtos = schedules.stream()
                .map(WorkoutScheduleDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(scheduleDtos);
    }
    
    /**
     * Получить расписание в диапазоне дат
     */
    @GetMapping("/range")
    public ResponseEntity<List<WorkoutScheduleDto>> getSchedulesByDateRange(
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate startDate,
            @RequestParam @DateTimeFormat(iso = DateTimeFormat.ISO.DATE) LocalDate endDate,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== GET /api/schedule/range - GET SCHEDULES BY DATE RANGE: {} to {} ===", startDate, endDate);
        User user = getCurrentUser(jwt);
        List<WorkoutSchedule> schedules = workoutScheduleService.getSchedulesByDateRange(user.getId(), startDate, endDate);
        List<WorkoutScheduleDto> scheduleDtos = schedules.stream()
                .map(WorkoutScheduleDto::fromEntity)
                .collect(Collectors.toList());
        return ResponseEntity.ok(scheduleDtos);
    }
    
    /**
     * Сгенерировать расписание для тренировки (только предварительный просмотр)
     */
    @PostMapping("/generate")
    public ResponseEntity<List<WorkoutScheduleDto>> generateSchedule(
            @Valid @RequestBody ScheduleGenerationRequestDto request,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== POST /api/schedule/generate - GENERATE SCHEDULE PREVIEW ===");
        log.info("Generating schedule preview for workoutId: {}, startDate: {}, weeksCount: {}, dayOfWeek: {}", 
                request.getWorkoutId(), request.getStartDate(), request.getWeeksCount(), request.getDayOfWeek());
        
        User user = getCurrentUser(jwt);
        
        // Получаем тренировку по ID
        WorkoutDto workoutDto = workoutService.getWorkoutById(request.getWorkoutId(), user.getId());
        
        List<WorkoutSchedule> schedules = scheduleGenerationService.generateScheduleFromWorkout(
            workoutDto, request.getStartDate(), request.getWeeksCount(), user.getId()
        );
        
        // Конвертируем в DTO для ответа
        List<WorkoutScheduleDto> scheduleDtos = schedules.stream()
                .map(WorkoutScheduleDto::fromEntity)
                .collect(Collectors.toList());
        
        log.info("Generated {} weekly schedule previews", scheduleDtos.size());
        return ResponseEntity.ok(scheduleDtos);
    }
    
    /**
     * Создать расписания в БД на основе сгенерированного плана
     */
    @PostMapping("/create")
    public ResponseEntity<List<WorkoutScheduleDto>> createSchedules(
            @Valid @RequestBody List<WorkoutScheduleDto> scheduleDtos,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== POST /api/schedule/create - CREATE SCHEDULES IN DATABASE ===");
        log.info("Creating {} schedules in database", scheduleDtos.size());
        
        User user = getCurrentUser(jwt);
        
        // Проверяем что все расписания принадлежат текущему пользователю
        for (WorkoutScheduleDto dto : scheduleDtos) {
            if (!dto.getUserId().equals(user.getId())) {
                return ResponseEntity.badRequest().build();
            }
        }
        
        // Конвертируем DTO в сущности
        List<WorkoutSchedule> schedules = scheduleDtos.stream()
                .map(dto -> {
                    WorkoutSchedule schedule = dto.toEntity();
                    schedule.setUser(user);
                    // TODO: Получить Workout по ID
                    // schedule.setWorkout(workout);
                    return schedule;
                })
                .collect(Collectors.toList());
        
        List<WorkoutSchedule> createdSchedules = scheduleGenerationService.createSchedulesInDatabase(schedules);
        
        // Конвертируем обратно в DTO для ответа
        List<WorkoutScheduleDto> createdDtos = createdSchedules.stream()
                .map(WorkoutScheduleDto::fromEntity)
                .collect(Collectors.toList());
        
        log.info("Successfully created {} schedules in database", createdDtos.size());
        return ResponseEntity.ok(createdDtos);
    }
    
    /**
     * Обновить статус расписания
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<WorkoutScheduleDto> updateScheduleStatus(
            @PathVariable Long id,
            @RequestParam String status,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== PUT /api/schedule/{}/status - UPDATE SCHEDULE STATUS ===", id);
        log.info("Updating schedule {} status to: {}", id, status);
        
        User user = getCurrentUser(jwt);
        WorkoutSchedule updatedSchedule = workoutScheduleService.updateScheduleStatus(id, status, user.getId());
        return ResponseEntity.ok(WorkoutScheduleDto.fromEntity(updatedSchedule));
    }
    
    /**
     * Удалить расписание
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteSchedule(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        log.info("=== DELETE /api/schedule/{} - DELETE SCHEDULE ===", id);
        User user = getCurrentUser(jwt);
        workoutScheduleService.deleteSchedule(id, user.getId());
        return ResponseEntity.noContent().build();
    }
}
