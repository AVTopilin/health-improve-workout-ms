-- --liquibase formatted sql

-- Создание триггеров для updated_at

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
