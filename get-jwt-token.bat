@echo off
echo Получение JWT токена из Keycloak для тестирования API...
echo.
echo 1. Убедитесь что Keycloak запущен:
echo    docker-compose ps keycloak
echo.
echo 2. Откройте Keycloak Admin Console:
echo    http://localhost:8081
echo    Логин: admin
echo    Пароль: admin
echo.
echo 3. Перейдите в realm "workout-realm"
echo.
echo 4. Создайте тестового пользователя:
echo    - Users -> Add user
echo    - Username: testuser
echo    - Email: test@example.com
echo    - First Name: Test
echo    - Last Name: User
echo    - Email Verified: ON
echo    - Save
echo.
echo 5. Установите пароль для пользователя:
echo    - Credentials tab
echo    - New Password: test123
echo    - Password Confirmation: test123
echo    - Temporary: OFF
echo    - Save
echo.
echo 6. Получите JWT токен через curl:
echo    curl -X POST http://localhost:8081/realms/workout-realm/protocol/openid-connect/token \
echo         -H "Content-Type: application/x-www-form-urlencoded" \
echo         -d "grant_type=password" \
echo         -d "client_id=workout-client" \
echo         -d "username=testuser" \
echo         -d "password=password"
echo.
echo 7. Скопируйте access_token из ответа
echo.
echo 8. Используйте токен в заголовке Authorization:
echo    curl -H "Authorization: Bearer YOUR_TOKEN_HERE" \
echo         http://localhost:8080/api/workouts
echo.
echo Примечание: В dev режиме API будет работать и без токена (permitAll),
echo но с токеном вы можете тестировать полную функциональность аутентификации.
echo.
pause
