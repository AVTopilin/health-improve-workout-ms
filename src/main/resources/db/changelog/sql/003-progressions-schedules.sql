-- --liquibase formatted sql

-- Создание таблиц прогрессии и расписания

-- Прогрессия
CREATE TABLE IF NOT EXISTS progressions (
    id BIGSERIAL PRIMARY KEY,
    exercise_id BIGINT REFERENCES exercises(id) ON DELETE CASCADE,
    user_id BIGINT REFERENCES users(id),
    exercise_template_id BIGINT REFERENCES exercise_templates(id),
    
    -- Прогрессия веса
    weight_progression_enabled BOOLEAN DEFAULT FALSE,
    weight_periodicity VARCHAR(50), -- FIXED, EVERY_WORKOUT, CONDITIONAL
    weight_increment_type VARCHAR(50), -- FIXED, INCREMENT, CYCLE
    weight_increment_value DECIMAL(5,2),
    weight_initial_value DECIMAL(5,2),
    weight_final_value DECIMAL(5,2),
    weight_condition_sets INTEGER,
    weight_condition_reps INTEGER,
    
    -- Прогрессия повторений
    reps_progression_enabled BOOLEAN DEFAULT FALSE,
    reps_periodicity VARCHAR(50),
    reps_increment_type VARCHAR(50),
    reps_increment_value INTEGER,
    reps_initial_value INTEGER,
    reps_final_value INTEGER,
    
    -- Прогрессия подходов
    sets_progression_enabled BOOLEAN DEFAULT FALSE,
    sets_periodicity VARCHAR(50),
    sets_increment_type VARCHAR(50),
    sets_increment_value INTEGER,
    sets_initial_value INTEGER,
    sets_final_value INTEGER,
    sets_condition_reps INTEGER,
    
    -- Общие параметры
    weeks_count INTEGER,
    start_date DATE,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Расписание тренировок
CREATE TABLE IF NOT EXISTS workout_schedules (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    workout_id BIGINT NOT NULL REFERENCES workouts(id),
    workout_date DATE NOT NULL,
    week_number INTEGER NOT NULL,
    status VARCHAR(50) DEFAULT 'PLANNED', -- PLANNED, COMPLETED, SKIPPED
    notes TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Упражнения в расписании
CREATE TABLE IF NOT EXISTS workout_schedule_exercises (
    id BIGSERIAL PRIMARY KEY,
    workout_schedule_id BIGINT NOT NULL REFERENCES workout_schedules(id) ON DELETE CASCADE,
    exercise_template_id BIGINT NOT NULL REFERENCES exercise_templates(id),
    exercise_order INTEGER NOT NULL,
    
    -- Планируемые параметры
    planned_weight DECIMAL(5,2),
    planned_reps INTEGER,
    planned_sets INTEGER,
    planned_rest_time INTEGER,
    
    -- Фактические параметры
    actual_weight DECIMAL(5,2),
    actual_reps INTEGER,
    actual_sets INTEGER,
    actual_rest_time INTEGER,
    
    -- Статус выполнения
    status VARCHAR(50) DEFAULT 'PLANNED', -- PLANNED, COMPLETED, SKIPPED
    notes TEXT,
    
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
