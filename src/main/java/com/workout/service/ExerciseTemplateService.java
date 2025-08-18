package com.workout.service;

import com.workout.dto.ExerciseTemplateDto;
import com.workout.entity.ExerciseTemplate;
import com.workout.entity.MuscleGroup;
import com.workout.entity.Equipment;
import com.workout.entity.ExerciseTemplate.DifficultyLevel;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.repository.MuscleGroupRepository;
import com.workout.repository.EquipmentRepository;
import com.workout.service.MinioService;
import lombok.RequiredArgsConstructor;
import org.springframework.data.domain.PageRequest;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ExerciseTemplateService {
    
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    private final MuscleGroupRepository muscleGroupRepository;
    private final EquipmentRepository equipmentRepository;
    private final MinioService minioService;
    
    /**
     * Получить все активные шаблоны упражнений
     */
    @Transactional(readOnly = true)
    public List<ExerciseTemplateDto> getAllActiveTemplates() {
        return exerciseTemplateRepository.findByIsActiveTrue()
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить шаблон упражнения по ID
     */
    @Transactional(readOnly = true)
    public ExerciseTemplateDto getTemplateById(Long id) {
        ExerciseTemplate template = exerciseTemplateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + id));
        return convertToDto(template);
    }
    
    /**
     * Поиск шаблонов по названию или описанию
     */
    @Transactional(readOnly = true)
    public List<ExerciseTemplateDto> searchTemplates(String query, int page, int size) {
        return exerciseTemplateRepository.searchByNameOrDescription(query, PageRequest.of(page, size))
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить шаблоны по группе мышц
     */
    @Transactional(readOnly = true)
    public List<ExerciseTemplateDto> getTemplatesByMuscleGroup(Long muscleGroupId) {
        return exerciseTemplateRepository.findByMuscleGroupId(muscleGroupId)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить шаблоны по оборудованию
     */
    @Transactional(readOnly = true)
    public List<ExerciseTemplateDto> getTemplatesByEquipment(Long equipmentId) {
        return exerciseTemplateRepository.findByEquipmentId(equipmentId)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить шаблоны по уровню сложности
     */
    @Transactional(readOnly = true)
    public List<ExerciseTemplateDto> getTemplatesByDifficulty(String difficulty) {
        DifficultyLevel difficultyLevel = DifficultyLevel.valueOf(difficulty.toUpperCase());
        return exerciseTemplateRepository.findByDifficultyLevel(difficultyLevel)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Создать новый шаблон упражнения
     */
    public ExerciseTemplateDto createTemplate(ExerciseTemplateDto dto) {
        ExerciseTemplate template = convertToEntity(dto);
        template.setIsActive(true);
        template.setCreatedAt(LocalDateTime.now());
        template.setUpdatedAt(LocalDateTime.now());
        
        ExerciseTemplate saved = exerciseTemplateRepository.save(template);
        return convertToDto(saved);
    }
    
    /**
     * Обновить шаблон упражнения
     */
    public ExerciseTemplateDto updateTemplate(Long id, ExerciseTemplateDto dto) {
        ExerciseTemplate existing = exerciseTemplateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + id));
        
        existing.setName(dto.getName());
        existing.setDescription(dto.getDescription());
        existing.setInstructions(dto.getInstructions());
        existing.setTips(dto.getTips());
        existing.setDifficultyLevel(DifficultyLevel.valueOf(dto.getDifficultyLevel().toUpperCase()));
        
        if (dto.getMuscleGroupId() != null) {
            MuscleGroup muscleGroup = muscleGroupRepository.findById(dto.getMuscleGroupId())
                    .orElseThrow(() -> new RuntimeException("Группа мышц не найдена с ID: " + dto.getMuscleGroupId()));
            existing.setMuscleGroup(muscleGroup);
        }
        
        if (dto.getEquipmentId() != null) {
            Equipment equipment = equipmentRepository.findById(dto.getEquipmentId())
                    .orElseThrow(() -> new RuntimeException("Оборудование не найдено с ID: " + dto.getEquipmentId()));
            existing.setEquipment(equipment);
        }
        
        existing.setUpdatedAt(LocalDateTime.now());
        
        ExerciseTemplate saved = exerciseTemplateRepository.save(existing);
        return convertToDto(saved);
    }
    
    /**
     * Деактивировать шаблон упражнения
     */
    public void deactivateTemplate(Long id) {
        ExerciseTemplate template = exerciseTemplateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + id));
        
        template.setIsActive(false);
        template.setUpdatedAt(LocalDateTime.now());
        exerciseTemplateRepository.save(template);
    }
    
    /**
     * Активировать шаблон упражнения
     */
    public ExerciseTemplateDto activateTemplate(Long id) {
        ExerciseTemplate template = exerciseTemplateRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + id));
        
        template.setIsActive(true);
        template.setUpdatedAt(LocalDateTime.now());
        
        ExerciseTemplate saved = exerciseTemplateRepository.save(template);
        return convertToDto(saved);
    }
    
    /**
     * Загрузить медиа файл для упражнения
     */
    public ExerciseTemplateDto uploadMedia(Long templateId, MultipartFile file, String mediaType, boolean isPrimary) {
        ExerciseTemplate template = exerciseTemplateRepository.findById(templateId)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + templateId));
        
        // Здесь должна быть логика загрузки медиа файла через MinioService
        // Пока возвращаем обновленный шаблон
        template.setUpdatedAt(LocalDateTime.now());
        
        ExerciseTemplate saved = exerciseTemplateRepository.save(template);
        return convertToDto(saved);
    }
    
    /**
     * Удалить медиа файл
     */
    public void deleteMedia(Long templateId, Long mediaId) {
        ExerciseTemplate template = exerciseTemplateRepository.findById(templateId)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + templateId));
        
        // Здесь должна быть логика удаления медиа файла
        template.setUpdatedAt(LocalDateTime.now());
        exerciseTemplateRepository.save(template);
    }
    
    /**
     * Конвертация в DTO
     */
    private ExerciseTemplateDto convertToDto(ExerciseTemplate template) {
        ExerciseTemplateDto dto = new ExerciseTemplateDto();
        dto.setId(template.getId());
        dto.setName(template.getName());
        dto.setDescription(template.getDescription());
        dto.setInstructions(template.getInstructions());
        dto.setTips(template.getTips());
        dto.setDifficultyLevel(template.getDifficultyLevel().name());
        
        if (template.getMuscleGroup() != null) {
            dto.setMuscleGroupId(template.getMuscleGroup().getId());
            dto.setMuscleGroupName(template.getMuscleGroup().getName());
        }
        
        if (template.getEquipment() != null) {
            dto.setEquipmentId(template.getEquipment().getId());
            dto.setEquipmentName(template.getEquipment().getName());
        }
        
        dto.setIsActive(template.getIsActive());
        dto.setExerciseCount(template.getExercises() != null ? (long) template.getExercises().size() : 0L);
        
        return dto;
    }
    
    /**
     * Конвертация в Entity
     */
    private ExerciseTemplate convertToEntity(ExerciseTemplateDto dto) {
        ExerciseTemplate template = new ExerciseTemplate();
        template.setName(dto.getName());
        template.setDescription(dto.getDescription());
        template.setInstructions(dto.getInstructions());
        template.setTips(dto.getTips());
        template.setDifficultyLevel(DifficultyLevel.valueOf(dto.getDifficultyLevel().toUpperCase()));
        
        if (dto.getMuscleGroupId() != null) {
            MuscleGroup muscleGroup = muscleGroupRepository.findById(dto.getMuscleGroupId())
                    .orElseThrow(() -> new RuntimeException("Группа мышц не найдена с ID: " + dto.getMuscleGroupId()));
            template.setMuscleGroup(muscleGroup);
        }
        
        if (dto.getEquipmentId() != null) {
            Equipment equipment = equipmentRepository.findById(dto.getEquipmentId())
                    .orElseThrow(() -> new RuntimeException("Оборудование не найдено с ID: " + dto.getEquipmentId()));
            template.setEquipment(equipment);
        }
        
        return template;
    }
}
