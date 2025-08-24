package com.workout.service;

import com.workout.entity.WorkoutSchedule;
import com.workout.entity.User;
import com.workout.exception.NotFoundException;
import com.workout.exception.AccessDeniedException;
import com.workout.repository.WorkoutScheduleRepository;
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
     * Удалить расписание
     */
    @Transactional
    public void deleteSchedule(Long id, Long userId) {
        log.info("Deleting schedule: {} for user: {}", id, userId);
        
        WorkoutSchedule schedule = getScheduleById(id, userId);
        workoutScheduleRepository.delete(schedule);
    }
}
