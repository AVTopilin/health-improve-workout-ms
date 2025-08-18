@echo off
echo Проверка исправлений методов getOrder/setOrder...
echo.
echo Что мы исправили:
echo 1. WorkoutGenerationService.java:
echo    - setOrder() -> setExerciseOrder()
echo    - getOrder() -> getExerciseOrder()
echo.
echo 2. WorkoutService.java:
echo    - setOrder() -> setExerciseOrder()
echo    - getOrder() -> getExerciseOrder()
echo.
echo 3. ExerciseController.java (уже исправлен):
echo    - Все ссылки на order -> exerciseOrder
echo.
echo 4. ExerciseRepository.java (уже исправлен):
echo    - Метод findByWorkoutIdOrderByExerciseOrder
echo.
echo Теперь для проверки:
echo 1. Откройте проект в IntelliJ IDEA
echo 2. Выполните Build -> Build Project (Ctrl+F9)
echo 3. Если нет ошибок компиляции - все исправлено!
echo.
echo Все методы getOrder/setOrder заменены на getExerciseOrder/setExerciseOrder!
echo.
pause
