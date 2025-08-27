package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.time.LocalTime;

@Entity
@Table(name = "set_executions")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SetExecution {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    // Связь с упражнением в расписании
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "workout_schedule_exercise_id", nullable = false)
    private WorkoutScheduleExercise workoutScheduleExercise;
    
    // Номер подхода
    @Column(name = "set_number", nullable = false)
    private Integer setNumber;
    
    // Планируемые значения для подхода
    @Column(name = "planned_weight")
    private Float plannedWeight;
    
    @Column(name = "planned_reps")
    private Integer plannedReps;
    
    // Фактические выполненные значения
    @Column(name = "actual_weight")
    private Float actualWeight;
    
    @Column(name = "actual_reps")
    private Integer actualReps;
    
    // Время выполнения подхода
    @Column(name = "start_time", nullable = false)
    private LocalTime startTime;
    
    @Column(name = "end_time")
    private LocalTime endTime;
    
    // Время отдыха после подхода
    @Column(name = "rest_time")
    private Integer restTime;
    
    // Заметка о выполнении
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    // Статус выполнения подхода
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private SetStatus status = SetStatus.PLANNED;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }
    
    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
    
    public enum SetStatus {
        PLANNED,        // Запланировано
        IN_PROGRESS,    // В процессе выполнения
        COMPLETED,      // Завершено
        SKIPPED,        // Пропущено
        FAILED          // Не удалось выполнить
    }
}
