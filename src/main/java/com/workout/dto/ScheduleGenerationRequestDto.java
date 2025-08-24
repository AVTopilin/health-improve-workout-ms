package com.workout.dto;

import lombok.Data;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.Max;
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;

/**
 * DTO для запроса генерации расписания тренировок
 */
@Data
public class ScheduleGenerationRequestDto {
    
    @NotNull(message = "Day of week is required")
    @Min(value = 1, message = "Day of week must be between 1 and 7")
    @Max(value = 7, message = "Day of week must be between 1 and 7")
    private Integer dayOfWeek;
    
    @NotNull(message = "Start date is required")
    @DateTimeFormat(iso = DateTimeFormat.ISO.DATE)
    private LocalDate startDate;
    
    @NotNull(message = "Weeks count is required")
    @Min(value = 1, message = "Weeks count must be at least 1")
    @Max(value = 52, message = "Weeks count cannot exceed 52")
    private Integer weeksCount;
    
    @NotNull(message = "Workout ID is required")
    private Long workoutId;
}
