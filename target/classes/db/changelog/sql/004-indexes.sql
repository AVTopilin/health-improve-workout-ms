-- --liquibase formatted sql

-- Создание индексов для всех таблиц

-- Индексы для users
CREATE INDEX IF NOT EXISTS idx_users_keycloak_id ON users(keycloak_id);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);

-- Индексы для workouts
CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_workouts_active ON workouts(is_active);

-- Индексы для exercises
CREATE INDEX IF NOT EXISTS idx_exercises_workout_id ON exercises(workout_id);
CREATE INDEX IF NOT EXISTS idx_exercises_template_id ON exercises(exercise_template_id);
CREATE INDEX IF NOT EXISTS idx_exercises_active ON exercises(is_active);

-- Индексы для exercise_templates
CREATE INDEX IF NOT EXISTS idx_exercise_templates_muscle_group ON exercise_templates(muscle_group_id);
CREATE INDEX IF NOT EXISTS idx_exercise_templates_equipment ON exercise_templates(equipment_id);
CREATE INDEX IF NOT EXISTS idx_exercise_templates_active ON exercise_templates(is_active);

-- Индексы для progressions
CREATE INDEX IF NOT EXISTS idx_progressions_exercise_id ON progressions(exercise_id);
CREATE INDEX IF NOT EXISTS idx_progressions_user_id ON progressions(user_id);
CREATE INDEX IF NOT EXISTS idx_progressions_template_id ON progressions(exercise_template_id);

-- Индексы для workout_schedules
CREATE INDEX IF NOT EXISTS idx_workout_schedules_user_id ON workout_schedules(user_id);
CREATE INDEX IF NOT EXISTS idx_workout_schedules_workout_id ON workout_schedules(workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_schedules_date ON workout_schedules(workout_date);

-- Индексы для workout_schedule_exercises
CREATE INDEX IF NOT EXISTS idx_workout_schedule_exercises_schedule_id ON workout_schedule_exercises(workout_schedule_id);
CREATE INDEX IF NOT EXISTS idx_workout_schedule_exercises_template_id ON workout_schedule_exercises(exercise_template_id);
