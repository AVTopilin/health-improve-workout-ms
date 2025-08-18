@echo off
echo Проверка подключения к базе данных...
echo.
echo 1. Проверяем статус PostgreSQL контейнера...
docker-compose ps postgres
echo.
echo 2. Проверяем логи PostgreSQL...
docker-compose logs --tail=10 postgres
echo.
echo 3. Проверяем доступность порта 5432...
netstat -an | findstr :5432
echo.
echo 4. Проверяем подключение к базе...
docker-compose exec postgres psql -U postgres -d workout_db -c "SELECT version();"
if %errorlevel% equ 0 (
    echo ✅ Подключение к базе данных успешно!
) else (
    echo ❌ Ошибка подключения к базе данных
)
echo.
echo 5. Проверяем существующие таблицы...
docker-compose exec postgres psql -U postgres -d workout_db -c "\dt"
echo.
echo 6. Информация о базе данных:
echo - Хост: localhost
echo - Порт: 5432
echo - База: workout_db
echo - Пользователь: postgres
echo - Пароль: password
echo.
echo 7. Переменные окружения для dev профиля:
echo - DB_URL: jdbc:postgresql://localhost:5432/workout_db
echo - DB_USERNAME: postgres
echo - DB_PASSWORD: password
echo.
pause
