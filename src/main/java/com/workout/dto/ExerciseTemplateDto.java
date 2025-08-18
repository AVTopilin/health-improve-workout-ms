package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseTemplateDto {
    private Long id;
    
    @NotBlank(message = "Exercise name is required")
    private String name;
    
    private String description;
    
    private String instructions;
    
    private String tips;
    
    @NotNull(message = "Difficulty level is required")
    private String difficultyLevel;
    
    @NotNull(message = "Muscle group is required")
    private Long muscleGroupId;
    
    private String muscleGroupName;
    
    @NotNull(message = "Equipment is required")
    private Long equipmentId;
    
    private String equipmentName;
    
    private List<ExerciseMediaDto> media;
    
    private Boolean isActive = true;
    
    private Long exerciseCount; // Количество раз использования в тренировках
    
    public enum DifficultyLevel {
        BEGINNER,    // Начинающий
        INTERMEDIATE, // Средний
        ADVANCED,    // Продвинутый
        EXPERT       // Эксперт
    }
}
