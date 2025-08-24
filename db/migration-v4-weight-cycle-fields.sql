-- Миграция v4: Добавление полей для типа инкремента "Цикл" в прогрессии
-- Выполнять после migration-v3-progression.sql

-- 1. Добавляем новые колонки для веса в цикле
ALTER TABLE progressions ADD COLUMN IF NOT EXISTS weight_initial_value DECIMAL(5,2);
ALTER TABLE progressions ADD COLUMN IF NOT EXISTS weight_final_value DECIMAL(5,2);

-- 2. Обновляем комментарии для новых колонок
COMMENT ON COLUMN progressions.weight_initial_value IS 'Начальное значение веса для типа инкремента Цикл';
COMMENT ON COLUMN progressions.weight_final_value IS 'Конечное значение веса для типа инкремента Цикл';

-- 3. Добавляем проверки для валидации значений
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

-- 4. Обновляем существующие записи (если нужно)
-- Устанавливаем значения по умолчанию для существующих прогрессий с типом CYCLE
UPDATE progressions 
SET weight_initial_value = 0.0, weight_final_value = 100.0 
WHERE weight_increment_type = 'CYCLE' AND weight_initial_value IS NULL;

-- 5. Проверяем результат
SELECT 
    id, 
    weight_increment_type, 
    weight_initial_value, 
    weight_final_value,
    weight_increment_value
FROM progressions 
WHERE weight_increment_type = 'CYCLE';
