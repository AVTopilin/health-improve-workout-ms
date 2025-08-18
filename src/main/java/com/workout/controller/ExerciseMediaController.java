package com.workout.controller;

import com.workout.dto.ExerciseMediaDto;
import com.workout.service.ExerciseMediaService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/api/exercise-media")
@RequiredArgsConstructor
public class ExerciseMediaController {
    
    private final ExerciseMediaService exerciseMediaService;
    
    /**
     * Получить все медиа файлы для упражнения
     */
    @GetMapping("/exercise/{exerciseTemplateId}")
    public ResponseEntity<List<ExerciseMediaDto>> getMediaByExercise(@PathVariable Long exerciseTemplateId) {
        List<ExerciseMediaDto> media = exerciseMediaService.getMediaByExercise(exerciseTemplateId);
        return ResponseEntity.ok(media);
    }
    
    /**
     * Получить медиа файл по ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ExerciseMediaDto> getMediaById(@PathVariable Long id) {
        ExerciseMediaDto media = exerciseMediaService.getMediaById(id);
        return ResponseEntity.ok(media);
    }
    
    /**
     * Скачать медиа файл
     */
    @GetMapping("/{id}/download")
    public ResponseEntity<Resource> downloadMedia(@PathVariable Long id) {
        ExerciseMediaDto media = exerciseMediaService.getMediaById(id);
        Resource resource = exerciseMediaService.downloadMedia(id);
        
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(media.getContentType()))
                .header(HttpHeaders.CONTENT_DISPOSITION, 
                        "attachment; filename=\"" + media.getOriginalFileName() + "\"")
                .body(resource);
    }
    
    /**
     * Просмотреть медиа файл (для изображений)
     */
    @GetMapping("/{id}/view")
    public ResponseEntity<Resource> viewMedia(@PathVariable Long id) {
        ExerciseMediaDto media = exerciseMediaService.getMediaById(id);
        Resource resource = exerciseMediaService.downloadMedia(id);
        
        return ResponseEntity.ok()
                .contentType(MediaType.parseMediaType(media.getContentType()))
                .body(resource);
    }
    
    /**
     * Загрузить новый медиа файл
     */
    @PostMapping("/exercise/{exerciseTemplateId}")
    public ResponseEntity<ExerciseMediaDto> uploadMedia(
            @PathVariable Long exerciseTemplateId,
            @RequestParam("file") MultipartFile file,
            @RequestParam("mediaType") String mediaType,
            @RequestParam(value = "isPrimary", defaultValue = "false") boolean isPrimary,
            @RequestParam(value = "displayOrder", defaultValue = "0") int displayOrder) {
        ExerciseMediaDto uploaded = exerciseMediaService.uploadMedia(exerciseTemplateId, file, mediaType, isPrimary, displayOrder);
        return ResponseEntity.ok(uploaded);
    }
    
    /**
     * Обновить медиа файл
     */
    @PutMapping("/{id}")
    public ResponseEntity<ExerciseMediaDto> updateMedia(
            @PathVariable Long id,
            @RequestParam(value = "isPrimary", required = false) Boolean isPrimary,
            @RequestParam(value = "displayOrder", required = false) Integer displayOrder) {
        ExerciseMediaDto updated = exerciseMediaService.updateMedia(id, isPrimary, displayOrder);
        return ResponseEntity.ok(updated);
    }
    
    /**
     * Удалить медиа файл
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteMedia(@PathVariable Long id) {
        exerciseMediaService.deleteMedia(id);
        return ResponseEntity.noContent().build();
    }
    
    /**
     * Изменить порядок отображения медиа файлов
     */
    @PatchMapping("/{id}/order")
    public ResponseEntity<ExerciseMediaDto> updateDisplayOrder(
            @PathVariable Long id,
            @RequestParam int displayOrder) {
        ExerciseMediaDto updated = exerciseMediaService.updateDisplayOrder(id, displayOrder);
        return ResponseEntity.ok(updated);
    }
    
    /**
     * Сделать медиа файл основным
     */
    @PatchMapping("/{id}/primary")
    public ResponseEntity<ExerciseMediaDto> setAsPrimary(@PathVariable Long id) {
        ExerciseMediaDto updated = exerciseMediaService.setAsPrimary(id);
        return ResponseEntity.ok(updated);
    }
}
