package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.DecimalMin;
import jakarta.validation.constraints.NotBlank;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseDto {
    private Long id;
    
    @NotNull(message = "Workout ID is required")
    private Long workoutId;
    
    @NotNull(message = "Exercise template is required")
    private Long exerciseTemplateId;
    
    // Информация из шаблона (для удобства)
    private String exerciseName;
    private String exerciseDescription;
    private String muscleGroupName;
    private String equipmentName;
    private String difficultyLevel;
    
    @NotNull(message = "Number of sets is required")
    @Min(value = 1, message = "Sets must be at least 1")
    private Integer sets;
    
    @NotNull(message = "Number of reps is required")
    @Min(value = 1, message = "Reps must be at least 1")
    private Integer reps;
    
    @NotNull(message = "Weight is required")
    @DecimalMin(value = "0.0", message = "Weight cannot be negative")
    private Float weight;
    
    @NotNull(message = "Rest time is required")
    @Min(value = 0, message = "Rest time cannot be negative")
    private Integer restTime;
    
    private Integer exerciseOrder; // Может быть null - будет установлен автоматически
    
    private String notes;
    
    // Вложенная прогрессия для упражнения
    private ProgressionDto progression;
}
