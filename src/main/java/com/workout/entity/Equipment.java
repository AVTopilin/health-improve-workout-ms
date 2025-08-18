package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "equipment")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Equipment {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, unique = true)
    private String name;
    
    @Column(columnDefinition = "TEXT")
    private String description;
    
    @Column(name = "equipment_type")
    @Enumerated(EnumType.STRING)
    private EquipmentType type;
    
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
    
    @OneToMany(mappedBy = "equipment", fetch = FetchType.LAZY)
    private List<ExerciseTemplate> exerciseTemplates;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
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
