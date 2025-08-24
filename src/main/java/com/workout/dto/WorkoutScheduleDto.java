package com.workout.dto;

import com.workout.entity.WorkoutSchedule;
import com.workout.entity.WorkoutScheduleExercise;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.Valid;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DTO для расписания тренировок
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutScheduleDto {
    
    private Long id;
    
    @NotNull(message = "User ID is required")
    private Long userId;
    
    @NotNull(message = "Workout ID is required")
    private Long workoutId;
    
    @NotNull(message = "Workout date is required")
    private LocalDate workoutDate;
    
    @NotNull(message = "Week number is required")
    @Min(value = 1, message = "Week number must be at least 1")
    private Integer weekNumber;
    
    @NotNull(message = "Status is required")
    private String status;
    
    private String startTime;
    private String endTime;
    private String notes;
    
    @Valid
    private List<WorkoutScheduleExerciseDto> exercises;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Дополнительные поля для удобства
    private String workoutName;
    private String userName;
    
    /**
     * Конвертирует сущность в DTO
     */
    public static WorkoutScheduleDto fromEntity(WorkoutSchedule schedule) {
        WorkoutScheduleDto dto = new WorkoutScheduleDto();
        dto.setId(schedule.getId());
        dto.setUserId(schedule.getUser().getId());
        dto.setWorkoutId(schedule.getWorkout().getId());
        dto.setWorkoutDate(schedule.getWorkoutDate());
        dto.setWeekNumber(schedule.getWeekNumber());
        dto.setStatus(schedule.getStatus().name());
        dto.setStartTime(schedule.getStartTime() != null ? schedule.getStartTime().toString() : null);
        dto.setEndTime(schedule.getEndTime() != null ? schedule.getEndTime().toString() : null);
        dto.setNotes(schedule.getNotes());
        dto.setCreatedAt(schedule.getCreatedAt());
        dto.setUpdatedAt(schedule.getUpdatedAt());
        
        // Дополнительные поля
        if (schedule.getWorkout() != null) {
            dto.setWorkoutName(schedule.getWorkout().getName());
        }
        if (schedule.getUser() != null) {
            dto.setUserName(schedule.getUser().getUsername());
        }
        
        // Конвертируем упражнения
        if (schedule.getExercises() != null) {
            dto.setExercises(schedule.getExercises().stream()
                    .map(WorkoutScheduleExerciseDto::fromEntity)
                    .collect(Collectors.toList()));
        }
        
        return dto;
    }
    
    /**
     * Конвертирует DTO в сущность (без ID для создания)
     */
    public WorkoutSchedule toEntity() {
        WorkoutSchedule schedule = new WorkoutSchedule();
        schedule.setWorkoutDate(this.workoutDate);
        schedule.setWeekNumber(this.weekNumber);
        schedule.setStatus(WorkoutSchedule.ExecutionStatus.valueOf(this.status));
        schedule.setNotes(this.notes);
        schedule.setCreatedAt(LocalDateTime.now());
        schedule.setUpdatedAt(LocalDateTime.now());
        
        // Время выполнения
        if (this.startTime != null) {
            schedule.setStartTime(java.time.LocalTime.parse(this.startTime));
        }
        if (this.endTime != null) {
            schedule.setEndTime(java.time.LocalTime.parse(this.endTime));
        }
        
        return schedule;
    }
}
