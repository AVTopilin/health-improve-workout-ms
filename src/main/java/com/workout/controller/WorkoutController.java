package com.workout.controller;

import com.workout.dto.WorkoutDto;
import com.workout.entity.User;
import com.workout.service.UserService;
import com.workout.service.WorkoutService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;

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
        User user = getCurrentUser(jwt);
        List<WorkoutDto> workouts = workoutService.getWorkoutsByUserId(user.getId());
        return ResponseEntity.ok(workouts);
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<WorkoutDto> getWorkout(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        WorkoutDto workout = workoutService.getWorkoutById(id, user.getId());
        return ResponseEntity.ok(workout);
    }
    
    @PostMapping
    public ResponseEntity<WorkoutDto> createWorkout(@Valid @RequestBody WorkoutDto workoutDto, 
                                                   @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        WorkoutDto createdWorkout = workoutService.createWorkout(workoutDto, user);
        return ResponseEntity.ok(createdWorkout);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<WorkoutDto> updateWorkout(@PathVariable Long id, 
                                                   @Valid @RequestBody WorkoutDto workoutDto,
                                                   @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        WorkoutDto updatedWorkout = workoutService.updateWorkout(id, workoutDto, user.getId());
        return ResponseEntity.ok(updatedWorkout);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteWorkout(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        workoutService.deleteWorkout(id, user.getId());
        return ResponseEntity.noContent().build();
    }
}
