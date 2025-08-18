package com.workout.repository;

import com.workout.entity.MuscleGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface MuscleGroupRepository extends JpaRepository<MuscleGroup, Long> {
    
    /**
     * Найти все активные группы мышц
     */
    List<MuscleGroup> findByIsActiveTrue();
    
    /**
     * Найти активные группы мышц с шаблонами упражнений
     */
    List<MuscleGroup> findByIsActiveTrueAndExerciseTemplatesIsNotNull();
    
    /**
     * Подсчитать количество активных шаблонов упражнений по группе мышц
     */
    Long countByIsActiveTrueAndExerciseTemplatesIsNotNull();
}
