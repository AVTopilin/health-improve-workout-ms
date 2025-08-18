package com.workout.repository;

import com.workout.entity.ExerciseMedia;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ExerciseMediaRepository extends JpaRepository<ExerciseMedia, Long> {
    
    /**
     * Найти все медиа файлы для упражнения, отсортированные по порядку отображения
     */
    List<ExerciseMedia> findByExerciseTemplateIdOrderByDisplayOrderAsc(Long exerciseTemplateId);
    
    /**
     * Найти основной медиа файл для упражнения
     */
    List<ExerciseMedia> findByExerciseTemplateIdAndIsPrimaryTrue(Long exerciseTemplateId);
    
    /**
     * Найти медиа файлы по типу
     */
    List<ExerciseMedia> findByMediaType(com.workout.entity.ExerciseMedia.MediaType mediaType);
    
    /**
     * Найти медиа файлы по типу и упражнению
     */
    List<ExerciseMedia> findByExerciseTemplateIdAndMediaType(Long exerciseTemplateId, com.workout.entity.ExerciseMedia.MediaType mediaType);
}
