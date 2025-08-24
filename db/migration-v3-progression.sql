-- Миграция v3: Правильная архитектура тренировок и прогрессий
-- Выполнять после создания новых сущностей

-- 1. Удаляем старые таблицы (если существуют)
DROP TABLE IF EXISTS progression_plans CASCADE;
DROP TABLE IF EXISTS progressions CASCADE;

-- 2. Добавляем поля прогрессии в таблицу workouts
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS day_of_week VARCHAR(50);
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS weeks_count INTEGER;
ALTER TABLE workouts ADD COLUMN IF NOT EXISTS start_date DATE;

-- 3. Создаем таблицу progressions (настройки прогрессии для конкретных упражнений)
CREATE TABLE progressions (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    exercise_id BIGINT NOT NULL REFERENCES exercises(id),
    
    -- Опции прогрессии (чекбоксы)
    weight_progression_enabled BOOLEAN NOT NULL DEFAULT false,
    reps_progression_enabled BOOLEAN NOT NULL DEFAULT false,
    sets_progression_enabled BOOLEAN NOT NULL DEFAULT false,
    
    -- Периодичность для каждого параметра
    weight_periodicity VARCHAR(50),
    reps_periodicity VARCHAR(50),
    sets_periodicity VARCHAR(50),
    
    -- Тип инкремента для каждого параметра
    weight_increment_type VARCHAR(50),
    reps_increment_type VARCHAR(50),
    sets_increment_type VARCHAR(50),
    
    -- Значения для инкрементов
    weight_increment_value DECIMAL(5,2),
    reps_increment_value INTEGER,
    sets_increment_value INTEGER,
    
    -- Начальные и конечные значения для циклов
    reps_initial_value INTEGER,
    reps_final_value INTEGER,
    sets_initial_value INTEGER,
    sets_final_value INTEGER,
    
    -- Условия для изменения
    weight_condition_sets INTEGER,
    weight_condition_reps INTEGER,
    sets_condition_reps INTEGER,
    
    -- Статус активности
    is_active BOOLEAN NOT NULL DEFAULT true,
    
    -- Временные метки
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Создаем таблицу workout_schedules (расписания тренировок)
CREATE TABLE workout_schedules (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    workout_id BIGINT NOT NULL REFERENCES workouts(id),
    
    -- Конкретная дата тренировки
    workout_date DATE NOT NULL,
    
    -- Номер недели в расписании
    week_number INTEGER NOT NULL,
    
    -- Статус выполнения тренировки
    status VARCHAR(50) NOT NULL DEFAULT 'PLANNED',
    
    -- Время выполнения тренировки
    start_time TIME,
    end_time TIME,
    
    -- Заметка о выполнении
    notes TEXT,
    
    -- Временные метки
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 5. Создаем таблицу workout_schedule_exercises (упражнения в расписании)
CREATE TABLE workout_schedule_exercises (
    id BIGSERIAL PRIMARY KEY,
    workout_schedule_id BIGINT NOT NULL REFERENCES workout_schedules(id) ON DELETE CASCADE,
    exercise_template_id BIGINT NOT NULL REFERENCES exercise_templates(id),
    
    -- Рассчитанные параметры для этой недели (по прогрессии)
    planned_weight DECIMAL(5,2) NOT NULL,
    planned_reps INTEGER NOT NULL,
    planned_sets INTEGER NOT NULL,
    planned_rest_time INTEGER NOT NULL,
    
    -- Порядок выполнения
    exercise_order INTEGER NOT NULL,
    
    -- Статус выполнения упражнения
    status VARCHAR(50) NOT NULL DEFAULT 'PLANNED',
    
    -- Время выполнения упражнения
    start_time TIME,
    end_time TIME,
    
    -- Фактические выполненные значения
    actual_weight DECIMAL(5,2),
    actual_reps INTEGER,
    actual_sets INTEGER,
    actual_rest_time INTEGER,
    
    -- Комментарии
    notes TEXT,
    
    -- Временные метки
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 6. Создаем таблицу set_executions (сессии выполнения подходов)
CREATE TABLE set_executions (
    id BIGSERIAL PRIMARY KEY,
    workout_schedule_exercise_id BIGINT NOT NULL REFERENCES workout_schedule_exercises(id) ON DELETE CASCADE,
    
    -- Номер подхода
    set_number INTEGER NOT NULL,
    
    -- Фактические выполненные значения
    actual_weight DECIMAL(5,2),
    actual_reps INTEGER,
    
    -- Время выполнения подхода
    start_time TIME NOT NULL,
    end_time TIME,
    
    -- Время отдыха после подхода
    rest_time INTEGER,
    
    -- Заметка о выполнении
    notes TEXT,
    
    -- Временные метки
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 7. Создаем индексы для оптимизации
CREATE INDEX idx_workouts_day_of_week ON workouts(day_of_week);
CREATE INDEX idx_workouts_weeks_count ON workouts(weeks_count);
CREATE INDEX idx_workouts_start_date ON workouts(start_date);

CREATE INDEX idx_progressions_user ON progressions(user_id);
CREATE INDEX idx_progressions_exercise ON progressions(exercise_id);
CREATE INDEX idx_progressions_active ON progressions(is_active);

CREATE INDEX idx_workout_schedules_user ON workout_schedules(user_id);
CREATE INDEX idx_workout_schedules_workout ON workout_schedules(workout_id);
CREATE INDEX idx_workout_schedules_date ON workout_schedules(workout_date);
CREATE INDEX idx_workout_schedules_week ON workout_schedules(week_number);
CREATE INDEX idx_workout_schedules_status ON workout_schedules(status);

CREATE INDEX idx_workout_schedule_exercises_schedule ON workout_schedule_exercises(workout_schedule_id);
CREATE INDEX idx_workout_schedule_exercises_template ON workout_schedule_exercises(exercise_template_id);
CREATE INDEX idx_workout_schedule_exercises_order ON workout_schedule_exercises(exercise_order);
CREATE INDEX idx_workout_schedule_exercises_status ON workout_schedule_exercises(status);

CREATE INDEX idx_set_executions_exercise ON set_executions(workout_schedule_exercise_id);
CREATE INDEX idx_set_executions_number ON set_executions(set_number);

-- 8. Создаем триггеры для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_progressions_updated_at BEFORE UPDATE ON progressions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_schedules_updated_at BEFORE UPDATE ON workout_schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_schedule_exercises_updated_at BEFORE UPDATE ON workout_schedule_exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_set_executions_updated_at BEFORE UPDATE ON set_executions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 9. Добавляем ограничения для валидации данных
ALTER TABLE workouts ADD CONSTRAINT chk_day_of_week 
    CHECK (day_of_week IN ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY'));

ALTER TABLE workouts ADD CONSTRAINT chk_weeks_count 
    CHECK (weeks_count > 0);

ALTER TABLE progressions ADD CONSTRAINT chk_weight_periodicity 
    CHECK (weight_periodicity IN ('FIXED', 'EVERY_WORKOUT', 'CONDITIONAL') OR weight_periodicity IS NULL);

ALTER TABLE progressions ADD CONSTRAINT chk_reps_periodicity 
    CHECK (reps_periodicity IN ('FIXED', 'EVERY_WORKOUT', 'CONDITIONAL') OR reps_periodicity IS NULL);

ALTER TABLE progressions ADD CONSTRAINT chk_sets_periodicity 
    CHECK (sets_periodicity IN ('FIXED', 'EVERY_WORKOUT', 'CONDITIONAL') OR sets_periodicity IS NULL);

ALTER TABLE progressions ADD CONSTRAINT chk_weight_increment_type 
    CHECK (weight_increment_type IN ('FIXED', 'INCREMENT') OR weight_increment_type IS NULL);

ALTER TABLE progressions ADD CONSTRAINT chk_reps_increment_type 
    CHECK (reps_increment_type IN ('FIXED', 'INCREMENT', 'CYCLE') OR reps_increment_type IS NULL);

ALTER TABLE progressions ADD CONSTRAINT chk_sets_increment_type 
    CHECK (sets_increment_type IN ('FIXED', 'INCREMENT', 'CYCLE') OR sets_increment_type IS NULL);

ALTER TABLE workout_schedules ADD CONSTRAINT chk_workout_status 
    CHECK (status IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED'));

ALTER TABLE workout_schedule_exercises ADD CONSTRAINT chk_exercise_status 
    CHECK (status IN ('PLANNED', 'IN_PROGRESS', 'COMPLETED', 'SKIPPED'));

-- 10. Добавляем комментарии к таблицам
COMMENT ON COLUMN workouts.day_of_week IS 'День недели выполнения тренировки';
COMMENT ON COLUMN workouts.weeks_count IS 'Количество недель для прогрессии';
COMMENT ON COLUMN workouts.start_date IS 'Дата начала прогрессии';

COMMENT ON TABLE progressions IS 'Настройки прогрессии для конкретных упражнений в тренировке';
COMMENT ON TABLE workout_schedules IS 'Расписания тренировок на конкретные даты';
COMMENT ON TABLE workout_schedule_exercises IS 'Упражнения в расписании с рассчитанными параметрами и статусом выполнения';
COMMENT ON TABLE set_executions IS 'Сессии выполнения подходов';

COMMENT ON COLUMN progressions.exercise_id IS 'Связь с конкретным упражнением в тренировке';
COMMENT ON COLUMN progressions.weight_progression_enabled IS 'Включена ли прогрессия веса';
COMMENT ON COLUMN progressions.reps_progression_enabled IS 'Включена ли прогрессия повторений';
COMMENT ON COLUMN progressions.sets_progression_enabled IS 'Включена ли прогрессия подходов';

COMMENT ON COLUMN workout_schedules.workout_id IS 'Шаблон тренировки';
COMMENT ON COLUMN workout_schedules.workout_date IS 'Конкретная дата тренировки';
COMMENT ON COLUMN workout_schedules.week_number IS 'Номер недели в расписании';
COMMENT ON COLUMN workout_schedules.status IS 'Статус выполнения тренировки';
COMMENT ON COLUMN workout_schedules.start_time IS 'Время начала тренировки';
COMMENT ON COLUMN workout_schedules.end_time IS 'Время завершения тренировки';

COMMENT ON COLUMN workout_schedule_exercises.planned_weight IS 'Плановый вес для этой недели';
COMMENT ON COLUMN workout_schedule_exercises.planned_reps IS 'Плановые повторения для этой недели';
COMMENT ON COLUMN workout_schedule_exercises.planned_sets IS 'Плановые подходы для этой недели';
COMMENT ON COLUMN workout_schedule_exercises.status IS 'Статус выполнения упражнения';
COMMENT ON COLUMN workout_schedule_exercises.start_time IS 'Время начала упражнения';
COMMENT ON COLUMN workout_schedule_exercises.end_time IS 'Время завершения упражнения';
COMMENT ON COLUMN workout_schedule_exercises.actual_weight IS 'Фактически выполненный вес';
COMMENT ON COLUMN workout_schedule_exercises.actual_reps IS 'Фактически выполненные повторения';
COMMENT ON COLUMN workout_schedule_exercises.actual_sets IS 'Фактически выполненные подходы';

COMMENT ON COLUMN set_executions.set_number IS 'Номер подхода';
COMMENT ON COLUMN set_executions.actual_weight IS 'Фактически выполненный вес в подходе';
COMMENT ON COLUMN set_executions.actual_reps IS 'Фактически выполненные повторения в подходе';
COMMENT ON COLUMN set_executions.start_time IS 'Время начала подхода';
COMMENT ON COLUMN set_executions.end_time IS 'Время завершения подхода';
COMMENT ON COLUMN set_executions.rest_time IS 'Время отдыха после подхода';

-- 8. Создание индексов для оптимизации
CREATE INDEX IF NOT EXISTS idx_progressions_user_exercise ON progressions(user_id, exercise_id);
CREATE INDEX IF NOT EXISTS idx_progressions_active ON progressions(is_active);
CREATE INDEX IF NOT EXISTS idx_workout_schedules_user_workout ON workout_schedules(user_id, workout_id);
CREATE INDEX IF NOT EXISTS idx_workout_schedules_date ON workout_schedules(workout_date);
CREATE INDEX IF NOT EXISTS idx_workout_schedules_status ON workout_schedules(status);
CREATE INDEX IF NOT EXISTS idx_workout_schedule_exercises_schedule ON workout_schedule_exercises(workout_schedule_id);
CREATE INDEX IF NOT EXISTS idx_workout_schedule_exercises_template ON workout_schedule_exercises(exercise_template_id);

-- 9. Создание триггеров для автоматического обновления updated_at
CREATE TRIGGER update_progressions_updated_at BEFORE UPDATE ON progressions
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_schedules_updated_at BEFORE UPDATE ON workout_schedules
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workout_schedule_exercises_updated_at BEFORE UPDATE ON workout_schedule_exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 10. Вставка тестовых данных для прогрессий
INSERT INTO progressions (user_id, exercise_id, weight_progression_enabled, weight_periodicity, weight_increment_type, weight_increment_value, is_active) VALUES
(1, 1, true, 'EVERY_WORKOUT', 'INCREMENT', 2.5, true),
(1, 2, true, 'EVERY_WORKOUT', 'INCREMENT', 1.0, true),
(1, 3, true, 'EVERY_WORKOUT', 'INCREMENT', 0.5, true),
(1, 4, true, 'EVERY_WORKOUT', 'INCREMENT', 5.0, true),
(1, 5, true, 'EVERY_WORKOUT', 'INCREMENT', 1.0, true),
(1, 6, true, 'EVERY_WORKOUT', 'INCREMENT', 2.5, true),
(1, 7, true, 'EVERY_WORKOUT', 'INCREMENT', 5.0, true),
(1, 8, true, 'EVERY_WORKOUT', 'INCREMENT', 2.5, true),
(1, 9, true, 'EVERY_WORKOUT', 'INCREMENT', 1.0, true)
ON CONFLICT DO NOTHING;

-- 11. Вставка тестовых расписаний тренировок
INSERT INTO workout_schedules (user_id, workout_id, workout_date, week_number, status) VALUES
(1, 1, '2025-08-26', 1, 'PLANNED'),
(1, 1, '2025-09-02', 2, 'PLANNED'),
(1, 1, '2025-09-09', 3, 'PLANNED'),
(1, 1, '2025-09-16', 4, 'PLANNED'),
(1, 2, '2025-08-28', 1, 'PLANNED'),
(1, 2, '2025-09-04', 2, 'PLANNED'),
(1, 2, '2025-09-11', 3, 'PLANNED'),
(1, 2, '2025-09-18', 4, 'PLANNED'),
(1, 3, '2025-08-30', 1, 'PLANNED'),
(1, 3, '2025-09-06', 2, 'PLANNED'),
(1, 3, '2025-09-13', 3, 'PLANNED'),
(1, 3, '2025-09-20', 4, 'PLANNED')
ON CONFLICT DO NOTHING;

-- 12. Вставка тестовых упражнений в расписании
INSERT INTO workout_schedule_exercises (workout_schedule_id, exercise_template_id, planned_weight, planned_reps, planned_sets, planned_rest_time, exercise_order, status) VALUES
-- Неделя 1, тренировка 1 (грудь и трицепс)
(1, 1, 50.0, 10, 3, 60, 1, 'PLANNED'),
(1, 2, 30.0, 12, 3, 45, 2, 'PLANNED'),
(1, 3, 40.0, 8, 4, 90, 3, 'PLANNED'),

-- Неделя 2, тренировка 1 (с прогрессией)
(2, 1, 52.5, 10, 3, 60, 1, 'PLANNED'),
(2, 2, 31.0, 12, 3, 45, 2, 'PLANNED'),
(2, 3, 40.5, 8, 4, 90, 3, 'PLANNED'),

-- Неделя 1, тренировка 2 (спина и бицепс)
(5, 4, 60.0, 8, 3, 75, 1, 'PLANNED'),
(5, 5, 25.0, 15, 3, 60, 2, 'PLANNED'),
(5, 6, 35.0, 10, 3, 60, 3, 'PLANNED'),

-- Неделя 1, тренировка 3 (ноги и плечи)
(9, 7, 80.0, 6, 4, 120, 1, 'PLANNED'),
(9, 8, 45.0, 10, 3, 90, 2, 'PLANNED'),
(9, 9, 20.0, 20, 3, 45, 3, 'PLANNED')
ON CONFLICT DO NOTHING;
