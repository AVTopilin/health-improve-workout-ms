package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import java.time.LocalTime;

/**
 * DTO для обновления статуса и времени выполнения упражнения
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutScheduleExerciseUpdateDto {
    
    @NotNull(message = "Status is required")
    private String status;
    
    private LocalTime startTime;
    private LocalTime endTime;
    
    // Фактические выполненные значения
    private Float actualWeight;
    private Integer actualReps;
    private Integer actualSets;
    private Integer actualRestTime;
    
    private String notes;
}
