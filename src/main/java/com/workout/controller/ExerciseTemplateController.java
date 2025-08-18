package com.workout.controller;

import com.workout.dto.ExerciseTemplateDto;
import com.workout.service.ExerciseTemplateService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/exercise-templates")
@RequiredArgsConstructor
public class ExerciseTemplateController {
    
    private final ExerciseTemplateService exerciseTemplateService;
    
    /**
     * Получить все активные шаблоны упражнений
     */
    @GetMapping
    public ResponseEntity<List<ExerciseTemplateDto>> getAllActiveTemplates() {
        List<ExerciseTemplateDto> templates = exerciseTemplateService.getAllActiveTemplates();
        return ResponseEntity.ok(templates);
    }
    
    /**
     * Получить шаблон упражнения по ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ExerciseTemplateDto> getTemplateById(@PathVariable Long id) {
        ExerciseTemplateDto template = exerciseTemplateService.getTemplateById(id);
        return ResponseEntity.ok(template);
    }
    
    /**
     * Поиск шаблонов по названию или описанию
     */
    @GetMapping("/search")
    public ResponseEntity<List<ExerciseTemplateDto>> searchTemplates(
            @RequestParam String query,
            @RequestParam(defaultValue = "0") int page,
            @RequestParam(defaultValue = "20") int size) {
        List<ExerciseTemplateDto> templates = exerciseTemplateService.searchTemplates(query, page, size);
        return ResponseEntity.ok(templates);
    }
    
    /**
     * Получить шаблоны по группе мышц
     */
    @GetMapping("/muscle-group/{muscleGroupId}")
    public ResponseEntity<List<ExerciseTemplateDto>> getTemplatesByMuscleGroup(
            @PathVariable Long muscleGroupId) {
        List<ExerciseTemplateDto> templates = exerciseTemplateService.getTemplatesByMuscleGroup(muscleGroupId);
        return ResponseEntity.ok(templates);
    }
    
    /**
     * Получить шаблоны по оборудованию
     */
    @GetMapping("/equipment/{equipmentId}")
    public ResponseEntity<List<ExerciseTemplateDto>> getTemplatesByEquipment(
            @PathVariable Long equipmentId) {
        List<ExerciseTemplateDto> templates = exerciseTemplateService.getTemplatesByEquipment(equipmentId);
        return ResponseEntity.ok(templates);
    }
    
    /**
     * Получить шаблоны по уровню сложности
     */
    @GetMapping("/difficulty/{difficulty}")
    public ResponseEntity<List<ExerciseTemplateDto>> getTemplatesByDifficulty(
            @PathVariable String difficulty) {
        List<ExerciseTemplateDto> templates = exerciseTemplateService.getTemplatesByDifficulty(difficulty);
        return ResponseEntity.ok(templates);
    }
    
    /**
     * Создать новый шаблон упражнения
     */
    @PostMapping
    public ResponseEntity<ExerciseTemplateDto> createTemplate(@Valid @RequestBody ExerciseTemplateDto templateDto) {
        ExerciseTemplateDto created = exerciseTemplateService.createTemplate(templateDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    /**
     * Обновить шаблон упражнения
     */
    @PutMapping("/{id}")
    public ResponseEntity<ExerciseTemplateDto> updateTemplate(
            @PathVariable Long id, 
            @Valid @RequestBody ExerciseTemplateDto templateDto) {
        ExerciseTemplateDto updated = exerciseTemplateService.updateTemplate(id, templateDto);
        return ResponseEntity.ok(updated);
    }
    
    /**
     * Деактивировать шаблон упражнения
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deactivateTemplate(@PathVariable Long id) {
        exerciseTemplateService.deactivateTemplate(id);
        return ResponseEntity.noContent().build();
    }
    
    /**
     * Активировать шаблон упражнения
     */
    @PatchMapping("/{id}/activate")
    public ResponseEntity<ExerciseTemplateDto> activateTemplate(@PathVariable Long id) {
        ExerciseTemplateDto activated = exerciseTemplateService.activateTemplate(id);
        return ResponseEntity.ok(activated);
    }
    
    /**
     * Загрузить медиа файл для упражнения
     */
    @PostMapping("/{id}/media")
    public ResponseEntity<ExerciseTemplateDto> uploadMedia(
            @PathVariable Long id,
            @RequestParam("file") MultipartFile file,
            @RequestParam("mediaType") String mediaType,
            @RequestParam(value = "isPrimary", defaultValue = "false") boolean isPrimary) {
        ExerciseTemplateDto updated = exerciseTemplateService.uploadMedia(id, file, mediaType, isPrimary);
        return ResponseEntity.ok(updated);
    }
    
    /**
     * Удалить медиа файл
     */
    @DeleteMapping("/{templateId}/media/{mediaId}")
    public ResponseEntity<Void> deleteMedia(
            @PathVariable Long templateId,
            @PathVariable Long mediaId) {
        exerciseTemplateService.deleteMedia(templateId, mediaId);
        return ResponseEntity.noContent().build();
    }
}
