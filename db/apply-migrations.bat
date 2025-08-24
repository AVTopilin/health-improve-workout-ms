@echo off
echo Applying Database Migrations
echo ============================
echo.

echo 1. Applying base migration (users, workouts, exercises)...
psql -h localhost -U postgres -d workout_db -f migration-v1-base.sql
if %errorlevel% neq 0 (
    echo Error applying base migration
    pause
    exit /b 1
)

echo.
echo 2. Applying migration v2 (exercise templates)...
psql -h localhost -U postgres -d workout_db -f migration-v2.sql
if %errorlevel% neq 0 (
    echo Error applying migration v2
    pause
    exit /b 1
)

echo.
echo 3. Applying migration v3 (progressions and schedules)...
psql -h localhost -U postgres -d workout_db -f migration-v3-progression.sql
if %errorlevel% neq 0 (
    echo Error applying migration v3
    pause
    exit /b 1
)

echo.
echo 4. Applying migration v4 (weight cycle fields)...
psql -h localhost -U postgres -d workout_db -f migration-v4-weight-cycle-fields.sql
if %errorlevel% neq 0 (
    echo Error applying migration v4
    pause
    exit /b 1
)

echo.
echo All migrations applied successfully!
echo.
echo 5. Checking created tables...
psql -h localhost -U postgres -d workout_db -c "\dt"

echo.
echo Migrations completed!
pause
