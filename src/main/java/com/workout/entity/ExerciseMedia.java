package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "exercise_media")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseMedia {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_template_id", nullable = false)
    private ExerciseTemplate exerciseTemplate;
    
    @Column(nullable = false)
    private String fileName;
    
    @Column(nullable = false)
    private String originalFileName;
    
    @Column(nullable = false)
    private String contentType; // MIME тип файла
    
    @Column(nullable = false)
    private Long fileSize; // размер файла в байтах
    
    @Column(name = "minio_path", nullable = false)
    private String minioPath; // путь к файлу в MinIO
    
    @Column(name = "media_type", nullable = false)
    @Enumerated(EnumType.STRING)
    private MediaType mediaType;
    
    @Column(name = "display_order")
    private Integer displayOrder; // порядок отображения медиафайлов
    
    @Column(name = "is_primary")
    private Boolean isPrimary = false; // основной медиафайл для упражнения
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    public enum MediaType {
        IMAGE,      // Изображение (JPG, PNG, GIF)
        ANIMATION,  // Анимация (GIF, MP4)
        VIDEO       // Видео (MP4, AVI)
    }
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
