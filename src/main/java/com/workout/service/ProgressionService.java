package com.workout.service;

import com.workout.dto.ProgressionDto;
import com.workout.entity.Exercise;
import com.workout.entity.Progression;
import com.workout.repository.ExerciseRepository;
import com.workout.repository.ProgressionRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ProgressionService {
    
    private final ProgressionRepository progressionRepository;
    private final ExerciseRepository exerciseRepository;
    
    /**
     * Получить прогрессию по ID упражнения (одна или пусто)
     */
    @Transactional(readOnly = true)
    public ProgressionDto getProgressionByExerciseId(Long exerciseId) {
        Progression progression = progressionRepository.findByExercise_Id(exerciseId)
                .orElse(null);
        return progression != null ? convertToDto(progression) : null;
    }

    /**
     * Совместимость с контроллером: вернуть список (0 или 1 элемент)
     */
    @Transactional(readOnly = true)
    public java.util.List<ProgressionDto> getProgressionsByExerciseId(Long exerciseId) {
        ProgressionDto dto = getProgressionByExerciseId(exerciseId);
        return dto == null ? java.util.List.of() : java.util.List.of(dto);
    }
    
    /**
     * Создать прогрессию для упражнения
     */
    public ProgressionDto createProgression(ProgressionDto progressionDto) {
        // В DTO приходит exerciseTemplateId по предыдущим версиям; для текущей модели нужна привязка к Exercise
        // Ожидаем, что в progressionDto передают ID упражнения (в рамках Workout), не шаблона
        Exercise exercise = exerciseRepository.findById(progressionDto.getExerciseTemplateId())
                .orElseThrow(() -> new RuntimeException("Exercise not found"));
        
        Progression progression = new Progression();
        progression.setExercise(exercise);
        progression.setWeightProgressionEnabled(progressionDto.getWeightProgressionEnabled());
        progression.setRepsProgressionEnabled(progressionDto.getRepsProgressionEnabled());
        progression.setSetsProgressionEnabled(progressionDto.getSetsProgressionEnabled());
        progression.setWeightPeriodicity(progressionDto.getWeightPeriodicity());
        progression.setRepsPeriodicity(progressionDto.getRepsPeriodicity());
        progression.setSetsPeriodicity(progressionDto.getSetsPeriodicity());
        progression.setWeightIncrementType(progressionDto.getWeightIncrementType());
        progression.setRepsIncrementType(progressionDto.getRepsIncrementType());
        progression.setSetsIncrementType(progressionDto.getSetsIncrementType());
        progression.setWeightIncrementValue(progressionDto.getWeightIncrementValue());
        progression.setRepsIncrementValue(progressionDto.getRepsIncrementValue());
        progression.setSetsIncrementValue(progressionDto.getSetsIncrementValue());
        progression.setRepsInitialValue(progressionDto.getRepsInitialValue());
        progression.setRepsFinalValue(progressionDto.getRepsFinalValue());
        progression.setSetsInitialValue(progressionDto.getSetsInitialValue());
        progression.setSetsFinalValue(progressionDto.getSetsFinalValue());
        progression.setWeightConditionSets(progressionDto.getWeightConditionSets());
        progression.setWeightConditionReps(progressionDto.getWeightConditionReps());
        progression.setSetsConditionReps(progressionDto.getSetsConditionReps());
        progression.setIsActive(progressionDto.getIsActive());
        
        Progression savedProgression = progressionRepository.save(progression);
        return convertToDto(savedProgression);
    }
    
    /**
     * Обновить прогрессию
     */
    public ProgressionDto updateProgression(Long id, ProgressionDto progressionDto) {
        Progression progression = progressionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Progression not found"));
        
        progression.setWeightProgressionEnabled(progressionDto.getWeightProgressionEnabled());
        progression.setRepsProgressionEnabled(progressionDto.getRepsProgressionEnabled());
        progression.setSetsProgressionEnabled(progressionDto.getSetsProgressionEnabled());
        progression.setWeightPeriodicity(progressionDto.getWeightPeriodicity());
        progression.setRepsPeriodicity(progressionDto.getRepsPeriodicity());
        progression.setSetsPeriodicity(progressionDto.getSetsPeriodicity());
        progression.setWeightIncrementType(progressionDto.getWeightIncrementType());
        progression.setRepsIncrementType(progressionDto.getRepsIncrementType());
        progression.setSetsIncrementType(progressionDto.getSetsIncrementType());
        progression.setWeightIncrementValue(progressionDto.getWeightIncrementValue());
        progression.setRepsIncrementValue(progressionDto.getRepsIncrementValue());
        progression.setSetsIncrementValue(progressionDto.getSetsIncrementValue());
        progression.setRepsInitialValue(progressionDto.getRepsInitialValue());
        progression.setRepsFinalValue(progressionDto.getRepsFinalValue());
        progression.setSetsInitialValue(progressionDto.getSetsInitialValue());
        progression.setSetsFinalValue(progressionDto.getSetsFinalValue());
        progression.setWeightConditionSets(progressionDto.getWeightConditionSets());
        progression.setWeightConditionReps(progressionDto.getWeightConditionReps());
        progression.setSetsConditionReps(progressionDto.getSetsConditionReps());
        progression.setIsActive(progressionDto.getIsActive());
        
        Progression savedProgression = progressionRepository.save(progression);
        return convertToDto(savedProgression);
    }
    
    /**
     * Удалить прогрессию
     */
    public void deleteProgression(Long id) {
        progressionRepository.deleteById(id);
    }
    
    /**
     * Активировать прогрессию
     */
    public ProgressionDto activateProgression(Long id) {
        Progression progression = progressionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Progression not found"));
        progression.setIsActive(true);
        Progression saved = progressionRepository.save(progression);
        return convertToDto(saved);
    }
    
    /**
     * Деактивировать прогрессию
     */
    public ProgressionDto deactivateProgression(Long id) {
        Progression progression = progressionRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Progression not found"));
        progression.setIsActive(false);
        Progression saved = progressionRepository.save(progression);
        return convertToDto(saved);
    }
    
    /**
     * Конвертация в DTO
     */
    private ProgressionDto convertToDto(Progression progression) {
        ProgressionDto dto = new ProgressionDto();
        dto.setId(progression.getId());
        dto.setExerciseTemplateId(progression.getExercise().getExerciseTemplate().getId());
        dto.setWeightProgressionEnabled(progression.getWeightProgressionEnabled());
        dto.setRepsProgressionEnabled(progression.getRepsProgressionEnabled());
        dto.setSetsProgressionEnabled(progression.getSetsProgressionEnabled());
        dto.setWeightPeriodicity(progression.getWeightPeriodicity());
        dto.setRepsPeriodicity(progression.getRepsPeriodicity());
        dto.setSetsPeriodicity(progression.getSetsPeriodicity());
        dto.setWeightIncrementType(progression.getWeightIncrementType());
        dto.setRepsIncrementType(progression.getRepsIncrementType());
        dto.setSetsIncrementType(progression.getSetsIncrementType());
        dto.setWeightIncrementValue(progression.getWeightIncrementValue());
        dto.setRepsIncrementValue(progression.getRepsIncrementValue());
        dto.setSetsIncrementValue(progression.getSetsIncrementValue());
        dto.setRepsInitialValue(progression.getRepsInitialValue());
        dto.setRepsFinalValue(progression.getRepsFinalValue());
        dto.setSetsInitialValue(progression.getSetsInitialValue());
        dto.setSetsFinalValue(progression.getSetsFinalValue());
        dto.setWeightConditionSets(progression.getWeightConditionSets());
        dto.setWeightConditionReps(progression.getWeightConditionReps());
        dto.setSetsConditionReps(progression.getSetsConditionReps());
        dto.setIsActive(progression.getIsActive());
        
        // Дополнительная информация
        if (progression.getExercise().getExerciseTemplate() != null) {
            dto.setExerciseTemplateName(progression.getExercise().getExerciseTemplate().getName());
            if (progression.getExercise().getExerciseTemplate().getMuscleGroup() != null) {
                dto.setMuscleGroupName(progression.getExercise().getExerciseTemplate().getMuscleGroup().getName());
            }
            if (progression.getExercise().getExerciseTemplate().getEquipment() != null) {
                dto.setEquipmentName(progression.getExercise().getExerciseTemplate().getEquipment().getName());
            }
        }
        
        return dto;
    }
}
