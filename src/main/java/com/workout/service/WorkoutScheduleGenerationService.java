package com.workout.service;

import com.workout.dto.WorkoutDto;
import com.workout.dto.ProgressionDto;
import com.workout.dto.ExerciseDto;
import com.workout.entity.*;
import com.workout.entity.Progression.PeriodicityType;
import com.workout.entity.Progression.IncrementType;
import com.workout.repository.ExerciseTemplateRepository;
import com.workout.repository.WorkoutRepository;
import com.workout.repository.WorkoutScheduleRepository;
import com.workout.repository.WorkoutScheduleExerciseRepository;
import com.workout.repository.UserRepository;
import com.workout.repository.SetExecutionRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

/**
 * Сервис для генерации расписания тренировок на основе шаблона тренировки и прогрессии
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkoutScheduleGenerationService {
    
    private final ExerciseTemplateRepository exerciseTemplateRepository;
    private final WorkoutRepository workoutRepository;
    private final WorkoutScheduleRepository workoutScheduleRepository;
    private final WorkoutScheduleExerciseRepository workoutScheduleExerciseRepository;
    private final UserRepository userRepository;
    private final SetExecutionRepository setExecutionRepository;
    
    /**
     * Генерирует расписание тренировок на основе существующей тренировки
     * НЕ СОХРАНЯЕТ в БД - только создает объекты для предварительного просмотра
     * 
     * @param workoutDto шаблон тренировки
     * @param startDate дата начала
     * @param weeksCount количество недель
     * @param userId ID пользователя
     * @return список созданных расписаний по неделям (без ID, не сохранены в БД)
     */
    public List<WorkoutSchedule> generateScheduleFromWorkout(
            WorkoutDto workoutDto, 
            LocalDate startDate, 
            Integer weeksCount,
            Long userId) {
        
        log.info("Generating schedule preview for workout: {}, startDate: {}, weeksCount: {}", 
                workoutDto.getName(), startDate, weeksCount);
        
        List<WorkoutSchedule> createdSchedules = new ArrayList<>();
        LocalDate currentDate = startDate;
        
        // Генерируем расписание для каждой недели
        for (int week = 1; week <= weeksCount; week++) {
            WorkoutSchedule schedule = createWeeklySchedule(
                workoutDto, week, currentDate, userId
            );
            
            // Создаем упражнения в расписании с учетом прогрессии
            createScheduleExercises(schedule, workoutDto.getExercises(), week, createdSchedules);
            
            createdSchedules.add(schedule);
            currentDate = currentDate.plusWeeks(1);
        }
        
        log.info("Generated {} weekly schedule previews", createdSchedules.size());
        
        // Логируем для отладки - проверяем exerciseId в возвращаемых объектах
        for (WorkoutSchedule schedule : createdSchedules) {
            if (schedule.getExercises() != null) {
                for (WorkoutScheduleExercise exercise : schedule.getExercises()) {
                    log.info("Returning exercise with exerciseId: {} for week: {}", 
                            exercise.getExerciseId(), schedule.getWeekNumber());
                }
            }
        }
        
        return createdSchedules;
    }
    
    /**
     * Создает и сохраняет расписания в БД на основе сгенерированного плана
     * 
     * @param schedules список расписаний для сохранения
     * @return список сохраненных расписаний с ID
     */
    @Transactional
    public List<WorkoutSchedule> createSchedulesInDatabase(List<WorkoutSchedule> schedules) {
        log.info("Creating {} schedules in database", schedules.size());
        
        List<WorkoutSchedule> savedSchedules = new ArrayList<>();
        
        for (WorkoutSchedule schedule : schedules) {
            // Сохраняем основное расписание
            WorkoutSchedule savedSchedule = workoutScheduleRepository.save(schedule);
            
            // Сохраняем упражнения в расписании
            if (schedule.getExercises() != null) {
                for (WorkoutScheduleExercise exercise : schedule.getExercises()) {
                    exercise.setWorkoutSchedule(savedSchedule);
                }
                workoutScheduleExerciseRepository.saveAll(schedule.getExercises());
                
                // Создаем записи подходов для каждого упражнения
                for (WorkoutScheduleExercise exercise : schedule.getExercises()) {
                    createSetExecutions(exercise);
                }
                
                // Сохраняем все созданные подходы в БД
                List<SetExecution> allSetExecutions = new ArrayList<>();
                for (WorkoutScheduleExercise exercise : schedule.getExercises()) {
                    if (exercise.getSetExecutions() != null) {
                        allSetExecutions.addAll(exercise.getSetExecutions());
                    }
                }
                if (!allSetExecutions.isEmpty()) {
                    setExecutionRepository.saveAll(allSetExecutions);
                }
                
                savedSchedule.setExercises(schedule.getExercises());
            }
            
            savedSchedules.add(savedSchedule);
        }
        
        log.info("Successfully created {} schedules in database", savedSchedules.size());
        return savedSchedules;
    }
    
    /**
     * Создает расписание для конкретной недели (без сохранения в БД)
     */
    private WorkoutSchedule createWeeklySchedule(
            WorkoutDto workoutDto, 
            int weekNumber, 
            LocalDate workoutDate, 
            Long userId) {
        
        // Получаем пользователя и тренировку
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        Workout workout = workoutRepository.findById(workoutDto.getId())
                .orElseThrow(() -> new RuntimeException("Workout not found"));
        
        WorkoutSchedule schedule = new WorkoutSchedule();
        schedule.setUser(user);
        schedule.setWorkout(workout);
        schedule.setWeekNumber(weekNumber);
        schedule.setWorkoutDate(workoutDate);
        schedule.setStatus(WorkoutSchedule.ExecutionStatus.PLANNED);
        schedule.setCreatedAt(LocalDateTime.now());
        schedule.setUpdatedAt(LocalDateTime.now());
        
        // НЕ сохраняем в БД - только создаем объект
        return schedule;
    }
    
    /**
     * Создает упражнения в расписании с учетом прогрессии (без сохранения в БД)
     */
    private void createScheduleExercises(
            WorkoutSchedule schedule, 
            List<ExerciseDto> exercises, 
            int weekNumber,
            List<WorkoutSchedule> createdSchedules) {
        
        if (exercises == null || exercises.isEmpty()) {
            log.warn("No exercises provided for schedule week: {}", weekNumber);
            return;
        }
        
        log.info("Creating schedule exercises for week: {}, exercises count: {}", weekNumber, exercises.size());
        
        List<WorkoutScheduleExercise> scheduleExercises = new ArrayList<>();
        
        for (int i = 0; i < exercises.size(); i++) {
            ExerciseDto exerciseDto = exercises.get(i);
            
            // Логируем каждое упражнение
            log.info("Processing exercise {}: id={}, templateId={}, name={}", 
                    i + 1, exerciseDto.getId(), exerciseDto.getExerciseTemplateId(), 
                    exerciseDto.getExerciseName());
            
            // Получаем шаблон упражнения
            ExerciseTemplate template = exerciseTemplateRepository.findById(exerciseDto.getExerciseTemplateId())
                    .orElseThrow(() -> new RuntimeException("Exercise template not found"));
            
            // Получаем предыдущие значения для конкретного упражнения
            Float previousWeight = getPreviousValue(exerciseDto.getId(), createdSchedules, weekNumber, "weight");
            Float previousReps = getPreviousValue(exerciseDto.getId(), createdSchedules, weekNumber, "reps");
            Float previousSets = getPreviousValue(exerciseDto.getId(), createdSchedules, weekNumber, "sets");
            
            // Рассчитываем параметры для этой недели с учетом прогрессии
            float weight = calculateWeightForWeek(exerciseDto, weekNumber, previousWeight, previousSets, previousReps);
            int reps = calculateRepsForWeek(exerciseDto, weekNumber, previousReps);
            int sets = calculateSetsForWeek(exerciseDto, weekNumber, previousSets, previousReps);
            int restTime = exerciseDto.getRestTime();
            
            WorkoutScheduleExercise scheduleExercise = new WorkoutScheduleExercise();
            scheduleExercise.setWorkoutSchedule(schedule);
            scheduleExercise.setExerciseTemplate(template);
            
            // Логируем для отладки
            log.info("Setting exerciseId: {} for exercise template: {} (week: {})", 
                    exerciseDto.getId(), exerciseDto.getExerciseTemplateId(), weekNumber);
            
            scheduleExercise.setExerciseId(exerciseDto.getId()); // Устанавливаем ID упражнения из тренировки
            scheduleExercise.setPlannedWeight(weight);
            scheduleExercise.setPlannedReps(reps);
            scheduleExercise.setPlannedSets(sets);
            scheduleExercise.setPlannedRestTime(restTime);
            scheduleExercise.setExerciseOrder(exerciseDto.getExerciseOrder() != null ? 
                exerciseDto.getExerciseOrder() : (i + 1)); // Используем порядок из шаблона или i+1 как fallback
            
            log.info("Exercise order set to: {} (from template: {}, fallback: {})", 
                    scheduleExercise.getExerciseOrder(), exerciseDto.getExerciseOrder(), (i + 1));
            
            scheduleExercise.setStatus(WorkoutScheduleExercise.ExerciseStatus.PLANNED);
            scheduleExercise.setCreatedAt(LocalDateTime.now());
            scheduleExercise.setUpdatedAt(LocalDateTime.now());
            
            scheduleExercises.add(scheduleExercise);
        }
        
        // НЕ сохраняем в БД - только устанавливаем связь
        schedule.setExercises(scheduleExercises);
    }
    
    /**
     * Рассчитывает вес для конкретной недели с учетом прогрессии
     */
    private float calculateWeightForWeek(ExerciseDto exercise, int week, Float previousWeight, Float previousSets, Float previousReps) {
        ProgressionDto progression = exercise.getProgression();
        if (progression == null || !progression.getWeightProgressionEnabled()) {
            return previousWeight != null ? previousWeight : exercise.getWeight();
        }
        
        switch (progression.getWeightPeriodicity()) {
            case FIXED:
                return progression.getWeightIncrementValue() != null ? 
                    progression.getWeightIncrementValue() : exercise.getWeight();
                    
            case EVERY_WORKOUT:
                if (progression.getWeightIncrementType() == IncrementType.INCREMENT) {
                    return exercise.getWeight() + (progression.getWeightIncrementValue() * (week - 1));
                } else if (progression.getWeightIncrementType() == IncrementType.CYCLE) {
                    // Для CYCLE первая неделя возвращает значения из упражнения
                    if (week == 1) {
                        return exercise.getWeight();
                    }
                    
                    // Для остальных недель прогрессируем от предыдущего значения
                    float currentValue = previousWeight != null ? previousWeight : exercise.getWeight();
                    return currentValue + progression.getWeightIncrementValue();
                }
                break;
                
            case CONDITIONAL:
                // Для условного изменения веса проверяем условия
                if (progression.getWeightIncrementType() == IncrementType.INCREMENT) {
                    // Проверяем условия: предыдущие подходы >= 4 И предыдущие повторения >= 12
                    int currentSets = previousSets != null ? previousSets.intValue() : exercise.getSets();
                    int currentReps = previousReps != null ? previousReps.intValue() : exercise.getReps();
                    
                    boolean conditionsMet = currentSets >= progression.getWeightConditionSets() &&
                                          currentReps >= progression.getWeightConditionReps();
                    
                    if (conditionsMet) {
                        // Условия выполнены - увеличиваем вес
                        float currentWeight = previousWeight != null ? previousWeight : exercise.getWeight();
                        return currentWeight + progression.getWeightIncrementValue();
                    }
                }
                break;
        }
        
        // Если прогрессия не включена или не подходит под условия, возвращаем предыдущее значение
        return previousWeight != null ? previousWeight : exercise.getWeight();
    }
    
    /**
     * Рассчитывает повторения для конкретной недели с учетом прогрессии
     */
    private int calculateRepsForWeek(ExerciseDto exercise, int week, Float previousReps) {
        ProgressionDto progression = exercise.getProgression();
        if (progression == null || !progression.getRepsProgressionEnabled()) {
            return previousReps != null ? previousReps.intValue() : exercise.getReps();
        }
        
        switch (progression.getRepsPeriodicity()) {
            case FIXED:
                return progression.getRepsIncrementValue() != null ? 
                    progression.getRepsIncrementValue() : exercise.getReps();
                    
            case EVERY_WORKOUT:
                if (progression.getRepsIncrementType() == IncrementType.INCREMENT) {
                    return exercise.getReps() + (progression.getRepsIncrementValue() * (week - 1));
                } else if (progression.getRepsIncrementType() == IncrementType.CYCLE) {
                    // Для CYCLE первая неделя возвращает значения из упражнения
                    if (week == 1) {
                        return exercise.getReps();
                    }
                    
                    // Для остальных недель сначала проверяем предыдущее значение на максимум
                    int currentValue = previousReps != null ? previousReps.intValue() : exercise.getReps();
                    
                    // Если предыдущее значение уже достигло максимума, переключаемся на начальное для цикла
                    if (progression.getRepsFinalValue() != null && currentValue >= progression.getRepsFinalValue()) {
                        return progression.getRepsInitialValue();
                    }
                    
                    // Иначе прогрессируем: предыдущее значение + инкремент
                    return currentValue + progression.getRepsIncrementValue();
                }
                break;
                
            case CONDITIONAL:
                // TODO: Логика для условного изменения повторений
                break;
        }
        
        return exercise.getReps();
    }
    
    /**
     * Рассчитывает подходы для конкретной недели с учетом прогрессии
     */
    private int calculateSetsForWeek(ExerciseDto exercise, int week, Float previousSets, Float previousReps) {
        ProgressionDto progression = exercise.getProgression();
        if (progression == null || !progression.getSetsProgressionEnabled()) {
            return previousSets != null ? previousSets.intValue() : exercise.getSets();
        }
        
        switch (progression.getSetsPeriodicity()) {
            case FIXED:
                return progression.getSetsIncrementValue() != null ? 
                    progression.getSetsIncrementValue() : exercise.getSets();
                    
            case EVERY_WORKOUT:
                if (progression.getSetsIncrementType() == IncrementType.INCREMENT) {
                    return exercise.getSets() + (progression.getSetsIncrementValue() * (week - 1));
                } else if (progression.getSetsIncrementType() == IncrementType.CYCLE) {
                    // Для CYCLE первая неделя возвращает значения из упражнения
                    if (week == 1) {
                        return exercise.getSets();
                    }
                    
                    // Для остальных недель прогрессируем от предыдущего значения
                    int currentValue = previousSets != null ? previousSets.intValue() : exercise.getSets();
                    return currentValue + progression.getSetsIncrementValue();
                }
                break;
                
            case CONDITIONAL:
                // Для условного изменения подходов проверяем условия
                if (progression.getSetsIncrementType() == IncrementType.CYCLE) {
                    // Проверяем условие: предыдущие повторения >= 12
                    int currentReps = previousReps != null ? previousReps.intValue() : exercise.getReps();
                    if (currentReps >= progression.getSetsConditionReps()) {
                        // Сначала проверяем предыдущие подходы на максимум
                        int currentSets = previousSets != null ? previousSets.intValue() : exercise.getSets();
                        
                        // Если предыдущие подходы уже достигли максимума, переключаемся на начальное
                        if (progression.getSetsFinalValue() != null && currentSets >= progression.getSetsFinalValue()) {
                            return progression.getSetsInitialValue() != null ? 
                                progression.getSetsInitialValue() : exercise.getSets();
                        }
                        
                        // Иначе прогрессируем: предыдущие подходы + инкремент
                        return currentSets + progression.getSetsIncrementValue();
                    }
                }
                break;
        }
        
        // Если прогрессия не включена или не подходит под условия, возвращаем предыдущее значение
        return previousSets != null ? previousSets.intValue() : exercise.getSets();
    }
    
    /**
     * Получает предыдущее значение для конкретного упражнения
     */
    private Float getPreviousValue(Long exerciseId, List<WorkoutSchedule> createdSchedules, int currentWeek, String valueType) {
        if (currentWeek <= 1 || createdSchedules.isEmpty()) {
            return null; // Для первой недели нет предыдущих значений
        }
        
        // Ищем предыдущую неделю
        WorkoutSchedule previousSchedule = createdSchedules.get(currentWeek - 2);
        if (previousSchedule.getExercises() == null) {
            return null;
        }
        
        // Ищем упражнение с тем же exerciseId
        for (WorkoutScheduleExercise exercise : previousSchedule.getExercises()) {
            if (exercise.getExerciseId().equals(exerciseId)) {
                switch (valueType) {
                    case "weight":
                        return exercise.getPlannedWeight();
                    case "reps":
                        return (float) exercise.getPlannedReps();
                    case "sets":
                        return (float) exercise.getPlannedSets();
                    default:
                        return null;
                }
            }
        }
        
        return null; // Упражнение не найдено
    }
    
    /**
     * Вспомогательный метод для расчета количества недель, необходимых для достижения максимального значения
     * при прогрессии с начальным значением, инкрементом и финальным значением.
     */
    private int getWeeksToReachMax(int startValue, int increment, int finalValue) {
        if (increment <= 0) {
            return 0; // Инкремент должен быть положительным
        }
        if (startValue >= finalValue) {
            return 0; // Если начальное значение уже больше или равно финальному, нет недель
        }
        return (finalValue - startValue) / increment + 1;
    }
    
    /**
     * Создает записи SetExecution для каждого планируемого подхода в расписании
     */
    private void createSetExecutions(WorkoutScheduleExercise scheduleExercise) {
        int plannedSets = scheduleExercise.getPlannedSets();
        
        // Создаем записи для каждого планируемого подхода
        for (int setNumber = 1; setNumber <= plannedSets; setNumber++) {
            SetExecution setExecution = new SetExecution();
            setExecution.setWorkoutScheduleExercise(scheduleExercise);
            setExecution.setSetNumber(setNumber);
            
            // Устанавливаем планируемые значения для подхода
            setExecution.setPlannedWeight(scheduleExercise.getPlannedWeight());
            setExecution.setPlannedReps(scheduleExercise.getPlannedReps());
            
            // Устанавливаем планируемые значения как начальные для фактических (пользователь может изменить)
            setExecution.setActualWeight(scheduleExercise.getPlannedWeight());
            setExecution.setActualReps(scheduleExercise.getPlannedReps());
            setExecution.setRestTime(scheduleExercise.getPlannedRestTime());
            
            // Устанавливаем статус подхода
            setExecution.setStatus(SetExecution.SetStatus.PLANNED);
            
            // Время выполнения (пока пустое, заполнится при выполнении)
            setExecution.setStartTime(java.time.LocalTime.now());
            
            // Добавляем в список подходов упражнения
            if (scheduleExercise.getSetExecutions() == null) {
                scheduleExercise.setSetExecutions(new ArrayList<>());
            }
            scheduleExercise.getSetExecutions().add(setExecution);
            
            log.debug("Created set {}: planned={}kg x {} reps, actual={}kg x {} reps, status={}", 
                    setNumber, 
                    setExecution.getPlannedWeight(), setExecution.getPlannedReps(),
                    setExecution.getActualWeight(), setExecution.getActualReps(),
                    setExecution.getStatus());
        }
        
        log.info("Created {} set executions for exercise: {}", plannedSets, scheduleExercise.getExerciseId());
    }
}
