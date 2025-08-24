package com.workout.repository;

import com.workout.entity.WorkoutSchedule;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;
import java.time.LocalDate;
import java.util.List;

@Repository
public interface WorkoutScheduleRepository extends JpaRepository<WorkoutSchedule, Long> {
    
    /**
     * Найти все расписания для пользователя
     */
    @Query("SELECT ws FROM WorkoutSchedule ws WHERE ws.user.id = :userId")
    List<WorkoutSchedule> findByUserId(@Param("userId") Long userId);
    
    /**
     * Найти расписания для конкретной тренировки
     */
    @Query("SELECT ws FROM WorkoutSchedule ws WHERE ws.workout.id = :workoutId")
    List<WorkoutSchedule> findByWorkoutId(@Param("workoutId") Long workoutId);
    
    /**
     * Найти расписания для пользователя и тренировки
     */
    @Query("SELECT ws FROM WorkoutSchedule ws WHERE ws.user.id = :userId AND ws.workout.id = :workoutId")
    List<WorkoutSchedule> findByUserIdAndWorkoutId(@Param("userId") Long userId, @Param("workoutId") Long workoutId);
    
    /**
     * Найти расписания в диапазоне дат
     */
    @Query("SELECT ws FROM WorkoutSchedule ws WHERE ws.user.id = :userId AND ws.workoutDate BETWEEN :startDate AND :endDate")
    List<WorkoutSchedule> findByUserIdAndDateRange(
        @Param("userId") Long userId, 
        @Param("startDate") LocalDate startDate, 
        @Param("endDate") LocalDate endDate
    );
    
    /**
     * Найти расписания по номеру недели
     */
    @Query("SELECT ws FROM WorkoutSchedule ws WHERE ws.user.id = :userId AND ws.weekNumber = :weekNumber")
    List<WorkoutSchedule> findByUserIdAndWeekNumber(@Param("userId") Long userId, @Param("weekNumber") Integer weekNumber);
    
    /**
     * Найти расписания по статусу
     */
    @Query("SELECT ws FROM WorkoutSchedule ws WHERE ws.user.id = :userId AND ws.status = :status")
    List<WorkoutSchedule> findByUserIdAndStatus(@Param("userId") Long userId, @Param("status") WorkoutSchedule.ExecutionStatus status);
}
