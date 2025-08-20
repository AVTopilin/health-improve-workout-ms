package com.workout.service;

import com.workout.dto.EquipmentDto;
import com.workout.entity.Equipment;
import com.workout.entity.Equipment.EquipmentType;
import com.workout.repository.EquipmentRepository;
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
public class EquipmentService {
    
    private final EquipmentRepository equipmentRepository;
    
    /**
     * Получить все активное оборудование
     */
    @Transactional(readOnly = true)
    public List<EquipmentDto> getAllActiveEquipment() {
        return equipmentRepository.findByIsActiveTrue()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить оборудование по ID
     */
    @Transactional(readOnly = true)
    public EquipmentDto getEquipmentById(Long id) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Оборудование не найдено с ID: " + id));
        return convertToDto(equipment);
    }
    
    /**
     * Получить оборудование по типу
     */
    @Transactional(readOnly = true)
    public List<EquipmentDto> getEquipmentByType(String type) {
        EquipmentType equipmentType = EquipmentType.valueOf(type.toUpperCase());
        return equipmentRepository.findByType(equipmentType)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить оборудование с шаблонами упражнений
     */
    @Transactional(readOnly = true)
    public List<EquipmentDto> getEquipmentWithExercises() {
        return equipmentRepository.findByIsActiveTrueAndExerciseTemplatesIsNotNull()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Создать новое оборудование
     */
    public EquipmentDto createEquipment(EquipmentDto dto) {
        Equipment equipment = convertToEntity(dto);
        equipment.setIsActive(true);
        equipment.setCreatedAt(LocalDateTime.now());
        equipment.setUpdatedAt(LocalDateTime.now());
        
        Equipment saved = equipmentRepository.save(equipment);
        return convertToDto(saved);
    }
    
    /**
     * Обновить оборудование
     */
    public EquipmentDto updateEquipment(Long id, EquipmentDto dto) {
        Equipment existing = equipmentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Оборудование не найдено с ID: " + id));
        
        existing.setName(dto.getName());
        existing.setDescription(dto.getDescription());
        existing.setType(EquipmentType.valueOf(dto.getType().toUpperCase()));
        existing.setUpdatedAt(LocalDateTime.now());
        
        Equipment saved = equipmentRepository.save(existing);
        return convertToDto(saved);
    }
    
    /**
     * Деактивировать оборудование
     */
    public void deactivateEquipment(Long id) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Оборудование не найдено с ID: " + id));
        
        equipment.setIsActive(false);
        equipment.setUpdatedAt(LocalDateTime.now());
        equipmentRepository.save(equipment);
    }
    
    /**
     * Активировать оборудование
     */
    public EquipmentDto activateEquipment(Long id) {
        Equipment equipment = equipmentRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Оборудование не найдено с ID: " + id));
        
        equipment.setIsActive(true);
        equipment.setUpdatedAt(LocalDateTime.now());
        
        Equipment saved = equipmentRepository.save(equipment);
        return convertToDto(saved);
    }
    
    /**
     * Конвертация в DTO
     */
    private EquipmentDto convertToDto(Equipment equipment) {
        EquipmentDto dto = new EquipmentDto();
        dto.setId(equipment.getId());
        dto.setName(equipment.getName());
        dto.setDescription(equipment.getDescription());
        dto.setType(equipment.getType() != null ? equipment.getType().name() : null);
        dto.setIsActive(equipment.getIsActive());
        dto.setExerciseTemplateCount(equipment.getExerciseTemplates() != null ? 
                (long) equipment.getExerciseTemplates().size() : 0L);
        return dto;
    }
    
    /**
     * Конвертация в Entity
     */
    private Equipment convertToEntity(EquipmentDto dto) {
        Equipment equipment = new Equipment();
        equipment.setName(dto.getName());
        equipment.setDescription(dto.getDescription());
        if (dto.getType() != null) {
            equipment.setType(EquipmentType.valueOf(dto.getType().toUpperCase()));
        }
        if (dto.getIsActive() != null) {
            equipment.setIsActive(dto.getIsActive());
        }
        return equipment;
    }
}
