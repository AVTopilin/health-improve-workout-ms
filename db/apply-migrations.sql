-- Скрипт для применения всех миграций в правильном порядке
-- Выполнять в PostgreSQL

-- 1. Применяем базовую миграцию (создание users, workouts, exercises)
\i migration-v1-base.sql

-- 2. Применяем миграцию v2 (справочники и шаблоны упражнений)
\i migration-v2.sql

-- 3. Применяем миграцию v3 (прогрессии и расписания)
\i migration-v3-progression.sql

-- 4. Применяем миграцию v4 (поля для типа Цикл)
\i migration-v4-weight-cycle-fields.sql

-- 5. Проверяем созданные таблицы
\dt

-- 5. Проверяем структуру основных таблиц
\d users
\d workouts
\d exercises
\d exercise_templates
\d workout_schedules
\d workout_schedule_exercises
