@echo off
echo Диагностика и исправление проблем с Keycloak...
echo.
echo 1. Проверяем статус контейнеров...
docker-compose ps
echo.
echo 2. Останавливаем все контейнеры...
docker-compose down
echo.
echo 3. Удаляем volumes для полной очистки...
docker-compose down -v
echo.
echo 4. Проверяем docker-compose.yml...
echo.
echo 5. Запускаем только PostgreSQL сначала...
docker-compose up -d postgres
echo.
echo 6. Ждем запуска PostgreSQL...
timeout /t 15 /nobreak >nul
echo.
echo 7. Проверяем PostgreSQL...
docker-compose exec postgres pg_isready -U postgres
if %errorlevel% equ 0 (
    echo ✅ PostgreSQL готов
) else (
    echo ❌ PostgreSQL не готов
    pause
    exit /b 1
)
echo.
echo 8. Запускаем Keycloak...
docker-compose up -d keycloak
echo.
echo 9. Ждем запуска Keycloak...
timeout /t 30 /nobreak >nul
echo.
echo 10. Проверяем статус Keycloak...
docker-compose ps keycloak
echo.
echo 11. Проверяем логи Keycloak...
docker-compose logs --tail=20 keycloak
echo.
echo 12. Проверяем доступность Keycloak...
curl -s http://localhost:8081/health >nul
if %errorlevel% equ 0 (
    echo ✅ Keycloak доступен по адресу http://localhost:8081
) else (
    echo ❌ Keycloak недоступен
    echo.
    echo Возможные причины:
    echo - Недостаточно памяти для Keycloak
    echo - Порт 8081 занят другим процессом
    echo - Проблемы с Docker
    echo.
    echo Попробуйте:
    echo 1. Перезапустить Docker Desktop
    echo 2. Увеличить память для Docker (минимум 4GB)
    echo 3. Проверить что порт 8081 свободен
)
echo.
echo 13. Финальная проверка всех сервисов...
docker-compose ps
echo.
echo Если Keycloak все еще не работает, попробуйте:
echo 1. Перезапустить Docker Desktop
echo 2. Увеличить память для Docker до 6-8GB
echo 3. Проверить логи: docker-compose logs keycloak
echo.
pause
