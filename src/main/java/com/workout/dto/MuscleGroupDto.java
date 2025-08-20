package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class MuscleGroupDto {
    private Long id;
    
    @NotBlank(message = "Muscle group name is required")
    private String name;
    
    private String description;
    
    @Pattern(regexp = "^#[0-9A-Fa-f]{6}$", message = "Color code must be a valid HEX color")
    private String colorCode;
    
    private Boolean isActive;
    
    private Long exerciseTemplateCount; // Количество упражнений в этой группе
}
