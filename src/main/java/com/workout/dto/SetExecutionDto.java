package com.workout.dto;

import com.workout.entity.SetExecution;
import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import java.time.LocalTime;
import java.time.LocalDateTime;

/**
 * DTO для подходов упражнений
 */
@Data
@NoArgsConstructor
@AllArgsConstructor
public class SetExecutionDto {
    
    private Long id;
    
    @NotNull(message = "Workout schedule exercise ID is required")
    private Long workoutScheduleExerciseId;
    
    @NotNull(message = "Set number is required")
    @Min(value = 1, message = "Set number must be at least 1")
    private Integer setNumber;
    
    // Планируемые значения
    private Float plannedWeight;
    private Integer plannedReps;
    
    // Фактические выполненные значения
    private Float actualWeight;
    private Integer actualReps;
    
    private LocalTime startTime;
    private LocalTime endTime;
    private Integer restTime;
    private String notes;
    
    @NotNull(message = "Status is required")
    private String status;
    
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    
    /**
     * Конвертирует сущность в DTO
     */
    public static SetExecutionDto fromEntity(SetExecution setExecution) {
        SetExecutionDto dto = new SetExecutionDto();
        dto.setId(setExecution.getId());
        dto.setWorkoutScheduleExerciseId(setExecution.getWorkoutScheduleExercise().getId());
        dto.setSetNumber(setExecution.getSetNumber());
        dto.setPlannedWeight(setExecution.getPlannedWeight());
        dto.setPlannedReps(setExecution.getPlannedReps());
        dto.setActualWeight(setExecution.getActualWeight());
        dto.setActualReps(setExecution.getActualReps());
        dto.setStartTime(setExecution.getStartTime());
        dto.setEndTime(setExecution.getEndTime());
        dto.setRestTime(setExecution.getRestTime());
        dto.setNotes(setExecution.getNotes());
        dto.setStatus(setExecution.getStatus().name());
        dto.setCreatedAt(setExecution.getCreatedAt());
        dto.setUpdatedAt(setExecution.getUpdatedAt());
        return dto;
    }
    
    /**
     * Конвертирует DTO в сущность
     */
    public SetExecution toEntity() {
        SetExecution setExecution = new SetExecution();
        setExecution.setSetNumber(this.setNumber);
        setExecution.setPlannedWeight(this.plannedWeight);
        setExecution.setPlannedReps(this.plannedReps);
        setExecution.setActualWeight(this.actualWeight);
        setExecution.setActualReps(this.actualReps);
        setExecution.setStartTime(this.startTime);
        setExecution.setEndTime(this.endTime);
        setExecution.setRestTime(this.restTime);
        setExecution.setNotes(this.notes);
        setExecution.setStatus(SetExecution.SetStatus.valueOf(this.status));
        return setExecution;
    }
}
