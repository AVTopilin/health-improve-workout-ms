# Liquibase Integration - SQL Format

## Обзор

Проект использует **Liquibase** для управления миграциями базы данных в **SQL формате** вместо XML. Это обеспечивает:

- ✅ **Простоту** - чистый SQL без XML парсинга
- ✅ **Надежность** - нет проблем с экранированием специальных символов
- ✅ **Читаемость** - стандартный SQL синтаксис
- ✅ **Отладку** - легко тестировать SQL отдельно

## Структура файлов

```
src/main/resources/db/changelog/
├── db-changelog-master.xml          # Главный changelog (включает SQL файл)
└── sql/
    ├── 001-complete-schema.sql      # Полная схема БД
    └── update_updated_at_column.sql # Функция для триггеров
```

## Основные файлы

### 1. `db-changelog-master.xml`
Главный файл changelog, который включает SQL миграцию:
```xml
<?xml version="1.0" encoding="UTF-8"?>
<databaseChangeLog>
    <include file="db/changelog/sql/001-complete-schema.sql" relativeToChangelogFile="false"/>
</databaseChangeLog>
```

### 2. `001-complete-schema.sql`
Полная SQL миграция, включающая:
- Создание всех таблиц
- Создание индексов
- Создание триггеров
- Вставку тестовых данных
- Ограничения и проверки

## Команды управления

### Проверка статуса
```bash
manage-migrations.bat status
```

### Применение миграций
```bash
manage-migrations.bat update
```

### Полный сброс и пересоздание
```bash
manage-migrations.bat reset
```

### Валидация changelog
```bash
manage-migrations.bat validate
```

### Синхронизация с существующей схемой
```bash
manage-migrations.bat changelogSync
```

## Преимущества SQL формата

### 1. **Простота синтаксиса**
```sql
-- Вместо сложного XML
CREATE TABLE users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE
);
```

### 2. **Легкость отладки**
- Можно выполнить SQL напрямую в psql
- Простое тестирование отдельных команд
- Четкие сообщения об ошибках

### 3. **Отсутствие проблем с парсингом**
- Нет проблем с `$$` в PostgreSQL функциях
- Нет необходимости в CDATA секциях
- Простое экранирование кавычек

### 4. **Стандартность**
- Любой DBA поймет SQL
- Совместимость с инструментами
- Простота поддержки

## Миграция схемы

### Таблицы
- `users` - пользователи
- `workouts` - тренировки
- `exercises` - упражнения
- `muscle_groups` - группы мышц
- `equipment` - оборудование
- `exercise_templates` - шаблоны упражнений
- `progressions` - прогрессия нагрузок
- `workout_schedules` - расписание тренировок
- `workout_schedule_exercises` - упражнения в расписании

### Триггеры
Автоматическое обновление поля `updated_at` при изменении записей.

### Индексы
Оптимизированные индексы для всех основных запросов.

### Тестовые данные
Готовые тестовые записи для разработки и тестирования.

## Конфигурация

### `application.yml`
```yaml
spring:
  liquibase:
    enabled: true
    change-log: classpath:db/changelog/db-changelog-master.xml
    default-schema: public
```

### `pom.xml`
```xml
<dependency>
    <groupId>org.liquibase</groupId>
    <artifactId>liquibase-core</artifactId>
</dependency>
```

## Решение проблем

### 1. **Таблицы уже существуют**
```bash
manage-migrations.bat changelogSync
```

### 2. **Полный сброс**
```bash
manage-migrations.bat reset
```

### 3. **Проверка статуса**
```bash
manage-migrations.bat status
```

## Рекомендации

1. **Всегда проверяйте статус** перед применением миграций
2. **Используйте `reset`** только в development окружении
3. **Тестируйте SQL** отдельно перед добавлением в changelog
4. **Документируйте изменения** в комментариях SQL

## Примеры SQL команд

### Создание таблицы
```sql
CREATE TABLE IF NOT EXISTS users (
    id BIGSERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL UNIQUE,
    email VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP NOT NULL
);
```

### Создание индекса
```sql
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
```

### Создание триггера
```sql
CREATE TRIGGER update_users_updated_at 
    BEFORE UPDATE ON users
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();
```

### Вставка данных
```sql
INSERT INTO users (username, email) VALUES
('testuser', 'test@example.com')
ON CONFLICT (username) DO NOTHING;
```
