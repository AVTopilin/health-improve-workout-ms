package com.workout.service;

import com.workout.dto.ExerciseDto;
import com.workout.dto.WorkoutDto;
import com.workout.entity.Exercise;
import com.workout.entity.ExerciseTemplate;
import com.workout.entity.User;
import com.workout.entity.Workout;
import com.workout.exception.NotFoundException;
import com.workout.exception.AccessDeniedException;
import com.workout.repository.ExerciseRepository;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.repository.WorkoutRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;
import java.util.ArrayList;
import java.util.Map;
import com.workout.dto.ProgressionDto;
import com.workout.entity.Progression;

@Slf4j
@Service
@RequiredArgsConstructor
public class WorkoutService {
    
    private final WorkoutRepository workoutRepository;
    private final ExerciseRepository exerciseRepository;
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    private final ProgressionService progressionService;
    

    
    public List<WorkoutDto> getWorkoutsByUserId(Long userId) {
        List<Workout> workouts = workoutRepository.findByUserId(userId);
        return workouts.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public WorkoutDto getWorkoutById(Long id, Long userId) {
        Workout workout = workoutRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Workout not found"));
        
        if (!workout.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("Access denied");
        }
        
        return convertToDto(workout);
    }
    
    @Transactional
    public WorkoutDto createWorkout(WorkoutDto workoutDto, User user) {
        log.info("Creating workout with DTO: {}", workoutDto);
        
        Workout workout = new Workout();
        workout.setName(workoutDto.getName());
        workout.setDescription(workoutDto.getDescription());
        workout.setUser(user);
        
        // Заполняем обязательные поля
        if (workoutDto.getDayOfWeek() != null) {
            workout.setDayOfWeek(workoutDto.getDayOfWeek());
            log.info("Setting dayOfWeek from DTO: {}", workoutDto.getDayOfWeek());
        } else {
            // Устанавливаем значение по умолчанию
            workout.setDayOfWeek(DayOfWeek.MONDAY);
            log.info("Setting default dayOfWeek: {}", DayOfWeek.MONDAY);
        }
        
        if (workoutDto.getWeeksCount() != null) {
            workout.setWeeksCount(workoutDto.getWeeksCount());
            log.info("Setting weeksCount from DTO: {}", workoutDto.getWeeksCount());
        } else {
            // Устанавливаем значение по умолчанию
            workout.setWeeksCount(4);
            log.info("Setting default weeksCount: {}", 4);
        }
        
        if (workoutDto.getStartDate() != null) {
            workout.setStartDate(workoutDto.getStartDate());
            log.info("Setting startDate from DTO: {}", workoutDto.getStartDate());
        } else {
            // Устанавливаем значение по умолчанию - текущая дата
            workout.setStartDate(LocalDate.now());
            log.info("Setting default startDate: {}", LocalDate.now());
        }
        
        log.info("Workout entity before save: dayOfWeek={}, weeksCount={}, startDate={}", 
                workout.getDayOfWeek(), workout.getWeeksCount(), workout.getStartDate());
        
        Workout savedWorkout = workoutRepository.save(workout);
        
        if (workoutDto.getExercises() != null) {
            List<Exercise> exercises = workoutDto.getExercises().stream()
                    .map(exDto -> convertToExercise(exDto, savedWorkout))
                    .collect(Collectors.toList());
            
            exerciseRepository.saveAll(exercises);
            savedWorkout.setExercises(exercises);
        }
        
        return convertToDto(savedWorkout);
    }
    
    @Transactional
    public WorkoutDto updateWorkout(Long id, WorkoutDto workoutDto, Long userId) {
        log.info("Updating workout with id: {}, DTO: {}", id, workoutDto);
        
        Workout workout = workoutRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Workout not found"));
        
        if (!workout.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("Access denied");
        }
        
        log.info("Current workout state: dayOfWeek={}, weeksCount={}, startDate={}", 
                workout.getDayOfWeek(), workout.getWeeksCount(), workout.getStartDate());
        
        workout.setName(workoutDto.getName());
        workout.setDescription(workoutDto.getDescription());
        
        // Обновляем обязательные поля
        if (workoutDto.getDayOfWeek() != null) {
            workout.setDayOfWeek(workoutDto.getDayOfWeek());
            log.info("Updating dayOfWeek to: {}", workoutDto.getDayOfWeek());
        }
        
        if (workoutDto.getWeeksCount() != null) {
            workout.setWeeksCount(workoutDto.getWeeksCount());
            log.info("Updating weeksCount to: {}", workoutDto.getWeeksCount());
        }
        
        if (workoutDto.getStartDate() != null) {
            workout.setStartDate(workoutDto.getStartDate());
            log.info("Updating startDate to: {}", workoutDto.getStartDate());
        }
        
        log.info("Workout entity after update: dayOfWeek={}, weeksCount={}, startDate={}", 
                workout.getDayOfWeek(), workout.getWeeksCount(), workout.getStartDate());
        
        // Обновляем упражнения с сохранением прогрессии
        if (workoutDto.getExercises() != null) {
            updateExercises(workoutDto.getExercises(), workout);
        }
        
        Workout savedWorkout = workoutRepository.save(workout);
        return convertToDto(savedWorkout);
    }
    
    public void deleteWorkout(Long id, Long userId) {
        Workout workout = workoutRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Workout not found"));
        
        if (!workout.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("Access denied");
        }
        
        workoutRepository.deleteById(id);
    }
    
    private WorkoutDto convertToDto(Workout workout) {
        WorkoutDto dto = new WorkoutDto();
        dto.setId(workout.getId());
        dto.setName(workout.getName());
        dto.setDescription(workout.getDescription());
        dto.setDayOfWeek(workout.getDayOfWeek());
        dto.setWeeksCount(workout.getWeeksCount());
        dto.setStartDate(workout.getStartDate());
        dto.setCreatedAt(workout.getCreatedAt());
        dto.setUpdatedAt(workout.getUpdatedAt());
        
        if (workout.getExercises() != null) {
            dto.setExercises(workout.getExercises().stream()
                    .map(this::convertToExerciseDto)
                    .collect(Collectors.toList()));
        }
        
        return dto;
    }
    
    private ExerciseDto convertToExerciseDto(Exercise exercise) {
        ExerciseDto dto = new ExerciseDto();
        dto.setId(exercise.getId());
        dto.setWorkoutId(exercise.getWorkout().getId());
        dto.setExerciseTemplateId(exercise.getExerciseTemplate().getId());
        
        // Заполняем информацию из шаблона
        dto.setExerciseName(exercise.getExerciseTemplate().getName());
        dto.setExerciseDescription(exercise.getExerciseTemplate().getDescription());
        dto.setMuscleGroupName(exercise.getExerciseTemplate().getMuscleGroup().getName());
        dto.setEquipmentName(exercise.getExerciseTemplate().getEquipment().getName());
        dto.setDifficultyLevel(exercise.getExerciseTemplate().getDifficultyLevel().name());
        
        dto.setSets(exercise.getSets());
        dto.setReps(exercise.getReps());
        dto.setWeight(exercise.getWeight());
        dto.setRestTime(exercise.getRestTime());
        dto.setExerciseOrder(exercise.getExerciseOrder());
        dto.setNotes(exercise.getNotes());
        
        // Загружаем прогрессию для упражнения
        ProgressionDto progression = progressionService.getProgressionByExerciseId(exercise.getId());
        dto.setProgression(progression);
        
        return dto;
    }
    
    private Exercise convertToExercise(ExerciseDto dto, Workout workout) {
        Exercise exercise = new Exercise();
        exercise.setWorkout(workout);
        
        // Получаем шаблон упражнения
        ExerciseTemplate template = exerciseTemplateRepository.findById(dto.getExerciseTemplateId())
                .orElseThrow(() -> new NotFoundException("Exercise template not found"));
        exercise.setExerciseTemplate(template);
        
        exercise.setSets(dto.getSets());
        exercise.setReps(dto.getReps());
        exercise.setWeight(dto.getWeight());
        exercise.setRestTime(dto.getRestTime());
        exercise.setExerciseOrder(dto.getExerciseOrder());
        exercise.setNotes(dto.getNotes());
        return exercise;
    }
    
    /**
     * Обновляет упражнения в тренировке с сохранением прогрессии
     */
    private void updateExercises(List<ExerciseDto> exerciseDtos, Workout workout) {
        log.info("Updating exercises for workout: {}", workout.getId());
        
        // Получаем существующие упражнения
        List<Exercise> existingExercises = exerciseRepository.findByWorkoutId(workout.getId());
        Map<Long, Exercise> existingExercisesMap = existingExercises.stream()
                .collect(Collectors.toMap(Exercise::getId, e -> e));
        
        List<Exercise> updatedExercises = new ArrayList<>();
        
        for (ExerciseDto dto : exerciseDtos) {
            if (dto.getId() != null && existingExercisesMap.containsKey(dto.getId())) {
                // Обновляем существующее упражнение
                Exercise existingExercise = existingExercisesMap.get(dto.getId());
                updateExistingExercise(existingExercise, dto);
                updatedExercises.add(existingExercise);
                existingExercisesMap.remove(dto.getId()); // Убираем из списка существующих
                log.debug("Updated existing exercise: {}", dto.getId());
            } else {
                // Создаем новое упражнение
                Exercise newExercise = convertToExercise(dto, workout);
                updatedExercises.add(newExercise);
                log.debug("Created new exercise for template: {}", dto.getExerciseTemplateId());
            }
        }
        
        // Удаляем упражнения, которых больше нет в DTO
        for (Exercise exerciseToDelete : existingExercisesMap.values()) {
            exerciseRepository.deleteById(exerciseToDelete.getId());
            log.debug("Deleted exercise: {}", exerciseToDelete.getId());
        }
        
        // Сохраняем обновленные упражнения
        List<Exercise> savedExercises = exerciseRepository.saveAll(updatedExercises);
        workout.setExercises(savedExercises);
        
        log.info("Successfully updated exercises. Total: {}, Updated: {}, Created: {}, Deleted: {}", 
                exerciseDtos.size(), 
                exerciseDtos.stream().filter(dto -> dto.getId() != null).count(),
                exerciseDtos.stream().filter(dto -> dto.getId() == null).count(),
                existingExercisesMap.size());
    }
    
    /**
     * Обновляет существующее упражнение
     */
    private void updateExistingExercise(Exercise exercise, ExerciseDto dto) {
        // Получаем шаблон упражнения
        ExerciseTemplate template = exerciseTemplateRepository.findById(dto.getExerciseTemplateId())
                .orElseThrow(() -> new NotFoundException("Exercise template not found"));
        
        exercise.setExerciseTemplate(template);
        exercise.setSets(dto.getSets());
        exercise.setReps(dto.getReps());
        exercise.setWeight(dto.getWeight());
        exercise.setRestTime(dto.getRestTime());
        exercise.setExerciseOrder(dto.getExerciseOrder());
        exercise.setNotes(dto.getNotes());
        
        // Обновляем прогрессию
        updateExerciseProgression(exercise, dto);
    }
    
    /**
     * Обновляет прогрессию для упражнения
     */
    private void updateExerciseProgression(Exercise exercise, ExerciseDto dto) {
        try {
            // Если в DTO есть прогрессия, используем её
            if (dto.getProgression() != null) {
                ProgressionDto progressionDto = dto.getProgression();
                progressionDto.setUserId(exercise.getWorkout().getUser().getId());
                progressionDto.setExerciseId(exercise.getId());
                
                // Проверяем, есть ли уже прогрессия для этого упражнения
                ProgressionDto existingProgression = progressionService.getProgressionByExerciseId(exercise.getId());
                if (existingProgression == null) {
                    // Создаем новую прогрессию
                    progressionService.createProgression(progressionDto);
                    log.debug("Created new progression for exercise: {} with settings: {}", 
                            exercise.getId(), progressionDto);
                } else {
                    // Обновляем существующую прогрессию
                    progressionService.updateProgression(existingProgression.getId(), progressionDto);
                    log.debug("Updated existing progression for exercise: {} with settings: {}", 
                            exercise.getId(), progressionDto);
                }
            } else {
                // Если прогрессии нет в DTO, создаем с дефолтными значениями
                ProgressionDto existingProgression = progressionService.getProgressionByExerciseId(exercise.getId());
                if (existingProgression == null) {
                    ProgressionDto progressionDto = new ProgressionDto();
                    progressionDto.setUserId(exercise.getWorkout().getUser().getId());
                    progressionDto.setExerciseId(exercise.getId());
                    progressionDto.setWeightProgressionEnabled(true);
                    progressionDto.setWeightPeriodicity(Progression.PeriodicityType.EVERY_WORKOUT);
                    progressionDto.setWeightIncrementType(Progression.IncrementType.INCREMENT);
                    progressionDto.setWeightIncrementValue(2.5f);
                    progressionDto.setWeightInitialValue(0.0f);
                    progressionDto.setWeightFinalValue(100.0f);
                    progressionService.createProgression(progressionDto);
                    log.debug("Created default progression for exercise: {}", exercise.getId());
                }
            }
        } catch (Exception e) {
            log.warn("Failed to update progression for exercise {}: {}", exercise.getId(), e.getMessage());
        }
    }
}
