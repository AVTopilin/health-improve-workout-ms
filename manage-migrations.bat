@echo off
echo ========================================
echo УПРАВЛЕНИЕ МИГРАЦИЯМИ LIQUIBASE
echo ========================================

if "%1"=="status" (
    echo Проверка статуса миграций...
    mvn liquibase:status -Dliquibase.url="jdbc:postgresql://localhost:5432/workout_db" -Dliquibase.username="postgres" -Dliquibase.password="password" -Dliquibase.changeLogFile="src/main/resources/db/changelog/db-changelog-master.yaml"
) else if "%1"=="update" (
    echo Применение миграций...
    mvn liquibase:update -Dliquibase.url="jdbc:postgresql://localhost:5432/workout_db" -Dliquibase.username="postgres" -Dliquibase.password="password" -Dliquibase.changeLogFile="src/main/resources/db/changelog/db-changelog-master.yaml"
) else if "%1"=="rollback" (
    echo Откат миграций...
    mvn liquibase:rollback -Dliquibase.url="jdbc:postgresql://localhost:5432/workout_db" -Dliquibase.username="postgres" -Dliquibase.password="password" -Dliquibase.changeLogFile="src/main/resources/db/changelog/db-changelog-master.yaml" -Dliquibase.rollbackCount=1
) else if "%1"=="reset" (
    echo СБРОС ВСЕХ ТАБЛИЦ И ПЕРЕСОЗДАНИЕ СХЕМЫ...
    echo Это удалит все данные!
    set /p confirm="Вы уверены? (y/N): "
    if /i "%confirm%"=="y" (
        echo Удаление всех таблиц...
        psql -h localhost -U postgres -d workout_db -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public; GRANT ALL ON SCHEMA public TO postgres; GRANT ALL ON SCHEMA public TO public;"
        echo Применение миграций...
        mvn liquibase:update -Dliquibase.url="jdbc:postgresql://localhost:5432/workout_db" -Dliquibase.username="postgres" -Dliquibase.password="password" -Dliquibase.changeLogFile="src/main/resources/db/changelog/db-changelog-master.yaml"
    ) else (
        echo Операция отменена.
    )
) else if "%1"=="validate" (
    echo Валидация changelog...
    mvn liquibase:validate -Dliquibase.url="jdbc:postgresql://localhost:5432/workout_db" -Dliquibase.username="postgres" -Dliquibase.password="password" -Dliquibase.changeLogFile="src/main/resources/db/changelog/db-changelog-master.yaml"
) else if "%1"=="changelogSync" (
    echo Синхронизация changelog с существующей схемой...
    mvn liquibase:changelogSync -Dliquibase.url="jdbc:postgresql://localhost:5432/workout_db" -Dliquibase.username="postgres" -Dliquibase.password="password" -Dliquibase.changeLogFile="src/main/resources/db/changelog/db-changelog-master.yaml"
) else (
    echo Использование: %0 [команда]
    echo.
    echo Команды:
    echo   status      - Проверить статус миграций
    echo   update      - Применить миграции
    echo   rollback    - Откатить последнюю миграцию
    echo   reset       - Полный сброс и пересоздание схемы
    echo   validate    - Валидировать changelog
    echo   changelogSync - Синхронизировать с существующей схемой
    echo.
    echo Примеры:
    echo   %0 status
    echo   %0 update
    echo   %0 reset
)
