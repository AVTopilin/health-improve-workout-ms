package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseMediaDto {
    private Long id;
    
    @NotNull(message = "Exercise template ID is required")
    private Long exerciseTemplateId;
    
    private String fileName;
    
    private String originalFileName;
    
    private String contentType;
    
    private Long fileSize;
    
    private String minioPath;
    
    @NotNull(message = "Media type is required")
    private String mediaType;
    
    @Min(value = 1, message = "Display order must be at least 1")
    private Integer displayOrder;
    
    private Boolean isPrimary = false;
    
    // URL для доступа к файлу (генерируется на основе minioPath)
    private String accessUrl;
    
    public enum MediaType {
        IMAGE,      // Изображение (JPG, PNG, GIF)
        ANIMATION,  // Анимация (GIF, MP4)
        VIDEO       // Видео (MP4, AVI)
    }
}
