# Отчет о проверке флагов isActive в API

## Обзор
Проверены все сущности на наличие флага `isActive` и его корректную передачу в API.

## Результаты проверки

### ✅ Исправлено
1. **Equipment** - добавлено поле `isActive` в `EquipmentDto` и обновлен сервис
2. **MuscleGroup** - добавлено поле `isActive` в `MuscleGroupDto` и обновлен сервис

### ✅ Уже правильно
1. **ExerciseTemplate** - поле `isActive` уже присутствует в DTO и сервисе
2. **Progression** - поле `isActive` уже присутствует в DTO и сервисе

### ❌ Не имеют флага isActive
1. **User** - нет флага активности
2. **Workout** - нет флага активности  
3. **Exercise** - нет флага активности
4. **WorkoutSchedule** - нет флага активности
5. **ExerciseMedia** - нет флага активности
6. **SetExecution** - нет флага активности
7. **WorkoutScheduleExercise** - нет флага активности

## Внесенные изменения

### EquipmentDto.java
- Добавлено поле `private Boolean isActive;`

### EquipmentService.java  
- В методе `convertToDto()` добавлено: `dto.setIsActive(equipment.getIsActive());`
- В методе `convertToEntity()` добавлено: `if (dto.getIsActive() != null) { equipment.setIsActive(dto.getIsActive()); }`

### MuscleGroupDto.java
- Добавлено поле `private Boolean isActive;`

### MuscleGroupService.java
- В методе `convertToDto()` добавлено: `dto.setIsActive(muscleGroup.getIsActive());`
- В методе `convertToEntity()` добавлено: `if (dto.getIsActive() != null) { muscleGroup.setIsActive(dto.getIsActive()); }`

## Рекомендации

1. **Пересобрать приложение** после внесения изменений
2. **Протестировать API** с помощью скрипта `test-isactive-flags.bat`
3. **Проверить фронтенд** на корректное отображение флагов активности
4. **Рассмотреть добавление** флагов активности для других сущностей, если это необходимо для бизнес-логики

## Тестирование
Для проверки используйте скрипт:
```bash
.\test-isactive-flags.bat
```

Этот скрипт проверит все API endpoints, которые должны возвращать флаг `isActive`.
