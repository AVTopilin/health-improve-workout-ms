package com.workout.dto;

import com.workout.entity.WorkoutScheduleExercise;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * DTO для упражнений в расписании тренировок
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutScheduleExerciseDto {
    
    private Long id;
    
    @NotNull(message = "Exercise template ID is required")
    private Long exerciseTemplateId;
    
    // Связь с конкретным упражнением из тренировки
    private Long exerciseId;
    
    @NotNull(message = "Planned weight is required")
    @Min(value = 0, message = "Planned weight must be non-negative")
    private Float plannedWeight;
    
    @NotNull(message = "Planned reps is required")
    @Min(value = 1, message = "Planned reps must be at least 1")
    private Integer plannedReps;
    
    @NotNull(message = "Planned sets is required")
    @Min(value = 1, message = "Planned sets must be at least 1")
    private Integer plannedSets;
    
    @NotNull(message = "Planned rest time is required")
    @Min(value = 0, message = "Planned rest time must be non-negative")
    private Integer plannedRestTime;
    
    @NotNull(message = "Exercise order is required")
    @Min(value = 1, message = "Exercise order must be at least 1")
    private Integer exerciseOrder;
    
    @NotNull(message = "Status is required")
    private String status;
    
    private String startTime;
    private String endTime;
    private String notes;
    
    // Фактические выполненные значения
    private Float actualWeight;
    private Integer actualReps;
    private Integer actualSets;
    private Integer actualRestTime;
    
    // Подходы упражнения
    private List<SetExecutionDto> setExecutions;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    // Дополнительные поля для удобства
    private String exerciseTemplateName;
    private String muscleGroupName;
    private String equipmentName;
    
    /**
     * Конвертирует сущность в DTO
     */
    public static WorkoutScheduleExerciseDto fromEntity(WorkoutScheduleExercise exercise) {
        WorkoutScheduleExerciseDto dto = new WorkoutScheduleExerciseDto();
        dto.setId(exercise.getId());
        dto.setExerciseTemplateId(exercise.getExerciseTemplate().getId());
        
        // Логируем для отладки
        System.out.println("DEBUG: exercise.getExerciseId() = " + exercise.getExerciseId());
        
        dto.setExerciseId(exercise.getExerciseId());
        dto.setPlannedWeight(exercise.getPlannedWeight());
        dto.setPlannedReps(exercise.getPlannedReps());
        dto.setPlannedSets(exercise.getPlannedSets());
        dto.setPlannedRestTime(exercise.getPlannedRestTime());
        dto.setExerciseOrder(exercise.getExerciseOrder());
        dto.setStatus(exercise.getStatus().name());
        dto.setStartTime(exercise.getStartTime() != null ? exercise.getStartTime().toString() : null);
        dto.setEndTime(exercise.getEndTime() != null ? exercise.getEndTime().toString() : null);
        dto.setNotes(exercise.getNotes());
        dto.setActualWeight(exercise.getActualWeight());
        dto.setActualReps(exercise.getActualReps());
        dto.setActualSets(exercise.getActualSets());
        dto.setActualRestTime(exercise.getActualRestTime());
        dto.setCreatedAt(exercise.getCreatedAt());
        dto.setUpdatedAt(exercise.getUpdatedAt());
        
        // Дополнительные поля
        if (exercise.getExerciseTemplate() != null) {
            dto.setExerciseTemplateName(exercise.getExerciseTemplate().getName());
            if (exercise.getExerciseTemplate().getMuscleGroup() != null) {
                dto.setMuscleGroupName(exercise.getExerciseTemplate().getMuscleGroup().getName());
            }
            if (exercise.getExerciseTemplate().getEquipment() != null) {
                dto.setEquipmentName(exercise.getExerciseTemplate().getEquipment().getName());
            }
        }
        
        // Загружаем подходы упражнения
        if (exercise.getSetExecutions() != null) {
            dto.setSetExecutions(exercise.getSetExecutions().stream()
                    .map(SetExecutionDto::fromEntity)
                    .collect(Collectors.toList()));
        }
        
        return dto;
    }
    
    /**
     * Конвертирует DTO в сущность (без ID для создания)
     */
    public WorkoutScheduleExercise toEntity() {
        WorkoutScheduleExercise exercise = new WorkoutScheduleExercise();
        exercise.setExerciseId(this.exerciseId);
        exercise.setPlannedWeight(this.plannedWeight);
        exercise.setPlannedReps(this.plannedReps);
        exercise.setPlannedSets(this.plannedSets);
        exercise.setPlannedRestTime(this.plannedRestTime);
        exercise.setExerciseOrder(this.exerciseOrder);
        exercise.setStatus(WorkoutScheduleExercise.ExerciseStatus.valueOf(this.status));
        exercise.setNotes(this.notes);
        exercise.setActualWeight(this.actualWeight);
        exercise.setActualReps(this.actualReps);
        exercise.setActualSets(this.actualSets);
        exercise.setActualRestTime(this.actualRestTime);
        exercise.setCreatedAt(LocalDateTime.now());
        exercise.setUpdatedAt(LocalDateTime.now());
        
        // Время выполнения
        if (this.startTime != null) {
            exercise.setStartTime(LocalTime.parse(this.startTime));
        }
        if (this.endTime != null) {
            exercise.setEndTime(LocalTime.parse(this.endTime));
        }
        
        return exercise;
    }
}
