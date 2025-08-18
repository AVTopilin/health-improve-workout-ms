package com.workout.service;

import com.workout.dto.WorkoutDto;
import com.workout.dto.ExerciseDto;
import com.workout.entity.Exercise;
import com.workout.entity.ExerciseTemplate;
import com.workout.entity.User;
import com.workout.entity.Workout;
import com.workout.repository.ExerciseRepository;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.repository.WorkoutRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class WorkoutService {
    
    private final WorkoutRepository workoutRepository;
    private final ExerciseRepository exerciseRepository;
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    
    public List<WorkoutDto> getWorkoutsByUserId(Long userId) {
        List<Workout> workouts = workoutRepository.findByUserId(userId);
        return workouts.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
    }
    
    public WorkoutDto getWorkoutById(Long id, Long userId) {
        Workout workout = workoutRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Workout not found"));
        
        if (!workout.getUser().getId().equals(userId)) {
            throw new RuntimeException("Access denied");
        }
        
        return convertToDto(workout);
    }
    
    @Transactional
    public WorkoutDto createWorkout(WorkoutDto workoutDto, User user) {
        Workout workout = new Workout();
        workout.setName(workoutDto.getName());
        workout.setDescription(workoutDto.getDescription());
        workout.setUser(user);
        
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
        Workout workout = workoutRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Workout not found"));
        
        if (!workout.getUser().getId().equals(userId)) {
            throw new RuntimeException("Access denied");
        }
        
        workout.setName(workoutDto.getName());
        workout.setDescription(workoutDto.getDescription());
        
        // Удаляем старые упражнения
        exerciseRepository.deleteByWorkoutId(id);
        
        // Добавляем новые упражнения
        if (workoutDto.getExercises() != null) {
            List<Exercise> exercises = workoutDto.getExercises().stream()
                    .map(exDto -> convertToExercise(exDto, workout))
                    .collect(Collectors.toList());
            
            exerciseRepository.saveAll(exercises);
            workout.setExercises(exercises);
        }
        
        Workout savedWorkout = workoutRepository.save(workout);
        return convertToDto(savedWorkout);
    }
    
    public void deleteWorkout(Long id, Long userId) {
        Workout workout = workoutRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Workout not found"));
        
        if (!workout.getUser().getId().equals(userId)) {
            throw new RuntimeException("Access denied");
        }
        
        workoutRepository.deleteById(id);
    }
    
    private WorkoutDto convertToDto(Workout workout) {
        WorkoutDto dto = new WorkoutDto();
        dto.setId(workout.getId());
        dto.setName(workout.getName());
        dto.setDescription(workout.getDescription());
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
        return dto;
    }
    
    private Exercise convertToExercise(ExerciseDto dto, Workout workout) {
        Exercise exercise = new Exercise();
        exercise.setWorkout(workout);
        
        // Получаем шаблон упражнения
        ExerciseTemplate template = exerciseTemplateRepository.findById(dto.getExerciseTemplateId())
                .orElseThrow(() -> new RuntimeException("Exercise template not found"));
        exercise.setExerciseTemplate(template);
        
        exercise.setSets(dto.getSets());
        exercise.setReps(dto.getReps());
        exercise.setWeight(dto.getWeight());
        exercise.setRestTime(dto.getRestTime());
        exercise.setExerciseOrder(dto.getExerciseOrder());
        exercise.setNotes(dto.getNotes());
        return exercise;
    }
}
