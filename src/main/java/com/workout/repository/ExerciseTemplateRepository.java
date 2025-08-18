package com.workout.repository;

import com.workout.entity.ExerciseTemplate;
import com.workout.entity.ExerciseTemplate.DifficultyLevel;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExerciseTemplateRepository extends JpaRepository<ExerciseTemplate, Long> {
    
    /**
     * Найти все активные шаблоны упражнений
     */
    List<ExerciseTemplate> findByIsActiveTrue();
    
    /**
     * Найти шаблоны по группе мышц
     */
    List<ExerciseTemplate> findByMuscleGroupId(Long muscleGroupId);
    
    /**
     * Найти шаблоны по оборудованию
     */
    List<ExerciseTemplate> findByEquipmentId(Long equipmentId);
    
    /**
     * Найти шаблоны по уровню сложности
     */
    List<ExerciseTemplate> findByDifficultyLevel(DifficultyLevel difficultyLevel);
    
    /**
     * Поиск по названию или описанию
     */
    @Query("SELECT et FROM ExerciseTemplate et WHERE et.isActive = true AND (LOWER(et.name) LIKE LOWER(CONCAT('%', :query, '%')) OR LOWER(et.description) LIKE LOWER(CONCAT('%', :query, '%')))")
    Page<ExerciseTemplate> searchByNameOrDescription(@Param("query") String query, Pageable pageable);
    
    /**
     * Найти шаблоны по группе мышц и оборудованию
     */
    @Query("SELECT et FROM ExerciseTemplate et WHERE et.isActive = true AND et.muscleGroup.id = :muscleGroupId AND et.equipment.id = :equipmentId")
    List<ExerciseTemplate> findByMuscleGroupAndEquipment(@Param("muscleGroupId") Long muscleGroupId, @Param("equipmentId") Long equipmentId);
    
    /**
     * Подсчитать использование в тренировках
     */
    @Query("SELECT COUNT(e) FROM Exercise e WHERE e.exerciseTemplate.id = :templateId")
    Long countUsageInWorkouts(@Param("templateId") Long templateId);
}
