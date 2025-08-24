--liquibase formatted sql

-- Добавление поля exercise_id в таблицу workout_schedule_exercises

ALTER TABLE workout_schedule_exercises 
ADD COLUMN IF NOT EXISTS exercise_id BIGINT REFERENCES exercises(id);
