package com.workout.repository;

import com.workout.entity.Equipment;
import com.workout.entity.Equipment.EquipmentType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface EquipmentRepository extends JpaRepository<Equipment, Long> {
    
    /**
     * Найти все активное оборудование
     */
    List<Equipment> findByIsActiveTrue();
    
    /**
     * Найти оборудование по типу
     */
    List<Equipment> findByType(EquipmentType type);
    
    /**
     * Найти активное оборудование с шаблонами упражнений
     */
    List<Equipment> findByIsActiveTrueAndExerciseTemplatesIsNotNull();
    
    /**
     * Подсчитать количество активных шаблонов упражнений по оборудованию
     */
    Long countByIsActiveTrueAndExerciseTemplatesIsNotNull();
}
