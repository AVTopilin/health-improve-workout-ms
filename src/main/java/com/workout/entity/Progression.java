package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;

@Entity
@Table(name = "progressions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Progression {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    // Связь с конкретным упражнением в тренировке (One-to-One)
    @OneToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_id", nullable = false)
    private Exercise exercise;
    
    // Опции прогрессии (чекбоксы)
    @Column(name = "weight_progression_enabled", nullable = false)
    private Boolean weightProgressionEnabled = false;
    
    @Column(name = "reps_progression_enabled", nullable = false)
    private Boolean repsProgressionEnabled = false;
    
    @Column(name = "sets_progression_enabled", nullable = false)
    private Boolean setsProgressionEnabled = false;
    
    // Периодичность для каждого параметра
    @Enumerated(EnumType.STRING)
    @Column(name = "weight_periodicity")
    private PeriodicityType weightPeriodicity;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "reps_periodicity")
    private PeriodicityType repsPeriodicity;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "sets_periodicity")
    private PeriodicityType setsPeriodicity;
    
    // Тип инкремента для каждого параметра
    @Enumerated(EnumType.STRING)
    @Column(name = "weight_increment_type")
    private IncrementType weightIncrementType;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "reps_increment_type")
    private IncrementType repsIncrementType;
    
    @Enumerated(EnumType.STRING)
    @Column(name = "sets_increment_type")
    private IncrementType setsIncrementType;
    
    // Значения для инкрементов
    @Column(name = "weight_increment_value")
    private Float weightIncrementValue;
    
    @Column(name = "reps_increment_value")
    private Integer repsIncrementValue;
    
    @Column(name = "sets_increment_value")
    private Integer setsIncrementValue;
    
    // Начальные и конечные значения для циклов
    @Column(name = "weight_initial_value")
    private Float weightInitialValue;
    
    @Column(name = "weight_final_value")
    private Float weightFinalValue;
    
    @Column(name = "reps_initial_value")
    private Integer repsInitialValue;
    
    @Column(name = "reps_final_value")
    private Integer repsFinalValue;
    
    @Column(name = "sets_initial_value")
    private Integer setsInitialValue;
    
    @Column(name = "sets_final_value")
    private Integer setsFinalValue;
    
    // Условия для изменения (только для периодичности "при достижении условия")
    @Column(name = "weight_condition_sets")
    private Integer weightConditionSets;
    
    @Column(name = "weight_condition_reps")
    private Integer weightConditionReps;
    
    @Column(name = "sets_condition_reps")
    private Integer setsConditionReps;
    
    @Column(name = "is_active", nullable = false)
    private Boolean isActive = true;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Перечисления
    public enum PeriodicityType {
        FIXED,              // Фиксированная (не меняется)
        EVERY_WORKOUT,      // Каждая тренировка
        CONDITIONAL         // При достижении условия
    }
    
    public enum IncrementType {
        FIXED,              // Фиксированное значение
        INCREMENT,          // Инкремент
        CYCLE               // Цикл (начальное → конечное)
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
