@echo off
echo Исправление контроллеров для поддержки dev и prod профилей...
echo.

echo 1. Исправляем ExerciseController...
powershell -Command "(Get-Content 'src\main\java\com\workout\controller\ExerciseController.java') -replace '@AuthenticationPrincipal Jwt', '@AuthenticationPrincipal(required = false) Jwt' | Set-Content 'src\main\java\com\workout\controller\ExerciseController.java'"

echo 2. Исправляем ScheduleController...
powershell -Command "(Get-Content 'src\main\java\com\workout\controller\ScheduleController.java') -replace '@AuthenticationPrincipal Jwt', '@AuthenticationPrincipal(required = false) Jwt' | Set-Content 'src\main\java\com\workout\controller\ScheduleController.java'"

echo 3. Исправляем ProgressionController...
powershell -Command "(Get-Content 'src\main\java\com\workout\controller\ProgressionController.java') -replace '@AuthenticationPrincipal Jwt', '@AuthenticationPrincipal(required = false) Jwt' | Set-Content 'src\main\java\com\workout\controller\ProgressionController.java'"

echo 4. Исправляем WorkoutGenerationController...
powershell -Command "(Get-Content 'src\main\java\com\workout\controller\WorkoutGenerationController.java') -replace '@AuthenticationPrincipal Jwt', '@AuthenticationPrincipal(required = false) Jwt' | Set-Content 'src\main\java\com\workout\controller\WorkoutGenerationController.java'"

echo 5. Исправляем WorkoutSessionController...
powershell -Command "(Get-Content 'src\main\java\com\workout\controller\WorkoutSessionController.java') -replace '@AuthenticationPrincipal Jwt', '@AuthenticationPrincipal(required = false) Jwt' | Set-Content 'src\main\java\com\workout\controller\WorkoutSessionController.java'"

echo 6. Исправляем ExerciseSetController...
powershell -Command "(Get-Content 'src\main\java\com\workout\controller\ExerciseSetController.java') -replace '@AuthenticationPrincipal Jwt', '@AuthenticationPrincipal(required = false) Jwt' | Set-Content 'src\main\java\com\workout\controller\ExerciseSetController.java'"

echo.
echo Все контроллеры исправлены!
echo Теперь они будут работать как в dev, так и в prod профилях.
echo.
pause
