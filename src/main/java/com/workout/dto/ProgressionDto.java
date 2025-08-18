package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import com.workout.entity.Progression.PeriodicityType;
import com.workout.entity.Progression.IncrementType;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Min;
import java.time.LocalDate;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ProgressionDto {
    private Long id;
    
    @NotNull(message = "Exercise template ID is required")
    private Long exerciseTemplateId;
    
    // Опции прогрессии (чекбоксы)
    @NotNull(message = "Weight progression enabled is required")
    private Boolean weightProgressionEnabled = false;
    
    @NotNull(message = "Reps progression enabled is required")
    private Boolean repsProgressionEnabled = false;
    
    @NotNull(message = "Sets progression enabled is required")
    private Boolean setsProgressionEnabled = false;
    
    // Периодичность для каждого параметра
    private PeriodicityType weightPeriodicity;
    private PeriodicityType repsPeriodicity;
    private PeriodicityType setsPeriodicity;
    
    // Тип инкремента для каждого параметра
    private IncrementType weightIncrementType;
    private IncrementType repsIncrementType;
    private IncrementType setsIncrementType;
    
    // Значения для инкрементов
    @Min(value = 0, message = "Weight increment value must be non-negative")
    private Float weightIncrementValue;
    
    @Min(value = 1, message = "Reps increment value must be at least 1")
    private Integer repsIncrementValue;
    
    @Min(value = 1, message = "Sets increment value must be at least 1")
    private Integer setsIncrementValue;
    
    // Начальные и конечные значения для циклов
    @Min(value = 1, message = "Reps initial value must be at least 1")
    private Integer repsInitialValue;
    
    @Min(value = 1, message = "Reps final value must be at least 1")
    private Integer repsFinalValue;
    
    @Min(value = 1, message = "Sets initial value must be at least 1")
    private Integer setsInitialValue;
    
    @Min(value = 1, message = "Sets final value must be at least 1")
    private Integer setsFinalValue;
    
    // Условия для изменения
    @Min(value = 1, message = "Weight condition sets must be at least 1")
    private Integer weightConditionSets;
    
    @Min(value = 1, message = "Weight condition reps must be at least 1")
    private Integer weightConditionReps;
    
    @Min(value = 1, message = "Sets condition reps must be at least 1")
    private Integer setsConditionReps;
    
    // Параметры прогрессии
    @NotNull(message = "Weeks count is required")
    @Min(value = 1, message = "Weeks count must be at least 1")
    private Integer weeksCount;
    
    @NotNull(message = "Start date is required")
    private LocalDate startDate;
    
    private Boolean isActive = true;
    
    // Дополнительная информация
    private String exerciseTemplateName;
    private String muscleGroupName;
    private String equipmentName;
    
    // Созданные тренировки (для отображения в интерфейсе)
    private List<WorkoutSummaryDto> createdWorkouts;
    
    // Перечисления берутся из сущности Progression
    
    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class WorkoutSummaryDto {
        private Long workoutId;
        private Integer weekNumber;
        private LocalDate workoutDate;
        private String dayOfWeek;
        private String status; // "NOT_CREATED", "IN_PROGRESS", "COMPLETED", "SKIPPED"
        private Boolean isEditable;
        
        // Плановые значения для этой недели
        private Float plannedWeight;
        private Integer plannedReps;
        private Integer plannedSets;
        private Integer plannedRestTime;
    }
}
