package com.workout.controller;

import com.workout.dto.WorkoutDto;
import com.workout.dto.WorkoutScheduleDto;
import com.workout.dto.WorkoutScheduleExerciseDto;
import com.workout.dto.ScheduleGenerationRequestDto;
import com.workout.dto.WorkoutScheduleStatusUpdateDto;
import com.workout.dto.WorkoutScheduleExerciseUpdateDto;
import com.workout.dto.SetExecutionDto;
import com.workout.dto.SetExecutionUpdateDto;
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
import com.workout.entity.Workout;
import com.workout.entity.WorkoutScheduleExercise;
import com.workout.entity.ExerciseTemplate;
import com.workout.repository.WorkoutRepository;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.entity.SetExecution;

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
    private final WorkoutRepository workoutRepository;
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    
    public WorkoutScheduleController(
            WorkoutScheduleService workoutScheduleService,
            WorkoutScheduleGenerationService scheduleGenerationService,
            WorkoutService workoutService,
            UserService userService,
            WorkoutRepository workoutRepository,
            ExerciseTemplateRepository exerciseTemplateRepository) {
        super(userService);
        this.workoutScheduleService = workoutScheduleService;
        this.scheduleGenerationService = scheduleGenerationService;
        this.workoutService = workoutService;
        this.workoutRepository = workoutRepository;
        this.exerciseTemplateRepository = exerciseTemplateRepository;
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
                    
                    // Получаем Workout по ID
                    WorkoutDto workoutDto = workoutService.getWorkoutById(dto.getWorkoutId(), user.getId());
                    Workout workout = workoutRepository.findById(workoutDto.getId())
                            .orElseThrow(() -> new RuntimeException("Workout not found"));
                    schedule.setWorkout(workout);
                    
                    // Устанавливаем упражнения
                    if (dto.getExercises() != null) {
                        List<WorkoutScheduleExercise> exercises = dto.getExercises().stream()
                                .map(exerciseDto -> {
                                    WorkoutScheduleExercise exercise = exerciseDto.toEntity();
                                    exercise.setWorkoutSchedule(schedule);
                                    
                                    // Получаем ExerciseTemplate
                                    ExerciseTemplate template = exerciseTemplateRepository.findById(exerciseDto.getExerciseTemplateId())
                                            .orElseThrow(() -> new RuntimeException("Exercise template not found"));
                                    exercise.setExerciseTemplate(template);
                                    
                                    return exercise;
                                })
                                .collect(Collectors.toList());
                        schedule.setExercises(exercises);
                    }
                    
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
     * Обновить статус расписания тренировки
     */
    @PutMapping("/{id}/status")
    public ResponseEntity<WorkoutScheduleDto> updateScheduleStatus(
            @PathVariable Long id,
            @Valid @RequestBody WorkoutScheduleStatusUpdateDto updateDto,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== PUT /api/schedule/{}/status - UPDATE SCHEDULE STATUS ===", id);
        log.info("Updating schedule status to: {}", updateDto.getStatus());
        
        User user = getCurrentUser(jwt);
        WorkoutSchedule schedule = workoutScheduleService.updateScheduleStatus(id, user.getId(), updateDto);
        return ResponseEntity.ok(WorkoutScheduleDto.fromEntity(schedule));
    }
    
    /**
     * Обновить статус упражнения в расписании
     */
    @PutMapping("/exercise/{exerciseId}/status")
    public ResponseEntity<WorkoutScheduleExerciseDto> updateExerciseStatus(
            @PathVariable Long exerciseId,
            @Valid @RequestBody WorkoutScheduleExerciseUpdateDto updateDto,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== PUT /api/schedule/exercise/{}/status - UPDATE EXERCISE STATUS ===", exerciseId);
        log.info("Updating exercise status to: {}", updateDto.getStatus());
        
        User user = getCurrentUser(jwt);
        WorkoutScheduleExercise exercise = workoutScheduleService.updateExerciseStatus(exerciseId, user.getId(), updateDto);
        return ResponseEntity.ok(WorkoutScheduleExerciseDto.fromEntity(exercise));
    }
    
    /**
     * Обновить статус подхода
     */
    @PutMapping("/set/{setId}/status")
    public ResponseEntity<SetExecutionDto> updateSetStatus(
            @PathVariable Long setId,
            @Valid @RequestBody SetExecutionUpdateDto updateDto,
            @AuthenticationPrincipal Jwt jwt) {
        log.info("=== PUT /api/schedule/set/{}/status - UPDATE SET STATUS ===", setId);
        log.info("Updating set status to: {}", updateDto.getStatus());
        
        User user = getCurrentUser(jwt);
        SetExecution setExecution = workoutScheduleService.updateSetStatus(setId, user.getId(), updateDto);
        return ResponseEntity.ok(SetExecutionDto.fromEntity(setExecution));
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
