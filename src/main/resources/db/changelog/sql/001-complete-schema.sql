-- =====================================================
-- ПОЛНАЯ МИГРАЦИЯ СХЕМЫ БАЗЫ ДАННЫХ WORKOUT APP
-- =====================================================

-- 1. СОЗДАНИЕ БАЗОВЫХ ТАБЛИЦ
-- =====================================================

-- Таблица пользователей
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    keycloak_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Таблица тренировок
CREATE TABLE IF NOT EXISTS workouts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    day_of_week VARCHAR(50),
    weeks_count INTEGER,
    start_date DATE,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Таблица упражнений
CREATE TABLE IF NOT EXISTS exercises (
    id BIGSERIAL PRIMARY KEY,
    workout_id BIGINT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_template_id BIGINT,
    weight DECIMAL(5,2),
    reps INTEGER,
    sets INTEGER,
    rest_time INTEGER,
    exercise_order INTEGER NOT NULL,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 2. СОЗДАНИЕ СПРАВОЧНЫХ ТАБЛИЦ
-- =====================================================

-- Группы мышц
CREATE TABLE IF NOT EXISTS muscle_groups (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Оборудование
CREATE TABLE IF NOT EXISTS equipment (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    type VARCHAR(100),
    description TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- Шаблоны упражнений
CREATE TABLE IF NOT EXISTS exercise_templates (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    muscle_group_id BIGINT REFERENCES muscle_groups(id),
    equipment_id BIGINT REFERENCES equipment(id),
    difficulty_level VARCHAR(50),
    instructions TEXT,
    tips TEXT,
    is_active BOOLEAN DEFAULT TRUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);

-- 3. СОЗДАНИЕ ТАБЛИЦ ПРОГРЕССИИ И РАСПИСАНИЯ
-- =====================================================

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

-- 4. СОЗДАНИЕ ИНДЕКСОВ
-- =====================================================

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

-- 5. СОЗДАНИЕ ТРИГГЕРОВ ДЛЯ updated_at
-- =====================================================

-- Функция для обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column() 
RETURNS TRIGGER AS $$ 
BEGIN 
    NEW.updated_at = CURRENT_TIMESTAMP; 
    RETURN NEW; 
END; 
$$ language 'plpgsql';

-- Триггеры для всех таблиц
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at BEFORE UPDATE ON workouts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_muscle_groups_updated_at BEFORE UPDATE ON muscle_groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_equipment_updated_at BEFORE UPDATE ON equipment
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercise_templates_updated_at BEFORE UPDATE ON exercise_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_progressions_updated_at BEFORE UPDATE ON progressions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_schedules_updated_at BEFORE UPDATE ON workout_schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_schedule_exercises_updated_at BEFORE UPDATE ON workout_schedule_exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 6. ДОБАВЛЕНИЕ ОГРАНИЧЕНИЙ
-- =====================================================

-- Ограничения для прогрессии веса типа CYCLE
ALTER TABLE progressions ADD CONSTRAINT IF NOT EXISTS chk_weight_cycle_values 
CHECK (
    (weight_increment_type != 'CYCLE') OR 
    (weight_increment_type = 'CYCLE' AND weight_initial_value IS NOT NULL AND weight_final_value IS NOT NULL)
);

ALTER TABLE progressions ADD CONSTRAINT IF NOT EXISTS chk_weight_cycle_range 
CHECK (
    (weight_increment_type != 'CYCLE') OR 
    (weight_increment_type = 'CYCLE' AND weight_final_value > weight_initial_value)
);

-- 7. ВСТАВЛЕНИЕ ТЕСТОВЫХ ДАННЫХ
-- =====================================================

-- Тестовые пользователи
INSERT INTO users (username, email, keycloak_id) VALUES
('testuser1', 'test1@example.com', 'test-keycloak-1'),
('testuser2', 'test2@example.com', 'test-keycloak-2'),
('testuser3', 'test3@example.com', 'test-keycloak-3')
ON CONFLICT (username) DO NOTHING;

-- Тестовые группы мышц
INSERT INTO muscle_groups (name, description) VALUES
('Грудь', 'Мышцы грудной клетки'),
('Спина', 'Мышцы спины'),
('Ноги', 'Мышцы ног')
ON CONFLICT (name) DO NOTHING;

-- Тестовое оборудование
INSERT INTO equipment (name, type, description) VALUES
('Штанга', 'BARBELL', 'Олимпийская штанга'),
('Гантели', 'DUMBBELLS', 'Разборные гантели'),
('Скамья', 'BENCH', 'Скамья для жима')
ON CONFLICT (name) DO NOTHING;

-- Тестовые шаблоны упражнений
INSERT INTO exercise_templates (name, description, muscle_group_id, equipment_id, difficulty_level, instructions) VALUES
('Жим лежа', 'Жим штанги лежа на скамье', 
 (SELECT id FROM muscle_groups WHERE name = 'Грудь'), 
 (SELECT id FROM equipment WHERE name = 'Штанга'), 
 'INTERMEDIATE', 'Лягте на скамью, опустите штангу к груди, выжмите вверх'),
('Приседания', 'Приседания со штангой', 
 (SELECT id FROM muscle_groups WHERE name = 'Ноги'), 
 (SELECT id FROM equipment WHERE name = 'Штанга'), 
 'INTERMEDIATE', 'Поставьте штангу на плечи, присядьте до параллели бедер с полом'),
('Тяга верхнего блока', 'Тяга верхнего блока к груди', 
 (SELECT id FROM muscle_groups WHERE name = 'Спина'), 
 (SELECT id FROM equipment WHERE name = 'Штанга'), 
 'BEGINNER', 'Сядьте, возьмите рукоятку, тяните к груди')
ON CONFLICT DO NOTHING;

-- Тестовые тренировки
INSERT INTO workouts (user_id, name, description, day_of_week, weeks_count, start_date) VALUES
((SELECT id FROM users WHERE username = 'testuser1'), 'Тестовая тренировка 1', 'Описание тренировки 1', 'MONDAY', 4, CURRENT_DATE),
((SELECT id FROM users WHERE username = 'testuser2'), 'Тестовая тренировка 2', 'Описание тренировки 2', 'WEDNESDAY', 3, CURRENT_DATE),
((SELECT id FROM users WHERE username = 'testuser3'), 'Тестовая тренировка 3', 'Описание тренировки 3', 'FRIDAY', 2, CURRENT_DATE)
ON CONFLICT DO NOTHING;

-- Тестовые упражнения
INSERT INTO exercises (workout_id, exercise_template_id, weight, reps, sets, rest_time, exercise_order) VALUES
((SELECT id FROM workouts WHERE name = 'Тестовая тренировка 1'), 
 (SELECT id FROM exercise_templates WHERE name = 'Жим лежа'), 80.0, 8, 3, 120, 1),
((SELECT id FROM workouts WHERE name = 'Тестовая тренировка 1'), 
 (SELECT id FROM exercise_templates WHERE name = 'Приседания'), 100.0, 6, 4, 180, 2),
((SELECT id FROM workouts WHERE name = 'Тестовая тренировка 2'), 
 (SELECT id FROM exercise_templates WHERE name = 'Тяга верхнего блока'), 60.0, 10, 3, 90, 1)
ON CONFLICT DO NOTHING;

-- Обновление значений для прогрессии типа CYCLE
UPDATE progressions 
SET weight_initial_value = 0.0, weight_final_value = 100.0 
WHERE weight_increment_type = 'CYCLE' AND weight_initial_value IS NULL;
