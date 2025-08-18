package com.workout.service;

import com.workout.dto.ExerciseMediaDto;
import com.workout.entity.ExerciseMedia;
import com.workout.entity.ExerciseTemplate;
import com.workout.entity.ExerciseMedia.MediaType;
import com.workout.repository.ExerciseMediaRepository;
import com.workout.repository.ExerciseTemplateRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ExerciseMediaService {
    
    private final ExerciseMediaRepository exerciseMediaRepository;
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    private final MinioService minioService;
    
    /**
     * Получить все медиа файлы для упражнения
     */
    @Transactional(readOnly = true)
    public List<ExerciseMediaDto> getMediaByExercise(Long exerciseTemplateId) {
        return exerciseMediaRepository.findByExerciseTemplateIdOrderByDisplayOrderAsc(exerciseTemplateId)
                .stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    /**
     * Получить медиа файл по ID
     */
    @Transactional(readOnly = true)
    public ExerciseMediaDto getMediaById(Long id) {
        ExerciseMedia media = exerciseMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Медиа файл не найден с ID: " + id));
        return convertToDto(media);
    }
    
    /**
     * Скачать медиа файл
     */
    @Transactional(readOnly = true)
    public Resource downloadMedia(Long id) {
        ExerciseMedia media = exerciseMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Медиа файл не найден с ID: " + id));
        
        return minioService.downloadFile(media.getMinioPath());
    }
    
    /**
     * Загрузить новый медиа файл
     */
    public ExerciseMediaDto uploadMedia(Long exerciseTemplateId, MultipartFile file, String mediaType, boolean isPrimary, int displayOrder) {
        ExerciseTemplate template = exerciseTemplateRepository.findById(exerciseTemplateId)
                .orElseThrow(() -> new RuntimeException("Шаблон упражнения не найден с ID: " + exerciseTemplateId));
        
        // Загружаем файл в MinIO
        String minioPath = minioService.uploadFile(file);
        
        // Если это основной файл, сбрасываем флаг у других
        if (isPrimary) {
            List<ExerciseMedia> existingPrimary = exerciseMediaRepository.findByExerciseTemplateIdAndIsPrimaryTrue(exerciseTemplateId);
            for (ExerciseMedia existing : existingPrimary) {
                existing.setIsPrimary(false);
                exerciseMediaRepository.save(existing);
            }
        }
        
        ExerciseMedia media = new ExerciseMedia();
        media.setExerciseTemplate(template);
        media.setFileName(file.getOriginalFilename());
        media.setOriginalFileName(file.getOriginalFilename());
        media.setContentType(file.getContentType());
        media.setFileSize(file.getSize());
        media.setMinioPath(minioPath);
        media.setMediaType(MediaType.valueOf(mediaType.toUpperCase()));
        media.setDisplayOrder(displayOrder);
        media.setIsPrimary(isPrimary);
        media.setCreatedAt(LocalDateTime.now());
        media.setUpdatedAt(LocalDateTime.now());
        
        ExerciseMedia saved = exerciseMediaRepository.save(media);
        return convertToDto(saved);
    }
    
    /**
     * Обновить медиа файл
     */
    public ExerciseMediaDto updateMedia(Long id, Boolean isPrimary, Integer displayOrder) {
        ExerciseMedia media = exerciseMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Медиа файл не найден с ID: " + id));
        
        if (isPrimary != null) {
            // Если делаем основным, сбрасываем флаг у других
            if (isPrimary) {
                List<ExerciseMedia> existingPrimary = exerciseMediaRepository.findByExerciseTemplateIdAndIsPrimaryTrue(media.getExerciseTemplate().getId());
                for (ExerciseMedia existing : existingPrimary) {
                    if (!existing.getId().equals(id)) {
                        existing.setIsPrimary(false);
                        exerciseMediaRepository.save(existing);
                    }
                }
            }
            media.setIsPrimary(isPrimary);
        }
        
        if (displayOrder != null) {
            media.setDisplayOrder(displayOrder);
        }
        
        media.setUpdatedAt(LocalDateTime.now());
        
        ExerciseMedia saved = exerciseMediaRepository.save(media);
        return convertToDto(saved);
    }
    
    /**
     * Удалить медиа файл
     */
    public void deleteMedia(Long id) {
        ExerciseMedia media = exerciseMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Медиа файл не найден с ID: " + id));
        
        // Удаляем файл из MinIO
        minioService.deleteFile(media.getMinioPath());
        
        // Удаляем запись из БД
        exerciseMediaRepository.delete(media);
    }
    
    /**
     * Изменить порядок отображения медиа файлов
     */
    public ExerciseMediaDto updateDisplayOrder(Long id, int displayOrder) {
        ExerciseMedia media = exerciseMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Медиа файл не найден с ID: " + id));
        
        media.setDisplayOrder(displayOrder);
        media.setUpdatedAt(LocalDateTime.now());
        
        ExerciseMedia saved = exerciseMediaRepository.save(media);
        return convertToDto(saved);
    }
    
    /**
     * Сделать медиа файл основным
     */
    public ExerciseMediaDto setAsPrimary(Long id) {
        ExerciseMedia media = exerciseMediaRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Медиа файл не найден с ID: " + id));
        
        // Сбрасываем флаг у других файлов этого упражнения
        List<ExerciseMedia> existingPrimary = exerciseMediaRepository.findByExerciseTemplateIdAndIsPrimaryTrue(media.getExerciseTemplate().getId());
        for (ExerciseMedia existing : existingPrimary) {
            if (!existing.getId().equals(id)) {
                existing.setIsPrimary(false);
                exerciseMediaRepository.save(existing);
            }
        }
        
        media.setIsPrimary(true);
        media.setUpdatedAt(LocalDateTime.now());
        
        ExerciseMedia saved = exerciseMediaRepository.save(media);
        return convertToDto(saved);
    }
    
    /**
     * Конвертация в DTO
     */
    private ExerciseMediaDto convertToDto(ExerciseMedia media) {
        ExerciseMediaDto dto = new ExerciseMediaDto();
        dto.setId(media.getId());
        dto.setExerciseTemplateId(media.getExerciseTemplate().getId());
        dto.setFileName(media.getFileName());
        dto.setOriginalFileName(media.getOriginalFileName());
        dto.setContentType(media.getContentType());
        dto.setFileSize(media.getFileSize());
        dto.setMinioPath(media.getMinioPath());
        dto.setMediaType(media.getMediaType().name());
        dto.setDisplayOrder(media.getDisplayOrder());
        dto.setIsPrimary(media.getIsPrimary());
        
        // Генерируем URL для доступа к файлу
        dto.setAccessUrl(minioService.getFileUrl(media.getMinioPath()));
        
        return dto;
    }
}
