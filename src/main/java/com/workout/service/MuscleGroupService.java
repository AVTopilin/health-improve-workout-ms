package com.workout.service;

import com.workout.dto.MuscleGroupDto;
import com.workout.entity.MuscleGroup;
import com.workout.repository.MuscleGroupRepository;
import com.workout.exception.NotFoundException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class MuscleGroupService {
    
    private final MuscleGroupRepository muscleGroupRepository;
    
    /**
     * Получить все активные группы мышц
     */
    @Transactional(readOnly = true)
    public List<MuscleGroupDto> getAllActiveMuscleGroups() {
        return muscleGroupRepository.findByIsActiveTrue()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить группу мышц по ID
     */
    @Transactional(readOnly = true)
    public MuscleGroupDto getMuscleGroupById(Long id) {
        MuscleGroup muscleGroup = muscleGroupRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Группа мышц не найдена с ID: " + id));
        return convertToDto(muscleGroup);
    }
    
    /**
     * Получить группы мышц с шаблонами упражнений
     */
    @Transactional(readOnly = true)
    public List<MuscleGroupDto> getMuscleGroupsWithExercises() {
        return muscleGroupRepository.findByIsActiveTrueAndExerciseTemplatesIsNotNull()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Создать новую группу мышц
     */
    public MuscleGroupDto createMuscleGroup(MuscleGroupDto dto) {
        MuscleGroup muscleGroup = convertToEntity(dto);
        muscleGroup.setIsActive(true);
        muscleGroup.setCreatedAt(LocalDateTime.now());
        muscleGroup.setUpdatedAt(LocalDateTime.now());
        
        MuscleGroup saved = muscleGroupRepository.save(muscleGroup);
        return convertToDto(saved);
    }
    
    /**
     * Обновить группу мышц
     */
    public MuscleGroupDto updateMuscleGroup(Long id, MuscleGroupDto dto) {
        MuscleGroup existing = muscleGroupRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Группа мышц не найдена с ID: " + id));
        
        existing.setName(dto.getName());
        existing.setDescription(dto.getDescription());
        existing.setColorCode(dto.getColorCode());
        existing.setUpdatedAt(LocalDateTime.now());
        
        MuscleGroup saved = muscleGroupRepository.save(existing);
        return convertToDto(saved);
    }
    
    /**
     * Деактивировать группу мышц
     */
    public void deactivateMuscleGroup(Long id) {
        MuscleGroup muscleGroup = muscleGroupRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Группа мышц не найдена с ID: " + id));
        
        muscleGroup.setIsActive(false);
        muscleGroup.setUpdatedAt(LocalDateTime.now());
        muscleGroupRepository.save(muscleGroup);
    }
    
    /**
     * Активировать группу мышц
     */
    public MuscleGroupDto activateMuscleGroup(Long id) {
        MuscleGroup muscleGroup = muscleGroupRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Группа мышц не найдена с ID: " + id));
        
        muscleGroup.setIsActive(true);
        muscleGroup.setUpdatedAt(LocalDateTime.now());
        
        MuscleGroup saved = muscleGroupRepository.save(muscleGroup);
        return convertToDto(saved);
    }
    
    /**
     * Конвертация в DTO
     */
    private MuscleGroupDto convertToDto(MuscleGroup muscleGroup) {
        MuscleGroupDto dto = new MuscleGroupDto();
        dto.setId(muscleGroup.getId());
        dto.setName(muscleGroup.getName());
        dto.setDescription(muscleGroup.getDescription());
        dto.setColorCode(muscleGroup.getColorCode());
        dto.setIsActive(muscleGroup.getIsActive());
        dto.setExerciseTemplateCount(muscleGroup.getExerciseTemplates() != null ? 
                (long) muscleGroup.getExerciseTemplates().size() : 0L);
        return dto;
    }
    
    /**
     * Конвертация в Entity
     */
    private MuscleGroup convertToEntity(MuscleGroupDto dto) {
        MuscleGroup muscleGroup = new MuscleGroup();
        muscleGroup.setName(dto.getName());
        muscleGroup.setDescription(dto.getDescription());
        muscleGroup.setColorCode(dto.getColorCode());
        if (dto.getIsActive() != null) {
            muscleGroup.setIsActive(dto.getIsActive());
        }
        return muscleGroup;
    }
}
