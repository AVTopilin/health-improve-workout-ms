package com.workout.repository;

import com.workout.entity.WorkoutScheduleExercise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface WorkoutScheduleExerciseRepository extends JpaRepository<WorkoutScheduleExercise, Long> {
    
    /**
     * Найти все упражнения для расписания
     */
    List<WorkoutScheduleExercise> findByWorkoutScheduleId(Long workoutScheduleId);
    
    /**
     * Найти упражнения по ID расписания, отсортированные по порядку
     */
    List<WorkoutScheduleExercise> findByWorkoutScheduleIdOrderByExerciseOrder(Long workoutScheduleId);
    
    /**
     * Найти упражнения по статусу
     */
    List<WorkoutScheduleExercise> findByWorkoutScheduleIdAndStatus(Long workoutScheduleId, WorkoutScheduleExercise.ExerciseStatus status);
    
    /**
     * Найти упражнения по шаблону упражнения
     */
    List<WorkoutScheduleExercise> findByExerciseTemplateId(Long exerciseTemplateId);
    
    /**
     * Найти упражнения по расписанию и шаблону
     */
    List<WorkoutScheduleExercise> findByWorkoutScheduleIdAndExerciseTemplateId(Long workoutScheduleId, Long exerciseTemplateId);
    
    /**
     * Удалить все упражнения для расписания
     */
    void deleteByWorkoutScheduleId(Long workoutScheduleId);
}
