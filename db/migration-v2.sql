-- Миграция v2: Добавление системы справочников упражнений
-- Выполнять после создания новых сущностей

-- 1. Создание таблиц для справочников
CREATE TABLE IF NOT EXISTS muscle_groups (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    color_code VARCHAR(7), -- HEX цвет
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS equipment (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    equipment_type VARCHAR(50) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS exercise_templates (
    id BIGSERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    description TEXT,
    instructions TEXT,
    tips TEXT,
    difficulty_level VARCHAR(50) NOT NULL,
    muscle_group_id BIGINT NOT NULL REFERENCES muscle_groups(id),
    equipment_id BIGINT NOT NULL REFERENCES equipment(id),
    is_active BOOLEAN NOT NULL DEFAULT true,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS exercise_media (
    id BIGSERIAL PRIMARY KEY,
    exercise_template_id BIGINT NOT NULL REFERENCES exercise_templates(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    original_file_name VARCHAR(255) NOT NULL,
    content_type VARCHAR(100) NOT NULL,
    file_size BIGINT NOT NULL,
    minio_path VARCHAR(500) NOT NULL,
    media_type VARCHAR(50) NOT NULL,
    display_order INTEGER,
    is_primary BOOLEAN NOT NULL DEFAULT false,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- 2. Обновление существующей таблицы exercises
-- Добавляем новую колонку для связи с шаблоном
ALTER TABLE exercises ADD COLUMN IF NOT EXISTS exercise_template_id BIGINT;

-- 3. Вставка базовых данных для групп мышц
INSERT INTO muscle_groups (name, description, color_code) VALUES
('Грудь', 'Мышцы грудной клетки', '#FF6B6B'),
('Спина', 'Мышцы спины', '#4ECDC4'),
('Плечи', 'Дельтовидные мышцы', '#45B7D1'),
('Бицепс', 'Двуглавая мышца плеча', '#96CEB4'),
('Трицепс', 'Трехглавая мышца плеча', '#FFEAA7'),
('Пресс', 'Мышцы живота', '#DDA0DD'),
('Квадрицепс', 'Четырехглавая мышца бедра', '#98D8C8'),
('Ягодицы', 'Большая ягодичная мышца', '#F7DC6F'),
('Икры', 'Икроножные мышцы', '#BB8FCE'),
('Предплечья', 'Мышцы предплечья', '#85C1E9')
ON CONFLICT (name) DO NOTHING;

-- 4. Вставка базовых данных для оборудования
INSERT INTO equipment (name, description, equipment_type) VALUES
('Собственный вес', 'Упражнения с собственным весом', 'BODYWEIGHT'),
('Гантели', 'Свободные веса - гантели', 'DUMBBELLS'),
('Штанга', 'Свободные веса - штанга', 'BARBELL'),
('Гиря', 'Свободные веса - гиря', 'KETTLEBELL'),
('Резиновая лента', 'Эластичная лента для сопротивления', 'RESISTANCE_BAND'),
('Тренажер', 'Блочный или рычажный тренажер', 'MACHINE'),
('Блочный тренажер', 'Тренажер с тросом и блоками', 'CABLE'),
('Фитбол', 'Упражнения на фитболе', 'STABILITY_BALL'),
('Медицинский мяч', 'Тяжелый мяч для упражнений', 'MEDICINE_BALL')
ON CONFLICT (name) DO NOTHING;

-- 5. Создание индексов для оптимизации
CREATE INDEX IF NOT EXISTS idx_exercise_templates_muscle_group ON exercise_templates(muscle_group_id);
CREATE INDEX IF NOT EXISTS idx_exercise_templates_equipment ON exercise_templates(equipment_id);
CREATE INDEX IF NOT EXISTS idx_exercise_templates_active ON exercise_templates(is_active);
CREATE INDEX IF NOT EXISTS idx_exercise_media_template ON exercise_media(exercise_template_id);
CREATE INDEX IF NOT EXISTS idx_exercises_template ON exercises(exercise_template_id);

-- 6. Создание триггеров для автоматического обновления updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_muscle_groups_updated_at BEFORE UPDATE ON muscle_groups
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_equipment_updated_at BEFORE UPDATE ON equipment
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercise_templates_updated_at BEFORE UPDATE ON exercise_templates
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_exercise_media_updated_at BEFORE UPDATE ON exercise_media
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- 8. Вставка тестовых шаблонов упражнений (по 3 для каждой группы мышц)
INSERT INTO exercise_templates (name, description, instructions, tips, difficulty_level, muscle_group_id, equipment_id) VALUES
-- Грудь (3 упражнения)
('Жим лежа', 'Базовое упражнение для развития грудных мышц', 'Лягте на скамью, опустите штангу к груди, затем выжмите вверх', 'Держите лопатки сведенными, не отрывайте таз от скамьи', 'INTERMEDIATE', 1, 3),
('Разведение гантелей лежа', 'Изолирующее упражнение для грудных мышц', 'Лягте на скамью, разведите гантели в стороны, затем сведите их', 'Контролируйте движение, не бросайте гантели', 'BEGINNER', 1, 2),
('Отжимания от пола', 'Упражнение с собственным весом для груди', 'Примите упор лежа, опуститесь к полу, затем отожмитесь', 'Держите тело прямым, не прогибайтесь в пояснице', 'BEGINNER', 1, 1),

-- Спина (3 упражнения)
('Тяга верхнего блока', 'Упражнение для развития широчайших мышц спины', 'Сядьте, возьмите рукоятку, тяните к груди', 'Сводите лопатки, не раскачивайтесь', 'BEGINNER', 2, 7),
('Становая тяга', 'Базовое упражнение для всей спины', 'Возьмите штангу, поднимите, держа спину прямой', 'Техника важнее веса, не округляйте спину', 'ADVANCED', 2, 3),
('Тяга гантели в наклоне', 'Упражнение для средней части спины', 'Наклонитесь, тяните гантель к поясу', 'Держите спину прямой, не скручивайте корпус', 'INTERMEDIATE', 2, 2),

-- Плечи (3 упражнения)
('Жим гантелей стоя', 'Базовое упражнение для дельтовидных мышц', 'Поднимите гантели к плечам, выжмите вверх', 'Держите корпус напряженным, не прогибайтесь', 'INTERMEDIATE', 3, 2),
('Разведение гантелей в стороны', 'Изолирующее упражнение для средних дельт', 'Поднимите гантели в стороны до уровня плеч', 'Не поднимайте выше плеч, контролируйте движение', 'BEGINNER', 3, 2),
('Махи гантелями вперед', 'Упражнение для передних дельт', 'Поднимите гантели перед собой до уровня плеч', 'Не раскачивайтесь, работайте только плечами', 'BEGINNER', 3, 2)
ON CONFLICT (name) DO NOTHING;
