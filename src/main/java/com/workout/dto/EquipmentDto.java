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
    
    private Long exerciseTemplateCount; // Количество упражнений с этим оборудованием
    
    public enum EquipmentType {
        DUMBBELLS,      // Гантели
        BARBELL,        // Штанга
        KETTLEBELL,     // Гиря
        RESISTANCE_BAND, // Резиновая лента
        BODYWEIGHT,     // Собственный вес
        MACHINE,        // Тренажер
        CABLE,          // Блочный тренажер
        STABILITY_BALL, // Фитбол
        MEDICINE_BALL,  // Медицинский мяч
        OTHER           // Другое
    }
}
