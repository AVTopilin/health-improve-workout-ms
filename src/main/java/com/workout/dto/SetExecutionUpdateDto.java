package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import java.time.LocalTime;

/**
 * DTO для обновления статуса и времени выполнения подхода
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SetExecutionUpdateDto {
    
    @NotNull(message = "Status is required")
    private String status;
    
    private LocalTime startTime;
    private LocalTime endTime;
    
    // Фактические выполненные значения
    private Float actualWeight;
    private Integer actualReps;
    
    // Время отдыха после подхода
    private Integer restTime;
    
    private String notes;
}
