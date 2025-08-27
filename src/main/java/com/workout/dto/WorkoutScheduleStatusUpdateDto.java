package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import java.time.LocalTime;

/**
 * DTO для обновления статуса и времени выполнения тренировки
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutScheduleStatusUpdateDto {
    
    @NotNull(message = "Status is required")
    private String status;
    
    private LocalTime startTime;
    private LocalTime endTime;
    private String notes;
}
