package com.workout.repository;

import com.workout.entity.Exercise;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ExerciseRepository extends JpaRepository<Exercise, Long> {
    List<Exercise> findByWorkoutIdOrderByExerciseOrder(Long workoutId);
    List<Exercise> findByWorkoutId(Long workoutId);
    void deleteByWorkoutId(Long workoutId);
    
    // Метод для поиска максимального порядка упражнений в тренировке
    @Query("SELECT COALESCE(MAX(e.exerciseOrder), 0) FROM Exercise e WHERE e.workout.id = :workoutId")
    Integer findMaxExerciseOrderByWorkoutId(@Param("workoutId") Long workoutId);
    
    // Метод для поиска упражнений по ID шаблона
    List<Exercise> findByExerciseTemplateId(Long exerciseTemplateId);
}
