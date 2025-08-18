@echo off
echo Перезапуск приложения после изменений конфигурации...
echo.
echo 1. Остановите приложение в IntelliJ IDEA (Ctrl+F2)
echo 2. Подождите полной остановки
echo 3. Запустите приложение заново (Shift+F10)
echo.
echo Или используйте:
echo - Run -> Stop (Ctrl+F2)
echo - Run -> Run (Shift+F10)
echo.
echo После перезапуска проверьте:
echo - http://localhost:8080/ (должен вернуть JSON)
echo - http://localhost:8080/test (должен вернуть JSON)
echo - http://localhost:8080/health (должен вернуть JSON)
echo - http://localhost:8080/swagger-ui/index.html (должен открыться Swagger UI)
echo.
pause
