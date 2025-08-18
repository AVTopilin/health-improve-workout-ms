package com.workout.repository;

import com.workout.entity.Progression;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;
import java.util.List;

@Repository
public interface ProgressionRepository extends JpaRepository<Progression, Long> {
    
    // Поиск прогрессий по пользователю
    List<Progression> findByUser_IdOrderByCreatedAtDesc(Long userId);
    
    // Поиск активных прогрессий по пользователю
    List<Progression> findByUser_IdAndIsActiveTrueOrderByCreatedAtDesc(Long userId);
    
    // Поиск прогрессий по шаблону упражнения
    List<Progression> findByExercise_ExerciseTemplate_IdOrderByCreatedAtDesc(Long exerciseTemplateId);
    
    // Поиск активных прогрессий по шаблону упражнения
    List<Progression> findByExercise_ExerciseTemplate_IdAndIsActiveTrueOrderByCreatedAtDesc(Long exerciseTemplateId);
    
    // Поиск прогрессий по пользователю и шаблону упражнения
    List<Progression> findByUser_IdAndExercise_ExerciseTemplate_IdOrderByCreatedAtDesc(Long userId, Long exerciseTemplateId);
    
    // Поиск активных прогрессий по пользователю и шаблону упражнения
    List<Progression> findByUser_IdAndExercise_ExerciseTemplate_IdAndIsActiveTrueOrderByCreatedAtDesc(Long userId, Long exerciseTemplateId);
    
    // Поиск прогрессии по упражнению (One-to-One связь)
    java.util.Optional<Progression> findByExercise_Id(Long exerciseId);
}
