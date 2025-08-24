-- Миграция v1: Базовые таблицы приложения
-- Выполнять первой, до других миграций

-- 1. Создание таблицы пользователей
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    keycloak_id VARCHAR(255) UNIQUE,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Создание таблицы тренировок
CREATE TABLE IF NOT EXISTS workouts (
    id BIGSERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL REFERENCES users(id),
    name VARCHAR(255) NOT NULL,
    description TEXT,
    day_of_week VARCHAR(50),
    weeks_count INTEGER,
    start_date DATE,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 3. Создание таблицы упражнений
CREATE TABLE IF NOT EXISTS exercises (
    id BIGSERIAL PRIMARY KEY,
    workout_id BIGINT NOT NULL REFERENCES workouts(id) ON DELETE CASCADE,
    exercise_template_id BIGINT,
    weight DECIMAL(5,2),
    reps INTEGER,
    sets INTEGER,
    rest_time INTEGER,
    exercise_order INTEGER NOT NULL,
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 4. Создание индексов для оптимизации
CREATE INDEX IF NOT EXISTS idx_users_keycloak_id ON users(keycloak_id);
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_workouts_active ON workouts(is_active);
CREATE INDEX IF NOT EXISTS idx_exercises_workout_id ON exercises(workout_id);
CREATE INDEX IF NOT EXISTS idx_exercises_template_id ON exercises(exercise_template_id);
CREATE INDEX IF NOT EXISTS idx_exercises_active ON exercises(is_active);

-- 5. Создание триггеров для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_workouts_updated_at BEFORE UPDATE ON workouts
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercises_updated_at BEFORE UPDATE ON exercises
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 6. Вставка тестового пользователя
INSERT INTO users (username, email, keycloak_id) VALUES 
('testuser', 'test@example.com', '91e1657f-b1e1-4542-b1be-49e1f3addf81')
ON CONFLICT (username) DO NOTHING;

-- 7. Вставка тестовых тренировок
INSERT INTO workouts (user_id, name, description, day_of_week, weeks_count, start_date) VALUES 
(1, 'Тренировка груди и трицепса', 'Базовая тренировка для развития грудных мышц и трицепса', 'MONDAY', 4, '2025-08-23'),
(1, 'Тренировка спины и бицепса', 'Тренировка для развития мышц спины и бицепса', 'WEDNESDAY', 4, '2025-08-23'),
(1, 'Тренировка ног и плеч', 'Комплексная тренировка для развития мышц ног и плеч', 'FRIDAY', 4, '2025-08-23')
ON CONFLICT DO NOTHING;

-- 8. Вставка тестовых упражнений
INSERT INTO exercises (workout_id, exercise_template_id, weight, reps, sets, rest_time, exercise_order) VALUES 
(1, 1, 50.0, 10, 3, 60, 1),
(1, 2, 30.0, 12, 3, 45, 2),
(1, 3, 40.0, 8, 4, 90, 3),
(2, 4, 60.0, 8, 3, 75, 1),
(2, 5, 25.0, 15, 3, 60, 2),
(2, 6, 35.0, 10, 3, 60, 3),
(3, 7, 80.0, 6, 4, 120, 1),
(3, 8, 45.0, 10, 3, 90, 2),
(3, 9, 20.0, 20, 3, 45, 3)
ON CONFLICT DO NOTHING;
