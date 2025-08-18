@echo off
echo Запуск инфраструктуры для dev режима...
echo.
echo 1. Проверяем статус Docker...
docker --version
if %errorlevel% neq 0 (
    echo ОШИБКА: Docker не установлен или не запущен!
    echo Установите Docker Desktop и запустите его
    pause
    exit /b 1
)
echo.
echo 2. Запускаем PostgreSQL и Keycloak...
docker-compose up -d postgres keycloak
echo.
echo 3. Ждем запуска сервисов...
timeout /t 10 /nobreak >nul
echo.
echo 4. Проверяем статус сервисов...
docker-compose ps
echo.
echo 5. Проверяем подключение к PostgreSQL...
docker-compose exec postgres pg_isready -U postgres
if %errorlevel% equ 0 (
    echo ✅ PostgreSQL готов к работе
) else (
    echo ❌ PostgreSQL не готов
)
echo.
echo 6. Проверяем подключение к Keycloak...
curl -s http://localhost:8081/health >nul
if %errorlevel% equ 0 (
    echo ✅ Keycloak доступен
) else (
    echo ❌ Keycloak недоступен
)
echo.
echo Инфраструктура запущена! Теперь можно запускать приложение в dev режиме.
echo.
echo Для запуска приложения используйте:
echo - start-dev-intellij.bat (через IntelliJ IDEA)
echo - start-dev-maven.bat (через Maven)
echo.
pause
