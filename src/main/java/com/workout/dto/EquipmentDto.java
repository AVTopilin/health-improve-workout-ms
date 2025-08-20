package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class EquipmentDto {
    private Long id;
    
    @NotBlank(message = "Equipment name is required")
    private String name;
    
    private String description;
    
    @NotNull(message = "Equipment type is required")
    private String type;
    
    private Boolean isActive;
    
    private Long exerciseTemplateCount; // Количество упражнений с этим оборудованием
}
