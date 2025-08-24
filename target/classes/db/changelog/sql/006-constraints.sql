-- --liquibase formatted sql

-- Добавление ограничений для прогрессии

-- Ограничения для прогрессии веса типа CYCLE
ALTER TABLE progressions ADD CONSTRAINT chk_weight_cycle_values 
CHECK (
    (weight_increment_type != 'CYCLE') OR 
    (weight_increment_type = 'CYCLE' AND weight_initial_value IS NOT NULL AND weight_final_value IS NOT NULL)
);

ALTER TABLE progressions ADD CONSTRAINT chk_weight_cycle_range 
CHECK (
    (weight_increment_type != 'CYCLE') OR 
    (weight_increment_type = 'CYCLE' AND weight_final_value > weight_initial_value)
);
