package com.workout.controller;

import com.workout.dto.WorkoutDto;
import com.workout.entity.User;
import com.workout.service.UserService;
import com.workout.service.WorkoutService;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;

@Slf4j
@RestController
@RequestMapping("/api/workouts")
@CrossOrigin(origins = "*")
public class WorkoutController extends BaseController {
    
    private final WorkoutService workoutService;
    
    public WorkoutController(WorkoutService workoutService, UserService userService) {
        super(userService);
        this.workoutService = workoutService;
    }
    
    @GetMapping
    public ResponseEntity<List<WorkoutDto>> getWorkouts(@AuthenticationPrincipal Jwt jwt) {
        log.info("=== GET /api/workouts - GET ALL WORKOUTS ===");
        User user = getCurrentUser(jwt);
        List<WorkoutDto> workouts = workoutService.getWorkoutsByUserId(user.getId());
        return ResponseEntity.ok(workouts);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<WorkoutDto> getWorkout(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        log.info("=== GET /api/workouts/{} - GET WORKOUT BY ID ===", id);
        User user = getCurrentUser(jwt);
        WorkoutDto workout = workoutService.getWorkoutById(id, user.getId());
        return ResponseEntity.ok(workout);
    }
    
    @PostMapping
    public ResponseEntity<WorkoutDto> createWorkout(@Valid @RequestBody WorkoutDto workoutDto, 
                                                   @AuthenticationPrincipal Jwt jwt) {
        log.info("=== POST /api/workouts - CREATE WORKOUT ===");
        log.info("Received workout creation request: {}", workoutDto);
        log.info("DTO fields - id: {}, name: {}, dayOfWeek: {}, weeksCount: {}, startDate: {}", 
                workoutDto.getId(), workoutDto.getName(), workoutDto.getDayOfWeek(), 
                workoutDto.getWeeksCount(), workoutDto.getStartDate());
        
        // Детальная диагностика входящих данных
        log.info("=== INCOMING DATA DIAGNOSTICS ===");
        log.info("DTO object: {}", workoutDto);
        log.info("DTO class: {}", workoutDto.getClass().getName());
        log.info("DTO toString: {}", workoutDto.toString());
        
        // Дополнительная диагностика JSON данных
        try {
            log.info("=== JSON VALIDATION DIAGNOSTICS ===");
            log.info("DTO validation passed");
            log.info("Name length: {}", workoutDto.getName() != null ? workoutDto.getName().length() : "null");
            log.info("DayOfWeek enum: {}", workoutDto.getDayOfWeek());
            log.info("StartDate: {}", workoutDto.getStartDate());
            log.info("WeeksCount: {}", workoutDto.getWeeksCount());
        } catch (Exception e) {
            log.error("Error during DTO validation: ", e);
        }
        
        // Дополнительная проверка обязательных полей
        if (workoutDto.getName() == null || workoutDto.getName().trim().isEmpty()) {
            log.error("Workout name is null or empty");
            return ResponseEntity.badRequest().build();
        }
        
        // Если фронтенд отправляет id = 0, это означает "создать новую тренировку"
        if (workoutDto.getId() != null && workoutDto.getId() == 0) {
            workoutDto.setId(null); // Убираем id для создания новой записи
            log.info("Setting id to null for new workout creation");
        }
        
        User user = getCurrentUser(jwt);
        log.info("Creating workout for user: {}", user.getId());
        
        try {
            WorkoutDto createdWorkout = workoutService.createWorkout(workoutDto, user);
            log.info("Workout created successfully: {}", createdWorkout.getId());
            return ResponseEntity.ok(createdWorkout);
        } catch (Exception e) {
            log.error("Error creating workout: ", e);
            throw e;
        }
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<WorkoutDto> updateWorkout(@PathVariable Long id, 
                                                   @Valid @RequestBody WorkoutDto workoutDto,
                                                   @AuthenticationPrincipal Jwt jwt) {
        log.info("=== PUT /api/workouts/{} - UPDATE WORKOUT ===", id);
        log.info("Updating workout with id: {}, DTO: {}", id, workoutDto);
        log.info("DTO fields - id: {}, name: {}, dayOfWeek: {}, weeksCount: {}, startDate: {}", 
                workoutDto.getId(), workoutDto.getName(), workoutDto.getDayOfWeek(), 
                workoutDto.getWeeksCount(), workoutDto.getStartDate());
        
        User user = getCurrentUser(jwt);
        WorkoutDto updatedWorkout = workoutService.updateWorkout(id, workoutDto, user.getId());
        return ResponseEntity.ok(updatedWorkout);
    }
    
    // Дополнительный endpoint для случаев, когда фронтенд отправляет PUT без ID
    @PutMapping
    public ResponseEntity<WorkoutDto> createOrUpdateWorkout(@Valid @RequestBody WorkoutDto workoutDto,
                                                           @AuthenticationPrincipal Jwt jwt) {
        log.info("=== PUT /api/workouts (no ID) - CREATE OR UPDATE WORKOUT ===");
        log.info("Received workout request: {}", workoutDto);
        
        // Если id = 0 или null, создаем новую тренировку
        if (workoutDto.getId() == null || workoutDto.getId() == 0) {
            log.info("Creating new workout via PUT endpoint");
            return createWorkout(workoutDto, jwt);
        } else {
            log.info("Updating existing workout via PUT endpoint with id: {}", workoutDto.getId());
            return updateWorkout(workoutDto.getId(), workoutDto, jwt);
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteWorkout(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        workoutService.deleteWorkout(id, user.getId());
        return ResponseEntity.noContent().build();
    }
}
