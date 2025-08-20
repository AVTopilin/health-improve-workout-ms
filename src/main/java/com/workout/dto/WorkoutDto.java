package com.workout.dto;

import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.databind.annotation.JsonDeserialize;
import com.workout.config.FlexibleLocalDateDeserializer;
import com.workout.config.FlexibleLocalDateTimeDeserializer;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutDto {
    private Long id;
    
    @NotBlank(message = "Workout name is required")
    private String name;
    
    private String description;
    
    @NotNull(message = "Day of week is required")
    private DayOfWeek dayOfWeek;
    
    @NotNull(message = "Weeks count is required")
    private Integer weeksCount;
    
    @NotNull(message = "Start date is required")
    @JsonDeserialize(using = FlexibleLocalDateDeserializer.class)
    private LocalDate startDate;
    
    private List<ExerciseDto> exercises;
    
    @JsonDeserialize(using = FlexibleLocalDateTimeDeserializer.class)
    private LocalDateTime createdAt;
    
    @JsonDeserialize(using = FlexibleLocalDateTimeDeserializer.class)
    private LocalDateTime updatedAt;
}
