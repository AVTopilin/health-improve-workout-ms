package com.workout.controller;

import com.workout.dto.ExerciseDto;
import com.workout.entity.Exercise;
import com.workout.entity.ExerciseTemplate;
import com.workout.entity.User;
import com.workout.entity.Workout;
import com.workout.repository.ExerciseRepository;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.repository.WorkoutRepository;
import com.workout.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;
import java.util.stream.Collectors;

@RestController
@RequestMapping("/api/exercises")
@CrossOrigin(origins = "*")
public class ExerciseController extends BaseController {
    
    private final ExerciseRepository exerciseRepository;
    private final WorkoutRepository workoutRepository;
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    
    public ExerciseController(ExerciseRepository exerciseRepository, WorkoutRepository workoutRepository, 
                           ExerciseTemplateRepository exerciseTemplateRepository, UserService userService) {
        super(userService);
        this.exerciseRepository = exerciseRepository;
        this.workoutRepository = workoutRepository;
        this.exerciseTemplateRepository = exerciseTemplateRepository;
    }
    
    @GetMapping("/workout/{workoutId}")
    public ResponseEntity<List<ExerciseDto>> getExercisesByWorkoutId(@PathVariable Long workoutId,
                                                                   @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        
        // Проверяем доступ к тренировке
        Workout workout = workoutRepository.findById(workoutId)
                .orElseThrow(() -> new RuntimeException("Workout not found"));
        
        if (!workout.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        List<Exercise> exercises = exerciseRepository.findByWorkoutIdOrderByExerciseOrder(workoutId);
        List<ExerciseDto> exerciseDtos = exercises.stream()
                .map(this::convertToDto)
                .collect(Collectors.toList());
        
        return ResponseEntity.ok(exerciseDtos);
    }
    
    @PostMapping
    public ResponseEntity<ExerciseDto> createExercise(@Valid @RequestBody ExerciseDto exerciseDto,
                                                     @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        
        // Проверяем доступ к тренировке
        Workout workout = workoutRepository.findById(exerciseDto.getWorkoutId())
                .orElseThrow(() -> new RuntimeException("Workout not found"));
        
        if (!workout.getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        // Если порядок не указан, определяем автоматически
        if (exerciseDto.getExerciseOrder() == null) {
            Integer maxOrder = exerciseRepository.findMaxExerciseOrderByWorkoutId(exerciseDto.getWorkoutId());
            exerciseDto.setExerciseOrder(maxOrder != null ? maxOrder + 1 : 1);
        }
        
        Exercise exercise = convertToEntity(exerciseDto, workout);
        Exercise savedExercise = exerciseRepository.save(exercise);
        
        return ResponseEntity.ok(convertToDto(savedExercise));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ExerciseDto> updateExercise(@PathVariable Long id,
                                                     @Valid @RequestBody ExerciseDto exerciseDto,
                                                     @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Exercise not found"));
        
        if (!exercise.getWorkout().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        // Обновляем только параметры упражнения, шаблон остается тем же
        exercise.setSets(exerciseDto.getSets());
        exercise.setReps(exerciseDto.getReps());
        exercise.setWeight(exerciseDto.getWeight());
        exercise.setRestTime(exerciseDto.getRestTime());
        exercise.setExerciseOrder(exerciseDto.getExerciseOrder());
        exercise.setNotes(exerciseDto.getNotes());
        
        Exercise savedExercise = exerciseRepository.save(exercise);
        return ResponseEntity.ok(convertToDto(savedExercise));
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteExercise(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Exercise not found"));
        
        if (!exercise.getWorkout().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        Long workoutId = exercise.getWorkout().getId();
        Integer deletedOrder = exercise.getExerciseOrder();
        
        exerciseRepository.deleteById(id);
        
        // Обновляем порядок оставшихся упражнений
        updateExerciseOrderAfterDeletion(workoutId, deletedOrder);
        
        return ResponseEntity.noContent().build();
    }
    
    @PutMapping("/{id}/order")
    public ResponseEntity<ExerciseDto> updateExerciseOrder(@PathVariable Long id,
                                                          @RequestParam Integer newOrder,
                                                          @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        
        Exercise exercise = exerciseRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Exercise not found"));
        
        if (!exercise.getWorkout().getUser().getId().equals(user.getId())) {
            throw new RuntimeException("Access denied");
        }
        
        Long workoutId = exercise.getWorkout().getId();
        Integer oldOrder = exercise.getExerciseOrder();
        
        // Обновляем порядок других упражнений
        if (newOrder < oldOrder) {
            // Перемещаем вверх - увеличиваем порядок упражнений между новым и старым
            List<Exercise> exercisesToUpdate = exerciseRepository.findByWorkoutId(workoutId);
            for (Exercise ex : exercisesToUpdate) {
                if (ex.getExerciseOrder() >= newOrder && ex.getExerciseOrder() < oldOrder) {
                    ex.setExerciseOrder(ex.getExerciseOrder() + 1);
                    exerciseRepository.save(ex);
                }
            }
        } else if (newOrder > oldOrder) {
            // Перемещаем вниз - уменьшаем порядок упражнений между старым и новым
            List<Exercise> exercisesToUpdate = exerciseRepository.findByWorkoutId(workoutId);
            for (Exercise ex : exercisesToUpdate) {
                if (ex.getExerciseOrder() > oldOrder && ex.getExerciseOrder() <= newOrder) {
                    ex.setExerciseOrder(ex.getExerciseOrder() - 1);
                    exerciseRepository.save(ex);
                }
            }
        }
        
        // Устанавливаем новый порядок для текущего упражнения
        exercise.setExerciseOrder(newOrder);
        Exercise savedExercise = exerciseRepository.save(exercise);
        
        return ResponseEntity.ok(convertToDto(savedExercise));
    }
    
    private ExerciseDto convertToDto(Exercise exercise) {
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
    
    private Exercise convertToEntity(ExerciseDto dto, Workout workout) {
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
    
    /**
     * Обновляет порядок упражнений после удаления
     */
    private void updateExerciseOrderAfterDeletion(Long workoutId, Integer deletedOrder) {
        List<Exercise> exercisesToUpdate = exerciseRepository.findByWorkoutId(workoutId);
        
        for (Exercise exercise : exercisesToUpdate) {
            if (exercise.getExerciseOrder() > deletedOrder) {
                exercise.setExerciseOrder(exercise.getExerciseOrder() - 1);
                exerciseRepository.save(exercise);
            }
        }
    }
}
