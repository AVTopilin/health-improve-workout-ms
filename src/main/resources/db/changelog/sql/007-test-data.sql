-- --liquibase formatted sql

-- Вставка тестовых данных

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
