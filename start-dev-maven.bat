@echo off
echo Запуск приложения в dev режиме через Maven...
echo.
echo Убедитесь что:
echo 1. PostgreSQL запущен (docker-compose up -d postgres)
echo 2. Keycloak запущен (docker-compose up -d keycloak)
echo 3. База данных доступна
echo.
echo Запуск приложения...
mvn spring-boot:run -Dspring-boot.run.profiles=dev
echo.
pause
