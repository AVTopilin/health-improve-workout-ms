package com.workout.entity;

import jakarta.persistence.*;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

@Entity
@Table(name = "workout_schedules")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutSchedule {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id", nullable = false)
    private User user;
    
    // Шаблон тренировки
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "workout_id", nullable = false)
    private Workout workout;
    
    // Конкретная дата тренировки
    @Column(name = "workout_date", nullable = false)
    private LocalDate workoutDate;
    
    // Номер недели в расписании
    @Column(name = "week_number", nullable = false)
    private Integer weekNumber;
    
    // Статус выполнения тренировки
    @Enumerated(EnumType.STRING)
    @Column(name = "status", nullable = false)
    private ExecutionStatus status = ExecutionStatus.PLANNED;
    
    // Время выполнения тренировки
    @Column(name = "start_time")
    private LocalTime startTime;
    
    @Column(name = "end_time")
    private LocalTime endTime;
    
    // Заметка о выполнении
    @Column(columnDefinition = "TEXT")
    private String notes;
    
    // Упражнения в расписании
    @OneToMany(mappedBy = "workoutSchedule", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<WorkoutScheduleExercise> exercises;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    public enum ExecutionStatus {
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
