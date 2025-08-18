package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "exercise_templates")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class ExerciseTemplate {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(columnDefinition = "TEXT")
    private String instructions; // Пошаговые инструкции выполнения
    
    @Column(columnDefinition = "TEXT")
    private String tips; // Полезные советы и рекомендации
    
    @Column(name = "difficulty_level")
    @Enumerated(EnumType.STRING)
    private DifficultyLevel difficultyLevel;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "muscle_group_id", nullable = false)
    private MuscleGroup muscleGroup;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "equipment_id", nullable = false)
    private Equipment equipment;
    
    @OneToMany(mappedBy = "exerciseTemplate", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<ExerciseMedia> media;
    
    @OneToMany(mappedBy = "exerciseTemplate", fetch = FetchType.LAZY)
    private List<Exercise> exercises; // Связь с конкретными упражнениями в тренировках
    
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    public enum DifficultyLevel {
        BEGINNER,    // Начинающий
        INTERMEDIATE, // Средний
        ADVANCED,    // Продвинутый
        EXPERT       // Эксперт
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
