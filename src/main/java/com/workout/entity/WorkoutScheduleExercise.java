package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Entity
@Table(name = "workout_schedule_exercises")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutScheduleExercise {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Расписание тренировок
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "workout_schedule_id", nullable = false)
    private WorkoutSchedule workoutSchedule;
    
    // Шаблон упражнения
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "exercise_template_id", nullable = false)
    private ExerciseTemplate exerciseTemplate;
    
    // Рассчитанные параметры для этой недели (по прогрессии)
    @Column(name = "planned_weight", nullable = false)
    private Float plannedWeight;
    
    @Column(name = "planned_reps", nullable = false)
    private Integer plannedReps;
    
    @Column(name = "planned_sets", nullable = false)
    private Integer plannedSets;
    
    @Column(name = "planned_rest_time", nullable = false)
    private Integer plannedRestTime;
    
    // Порядок выполнения
    @Column(name = "exercise_order", nullable = false)
    private Integer exerciseOrder;
    
    // Статус выполнения упражнения
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ExerciseStatus status = ExerciseStatus.PLANNED;
    
    // Время выполнения упражнения
    @Column(name = "start_time")
    private java.time.LocalTime startTime;
    
    @Column(name = "end_time")
    private java.time.LocalTime endTime;
    
    // Фактические выполненные значения
    @Column(name = "actual_weight")
    private Float actualWeight;
    
    @Column(name = "actual_reps")
    private Integer actualReps;
    
    @Column(name = "actual_sets")
    private Integer actualSets;
    
    @Column(name = "actual_rest_time")
    private Integer actualRestTime;
    
    // Комментарии
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    // Выполненные подходы (обратная связь)
    @OneToMany(mappedBy = "workoutScheduleExercise", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<SetExecution> setExecutions;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    public enum ExerciseStatus {
        PLANNED,        // Запланировано
        IN_PROGRESS,    // В процессе выполнения
        COMPLETED,      // Завершено
        SKIPPED        // Пропущено
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
