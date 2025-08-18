@echo off
echo Перезапуск приложения с новой конфигурацией аутентификации...
echo.
echo Что изменилось:
echo 1. Dev профиль теперь использует такую же конфигурацию oauth2 как prod
echo 2. SecurityConfig настроен для работы с JWT токенами в dev режиме
echo 3. API endpoints доступны без токена (permitAll), но поддерживают JWT
echo.
echo 1. Остановите приложение в IntelliJ IDEA (Ctrl+F2)
echo 2. Подождите полной остановки
echo 3. Запустите приложение заново (Shift+F10)
echo.
echo После перезапуска проверьте:
echo - http://localhost:8080/ (должен вернуть JSON)
echo - http://localhost:8080/test (должен вернуть JSON)
echo - http://localhost:8080/health (должен вернуть JSON)
echo - http://localhost:8080/swagger-ui/index.html (должен открыться Swagger UI)
echo - http://localhost:8080/api/workouts (должен работать без токена)
echo.
echo Для тестирования с JWT токеном:
echo 1. Запустите get-jwt-token.bat
echo 2. Получите токен из Keycloak
echo 3. Используйте test-api.html для тестирования
echo.
pause
