@echo off
echo Checking database schema...
echo.

echo Connecting to PostgreSQL database...
echo.

echo 1. Checking progressions table structure:
psql -h localhost -U postgres -d workout_db -c "\d progressions"

echo.
echo 2. Checking if user_id column exists:
psql -h localhost -U postgres -d workout_db -c "SELECT column_name, data_type, is_nullable FROM information_schema.columns WHERE table_name = 'progressions' AND column_name = 'user_id';"

echo.
echo 3. Checking sample data from progressions:
psql -h localhost -U postgres -d workout_db -c "SELECT id, user_id, exercise_id, is_active FROM progressions LIMIT 5;"

echo.
echo ========================================
echo Schema check completed!
echo ========================================
pause
