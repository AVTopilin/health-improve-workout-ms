package com.workout.service;

import com.workout.dto.ProgressionDto;
import com.workout.entity.ExerciseTemplate;
import com.workout.entity.Progression;
import com.workout.entity.Workout;
import com.workout.entity.Exercise;
import com.workout.entity.Progression.PeriodicityType;
import com.workout.entity.Progression.IncrementType;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.repository.WorkoutRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.format.TextStyle;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

@Service
@RequiredArgsConstructor
public class ProgressionCalculationService {
    
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    private final WorkoutRepository workoutRepository;
    
    /**
     * Рассчитывает план прогрессии и создает тренировки
     */
    public List<Workout> createWorkoutsFromProgression(ProgressionDto progressionDto, Long userId) {
        List<Workout> createdWorkouts = new ArrayList<>();
        
        // Получаем шаблон упражнения
        ExerciseTemplate template = exerciseTemplateRepository.findById(progressionDto.getExerciseTemplateId())
                .orElseThrow(() -> new RuntimeException("Exercise template not found"));
        
        // Базовые значения
        float currentWeight = progressionDto.getWeightIncrementValue() != null ? 
            progressionDto.getWeightIncrementValue() : 50.0f;
        int currentReps = progressionDto.getRepsInitialValue() != null ? 
            progressionDto.getRepsInitialValue() : 8;
        int currentSets = progressionDto.getSetsInitialValue() != null ? 
            progressionDto.getSetsInitialValue() : 3;
        int restTime = 90;
        
        LocalDate currentDate = progressionDto.getStartDate();
        
        for (int week = 1; week <= progressionDto.getWeeksCount(); week++) {
            // Рассчитываем значения для текущей недели
            if (progressionDto.getWeightProgressionEnabled()) {
                currentWeight = calculateWeightForWeek(progressionDto, week, currentWeight);
            }
            
            if (progressionDto.getRepsProgressionEnabled()) {
                currentReps = calculateRepsForWeek(progressionDto, week, currentReps);
            }
            
            if (progressionDto.getSetsProgressionEnabled()) {
                currentSets = calculateSetsForWeek(progressionDto, week, currentSets);
            }
            
            // Создаем тренировку для этой недели
            Workout workout = createWorkoutForWeek(progressionDto, template, week, currentDate, 
                currentWeight, currentReps, currentSets, restTime, userId);
            
            createdWorkouts.add(workout);
            
            // Переходим к следующей неделе
            currentDate = currentDate.plusWeeks(1);
        }
        
        return createdWorkouts;
    }
    
    /**
     * Создает тренировку для конкретной недели
     */
    private Workout createWorkoutForWeek(ProgressionDto progressionDto, ExerciseTemplate template, 
            int weekNumber, LocalDate workoutDate, float weight, int reps, int sets, int restTime, Long userId) {
        
        // Создаем тренировку
        Workout workout = new Workout();
        workout.setName(String.format("Тренировка %d - %s", weekNumber, template.getName()));
        workout.setDescription(String.format("Тренировка %d недели прогрессии для %s", weekNumber, template.getName()));
        
        // TODO: Получить пользователя по userId и установить dayOfWeek, weeksCount, startDate
        // workout.setUser(user);
        // workout.setDayOfWeek(DayOfWeek.MONDAY); // По умолчанию понедельник
        // workout.setWeeksCount(progressionDto.getWeeksCount());
        // workout.setStartDate(progressionDto.getStartDate());
        
        // Создаем упражнение
        Exercise exercise = new Exercise();
        exercise.setWorkout(workout);
        exercise.setExerciseTemplate(template);
        exercise.setWeight(weight);
        exercise.setReps(reps);
        exercise.setSets(sets);
        exercise.setRestTime(restTime);
        exercise.setExerciseOrder(1);
        exercise.setNotes(String.format("Неделя %d прогрессии", weekNumber));
        
        // Добавляем упражнение в тренировку
        List<Exercise> exercises = new ArrayList<>();
        exercises.add(exercise);
        workout.setExercises(exercises);
        
        return workout;
    }
    
    /**
     * Рассчитывает вес для конкретной недели
     */
    private float calculateWeightForWeek(ProgressionDto progression, int week, float currentWeight) {
        if (progression.getWeightPeriodicity() == null) {
            return currentWeight;
        }
        
        switch (progression.getWeightPeriodicity()) {
            case FIXED:
                return progression.getWeightIncrementValue() != null ? 
                    progression.getWeightIncrementValue() : currentWeight;
                    
            case EVERY_WORKOUT:
                if (progression.getWeightIncrementType() == IncrementType.INCREMENT) {
                    return currentWeight + (progression.getWeightIncrementValue() * (week - 1));
                }
                break;
                
            case CONDITIONAL:
                // Логика для условного изменения веса
                // Здесь нужно учитывать достижение условий
                break;
        }
        
        return currentWeight;
    }
    
    /**
     * Рассчитывает повторения для конкретной недели
     */
    private int calculateRepsForWeek(ProgressionDto progression, int week, int currentReps) {
        if (progression.getRepsProgressionEnabled() == null || !progression.getRepsProgressionEnabled()) {
            return currentReps;
        }
        
        if (progression.getRepsPeriodicity() == null) {
            return currentReps;
        }
        
        switch (progression.getRepsPeriodicity()) {
            case FIXED:
                return progression.getRepsIncrementValue() != null ? 
                    progression.getRepsIncrementValue() : currentReps;
                    
            case EVERY_WORKOUT:
                if (progression.getRepsIncrementType() == IncrementType.INCREMENT) {
                    return currentReps + (progression.getRepsIncrementValue() * (week - 1));
                } else if (progression.getRepsIncrementType() == IncrementType.CYCLE) {
                    return calculateCycleValue(
                        progression.getRepsInitialValue(),
                        progression.getRepsFinalValue(),
                        week
                    );
                }
                break;
                
            case CONDITIONAL:
                // Логика для условного изменения повторений
                break;
        }
        
        return currentReps;
    }
    
    /**
     * Рассчитывает подходы для конкретной недели
     */
    private int calculateSetsForWeek(ProgressionDto progression, int week, int currentSets) {
        if (progression.getSetsProgressionEnabled() == null || !progression.getSetsProgressionEnabled()) {
            return currentSets;
        }
        
        if (progression.getSetsPeriodicity() == null) {
            return currentSets;
        }
        
        switch (progression.getSetsPeriodicity()) {
            case FIXED:
                return progression.getSetsIncrementValue() != null ? 
                    progression.getSetsIncrementValue() : currentSets;
                    
            case EVERY_WORKOUT:
                if (progression.getSetsIncrementType() == IncrementType.INCREMENT) {
                    return currentSets + (progression.getSetsIncrementValue() * (week - 1));
                } else if (progression.getSetsIncrementType() == IncrementType.CYCLE) {
                    return calculateCycleValue(
                        progression.getSetsInitialValue(),
                        progression.getSetsFinalValue(),
                        week
                    );
                }
                break;
                
            case CONDITIONAL:
                // Логика для условного изменения подходов
                break;
        }
        
        return currentSets;
    }
    
    /**
     * Рассчитывает значение для циклической прогрессии
     */
    private int calculateCycleValue(Integer initialValue, Integer finalValue, int week) {
        if (initialValue == null || finalValue == null) {
            return initialValue != null ? initialValue : 3;
        }
        
        // Простая линейная прогрессия от начального к конечному значению
        int totalWeeks = 8; // Можно сделать настраиваемым
        if (week > totalWeeks) {
            return finalValue;
        }
        
        float progress = (float) (week - 1) / (totalWeeks - 1);
        return Math.round(initialValue + (finalValue - initialValue) * progress);
    }
}
