package com.workout.service;

import com.workout.entity.WorkoutSchedule;
import com.workout.entity.WorkoutScheduleExercise;
import com.workout.entity.SetExecution;
import com.workout.entity.User;
import com.workout.exception.NotFoundException;
import com.workout.exception.AccessDeniedException;
import com.workout.repository.WorkoutScheduleRepository;
import com.workout.repository.WorkoutScheduleExerciseRepository;
import com.workout.repository.SetExecutionRepository;
import com.workout.dto.WorkoutScheduleStatusUpdateDto;
import com.workout.dto.WorkoutScheduleExerciseUpdateDto;
import com.workout.dto.SetExecutionUpdateDto;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDate;
import java.util.List;

/**
 * Сервис для управления расписанием тренировок
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WorkoutScheduleService {
    
    private final WorkoutScheduleRepository workoutScheduleRepository;
    private final WorkoutScheduleExerciseRepository workoutScheduleExerciseRepository;
    private final SetExecutionRepository setExecutionRepository;
    
    /**
     * Получить все расписания пользователя
     */
    @Transactional(readOnly = true)
    public List<WorkoutSchedule> getSchedulesByUserId(Long userId) {
        log.info("Getting schedules for user: {}", userId);
        return workoutScheduleRepository.findByUserId(userId);
    }
    
    /**
     * Получить расписание по ID
     */
    @Transactional(readOnly = true)
    public WorkoutSchedule getScheduleById(Long id, Long userId) {
        log.info("Getting schedule by id: {} for user: {}", id, userId);
        WorkoutSchedule schedule = workoutScheduleRepository.findById(id)
                .orElseThrow(() -> new NotFoundException("Schedule not found"));
        
        if (!schedule.getUser().getId().equals(userId)) {
            throw new AccessDeniedException("Access denied");
        }
        
        return schedule;
    }
    
    /**
     * Получить расписания для конкретной тренировки
     */
    @Transactional(readOnly = true)
    public List<WorkoutSchedule> getSchedulesByWorkoutId(Long workoutId, Long userId) {
        log.info("Getting schedules for workout: {} and user: {}", workoutId, userId);
        return workoutScheduleRepository.findByUserIdAndWorkoutId(userId, workoutId);
    }
    
    /**
     * Получить расписания в диапазоне дат
     */
    @Transactional(readOnly = true)
    public List<WorkoutSchedule> getSchedulesByDateRange(Long userId, LocalDate startDate, LocalDate endDate) {
        log.info("Getting schedules for user: {} in date range: {} to {}", userId, startDate, endDate);
        return workoutScheduleRepository.findByUserIdAndDateRange(userId, startDate, endDate);
    }
    
    /**
     * Получить расписания по номеру недели
     */
    @Transactional(readOnly = true)
    public List<WorkoutSchedule> getSchedulesByWeekNumber(Long userId, Integer weekNumber) {
        log.info("Getting schedules for user: {} and week: {}", userId, weekNumber);
        return workoutScheduleRepository.findByUserIdAndWeekNumber(userId, weekNumber);
    }
    
    /**
     * Получить расписания по статусу
     */
    @Transactional(readOnly = true)
    public List<WorkoutSchedule> getSchedulesByStatus(Long userId, WorkoutSchedule.ExecutionStatus status) {
        log.info("Getting schedules for user: {} with status: {}", userId, status);
        return workoutScheduleRepository.findByUserIdAndStatus(userId, status);
    }
    
    /**
     * Обновить статус расписания
     */
    @Transactional
    public WorkoutSchedule updateScheduleStatus(Long id, String status, Long userId) {
        log.info("Updating schedule {} status to: {} for user: {}", id, status, userId);
        
        WorkoutSchedule schedule = getScheduleById(id, userId);
        
        try {
            WorkoutSchedule.ExecutionStatus newStatus = WorkoutSchedule.ExecutionStatus.valueOf(status.toUpperCase());
            schedule.setStatus(newStatus);
            return workoutScheduleRepository.save(schedule);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid status: " + status);
        }
    }
    
    /**
     * Обновить статус и время выполнения тренировки
     */
    @Transactional
    public WorkoutSchedule updateScheduleStatus(Long id, Long userId, WorkoutScheduleStatusUpdateDto updateDto) {
        log.info("Updating schedule {} status and time for user: {}", id, userId);
        
        WorkoutSchedule schedule = getScheduleById(id, userId);
        
        try {
            WorkoutSchedule.ExecutionStatus newStatus = WorkoutSchedule.ExecutionStatus.valueOf(updateDto.getStatus().toUpperCase());
            schedule.setStatus(newStatus);
            
            if (updateDto.getStartTime() != null) {
                schedule.setStartTime(updateDto.getStartTime());
            }
            if (updateDto.getEndTime() != null) {
                schedule.setEndTime(updateDto.getEndTime());
            }
            if (updateDto.getNotes() != null) {
                schedule.setNotes(updateDto.getNotes());
            }
            
            return workoutScheduleRepository.save(schedule);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid status: " + updateDto.getStatus());
        }
    }
    
    /**
     * Обновить статус и время выполнения упражнения
     */
    @Transactional
    public WorkoutScheduleExercise updateExerciseStatus(Long exerciseId, Long userId, WorkoutScheduleExerciseUpdateDto updateDto) {
        log.info("Updating exercise {} status and time for user: {}", exerciseId, userId);
        
        // TODO: Добавить проверку доступа к упражнению
        WorkoutScheduleExercise exercise = workoutScheduleExerciseRepository.findById(exerciseId)
                .orElseThrow(() -> new NotFoundException("Exercise not found"));
        
        try {
            WorkoutScheduleExercise.ExerciseStatus newStatus = WorkoutScheduleExercise.ExerciseStatus.valueOf(updateDto.getStatus().toUpperCase());
            exercise.setStatus(newStatus);
            
            if (updateDto.getStartTime() != null) {
                exercise.setStartTime(updateDto.getStartTime());
            }
            if (updateDto.getEndTime() != null) {
                exercise.setEndTime(updateDto.getEndTime());
            }
            if (updateDto.getActualWeight() != null) {
                exercise.setActualWeight(updateDto.getActualWeight());
            }
            if (updateDto.getActualReps() != null) {
                exercise.setActualReps(updateDto.getActualReps());
            }
            if (updateDto.getActualSets() != null) {
                exercise.setActualSets(updateDto.getActualSets());
            }
            if (updateDto.getActualRestTime() != null) {
                exercise.setActualRestTime(updateDto.getActualRestTime());
            }
            if (updateDto.getNotes() != null) {
                exercise.setNotes(updateDto.getNotes());
            }
            
            return workoutScheduleExerciseRepository.save(exercise);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid status: " + updateDto.getStatus());
        }
    }
    
    /**
     * Обновить статус и время выполнения подхода
     */
    @Transactional
    public SetExecution updateSetStatus(Long setId, Long userId, SetExecutionUpdateDto updateDto) {
        log.info("Updating set {} status and time for user: {}", setId, userId);
        
        // TODO: Добавить проверку доступа к подходу
        SetExecution setExecution = setExecutionRepository.findById(setId)
                .orElseThrow(() -> new NotFoundException("Set execution not found"));
        
        try {
            SetExecution.SetStatus newStatus = SetExecution.SetStatus.valueOf(updateDto.getStatus().toUpperCase());
            setExecution.setStatus(newStatus);
            
            if (updateDto.getStartTime() != null) {
                setExecution.setStartTime(updateDto.getStartTime());
            }
            if (updateDto.getEndTime() != null) {
                setExecution.setEndTime(updateDto.getEndTime());
            }
            if (updateDto.getActualWeight() != null) {
                setExecution.setActualWeight(updateDto.getActualWeight());
            }
            if (updateDto.getActualReps() != null) {
                setExecution.setActualReps(updateDto.getActualReps());
            }
            if (updateDto.getRestTime() != null) {
                setExecution.setRestTime(updateDto.getRestTime());
            }
            if (updateDto.getNotes() != null) {
                setExecution.setNotes(updateDto.getNotes());
            }
            
            return setExecutionRepository.save(setExecution);
        } catch (IllegalArgumentException e) {
            throw new IllegalArgumentException("Invalid status: " + updateDto.getStatus());
        }
    }
    
    /**
     * Удалить расписание
     */
    @Transactional
    public void deleteSchedule(Long id, Long userId) {
        log.info("Deleting schedule: {} for user: {}", id, userId);
        
        WorkoutSchedule schedule = getScheduleById(id, userId);
        workoutScheduleRepository.delete(schedule);
    }
}
