@echo off
echo Проверка исправлений DDL ошибок...
echo.
echo Что мы исправили:
echo 1. Переименовали поле 'order' в 'exerciseOrder' в Exercise сущности
echo    - Избежали конфликта с Java ключевым словом 'order'
echo    - Обновили @Column(name = "exercise_order")
echo.
echo 2. Обновили ExerciseDto:
echo    - Поле order -> exerciseOrder
echo.
echo 3. Обновили ExerciseController:
echo    - Все ссылки на order -> exerciseOrder
echo    - Метод findByWorkoutIdOrderByExerciseOrder
echo.
echo 4. Обновили ExerciseRepository:
echo    - Метод findByWorkoutIdOrderByExerciseOrder
echo.
echo 5. Добавили cascade = CascadeType.ALL в Progression:
echo    - Улучшили управление зависимостями
echo.
echo Теперь для проверки:
echo 1. Откройте проект в IntelliJ IDEA
echo 2. Выполните Build -> Build Project (Ctrl+F9)
echo 3. Запустите приложение с профилем local
echo.
echo DDL ошибки должны быть исправлены!
echo.
pause
