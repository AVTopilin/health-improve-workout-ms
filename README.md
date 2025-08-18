# Workout Backend

Backend microservice for workout application built with Spring Boot 3.2.0.

## 🏋️‍♂️ **Основные возможности приложения:**

### **1. Управление тренировками**
- Создание тренировок с названием и описанием
- Добавление упражнений с параметрами (подходы, повторения, вес, время отдыха)
- Просмотр списка тренировок
- Удаление тренировок

### **2. Расписание тренировок**
- Назначение тренировок на дни недели
- Гибкая настройка расписания

### **3. Прогрессия упражнений**
- Автоматическое увеличение веса
- Увеличение повторений
- Увеличение подходов
- Настройка частоты прогрессии (каждая тренировка/неделя/месяц)

### **4. Автогенерация тренировок**
- Создание тренировок на указанное количество дней
- Применение прогрессии к упражнениям
- Учет расписания по дням недели

### **5. Автоматизированная фиксация тренировки**
- Запуск выполнения тренировки
- Отметка каждого подхода в упражнении
- Автоматический подсчет времени отдыха между подходами и упражнениями

## 🚀 **Quick Start**

### Prerequisites
- Java 17+
- Maven 3.6+
- Docker & Docker Compose

### 🐳 **Docker Compose Options**

#### **Option 1: Full Stack with Local Build (Recommended)**
```bash
# First build the JAR file locally
build-jar.bat

# Then start the full stack
start-full-stack.bat

# This starts:
# - PostgreSQL database
# - Keycloak authentication server  
# - Backend application (Spring Boot)
```

#### **Option 2: Build and Run in One Command**
```bash
# Build JAR and start full stack automatically
build-and-run.bat
```

#### **Option 3: Development Stack (Recommended for Development)**
```bash
# Start only infrastructure, run backend locally
start-dev-stack.bat

# This starts:
# - PostgreSQL database
# - Keycloak authentication server
# Backend runs locally in your IDE
```

#### **Option 4: Infrastructure Only**
```bash
# Start only database and Keycloak
start-infrastructure.bat
```

### **Stop All Services**
```bash
stop-all.bat
```

### Local Development

1. **Start Infrastructure Services**
   ```bash
   # For development (recommended)
   start-dev-stack.bat
   
   # Or manually
   docker-compose -f docker-compose-dev.yml up -d
   ```
   This will start:
   - PostgreSQL on port 5432
   - Keycloak on port 8081

2. **Open in IntelliJ IDEA**
   - File → Open → select `workout_backend_new` folder
   - Wait for Maven project import

3. **Create Run Configuration**
   - Run → Edit Configurations...
   - + → Spring Boot
   - Name: `WorkoutApplication (Local)`
   - Main class: `com.workout.WorkoutApplication`
   - VM options: `-Dspring.profiles.active=local`
   - Working directory: `C:\Dev\workout\workout_backend_new`

4. **Run Application**
   - Click Run button
   - Application will start on port 8080 with PostgreSQL and Keycloak

### Development Mode (DEV) ⚠️ **ВАЖНО: Использует PostgreSQL!**

**Dev режим НЕ использует H2 базу данных!** Он работает с PostgreSQL и Keycloak, как и prod режим.

1. **Start Infrastructure**
   ```bash
   # Используйте готовый скрипт:
   start-dev-stack.bat
   
   # Или вручную:
   docker-compose -f docker-compose-dev.yml up -d
   ```

2. **Check Database Connection**
   ```bash
   check-database.bat
   ```

3. **Run with Development Profile**
   - **Через IntelliJ IDEA:**
     - VM options: `-Dspring.profiles.active=dev`
     - Или используйте: `start-dev-intellij.bat`
   
   - **Через Maven:**
     ```bash
     start-dev-maven.bat
     ```

4. **Dev Mode Features:**
   - ✅ **PostgreSQL** - основная база данных
   - ✅ **Keycloak** - аутентификация и авторизация
   - ✅ **OAuth2 + JWT** - полная поддержка токенов
   - ✅ **permitAll** - все endpoints доступны без токена
   - ✅ **DEBUG logging** - детальное логирование для разработки
   - ✅ **create-drop** - база пересоздается при каждом запуске

### Production Mode

1. **Build and Start Full Stack**
   ```bash
   build-and-run.bat
   ```

2. **Or step by step:**
   ```bash
   build-jar.bat
   start-full-stack.bat
   ```

## 🔧 **Configuration**

### Profiles
- **`local`** - PostgreSQL + Keycloak, development logging, `ddl-auto: create-drop`
- **`dev`** - PostgreSQL + Keycloak, development logging, `ddl-auto: create-drop` ⚠️ **PostgreSQL!**
- **`prod`** - PostgreSQL + Keycloak, production logging, `ddl-auto: update`

### Environment Variables
- `DB_URL` - Database connection URL (default: `jdbc:postgresql://localhost:5432/workout_db`)
- `DB_USERNAME` - Database username (default: `postgres`)
- `DB_PASSWORD` - Database password (default: `password`)
- `KEYCLOAK_ISSUER_URI` - Keycloak realm issuer URI (default: `http://localhost:8081/realms/workout-realm`)

## 📁 **Available Scripts**

### Docker Compose Management
- `build-jar.bat` - Сборка JAR файла локально через Maven
- `build-and-run.bat` - Сборка JAR и запуск полного стека автоматически
- `start-full-stack.bat` - Запуск полного стека (требует предварительной сборки JAR)
- `start-dev-stack.bat` - Запуск только инфраструктуры для разработки
- `stop-all.bat` - Остановка всех сервисов и очистка

### JWT & Security Troubleshooting
- `debug-jwt.bat` - Диагностика проблем с JWT и OAuth2
- `restart-with-jwt-fix.bat` - Перезапуск стека с исправленной JWT конфигурацией

### Infrastructure Management
- `start-infrastructure.bat` - Запуск PostgreSQL и Keycloak
- `start-fixed-infrastructure.bat` - Запуск с исправленным docker-compose
- `check-database.bat` - Проверка подключения к базе данных
- `fix-keycloak.bat` - Диагностика и исправление проблем с Keycloak

### Application Launch
- `start-dev-intellij.bat` - Инструкции для запуска в dev режиме через IntelliJ
- `start-dev-maven.bat` - Запуск в dev режиме через Maven
- `start-local.bat` - Запуск в local режиме

### Testing & Development
- `test-api.html` - HTML тестер для API endpoints
- `test-api.bat` - curl команды для тестирования
- `create-test-data.bat` - Создание тестовых данных
- `get-jwt-token-windows.bat` - Инструкции по получению JWT токена в Windows
- `get-token-auto.bat` - Автоматическое получение JWT токена через PowerShell
- `get-token-simple.bat` - Упрощенное получение JWT токена (рекомендуется)
- `test-with-token.bat` - Тестирование API с JWT токеном

### Keycloak Setup & Configuration
- `setup-keycloak.bat` - Пошаговое руководство по настройке Keycloak
- `Get-JWTToken.ps1` - PowerShell скрипт для получения JWT токенов

### Swagger UI & API Documentation
- `open-swagger.bat` - Быстрое открытие Swagger UI в браузере
- `swagger-guide.html` - Подробное руководство по настройке JWT токенов в Swagger

### Troubleshooting
- `restart-with-auth.bat` - Перезапуск с новой конфигурацией аутентификации

## 🔐 **Keycloak Setup**

### Quick Setup
1. **Run the setup guide:**
   ```bash
   setup-keycloak.bat
   ```

2. **Manual Setup:**
   - Access Keycloak Admin Console: http://localhost:8081
   - Username: `admin`, Password: `admin`
   - Create Realm: `workout-realm`
   - Create Client: `workout-client` (confidential)
   - Create User: `testuser` with password: `test123`

### Test JWT Token Retrieval
After setup, test with:
```bash
get-token-simple.bat
```

## 📚 **API Documentation**

### Swagger UI with JWT Support
- **Swagger UI**: http://localhost:8080/swagger-ui/index.html
- **OpenAPI Spec**: http://localhost:8080/v3/api-docs
- **Quick Open**: `open-swagger.bat`
- **JWT Setup Guide**: `swagger-guide.html`

### How to Add JWT Token in Swagger UI
1. **Open Swagger UI**: http://localhost:8080/swagger-ui/index.html
2. **Click "Authorize"** button (🔒) in top-right corner
3. **Enter token**: `Bearer YOUR_JWT_TOKEN_HERE`
4. **Click "Authorize"** to save
5. **Test API endpoints** - token will be automatically included

### JWT Token Format
```
Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9...
```

## 🗄️ **Database**

### All Profiles (PostgreSQL)
- **Host**: localhost:5432 (local/dev) or postgres:5432 (prod)
- **Database**: workout_db
- **Username**: postgres
- **Password**: password

## 🐳 **Docker Configuration**

### Dockerfile Options
- **`Dockerfile`** - Multi-stage build with Maven (requires internet during build)
- **`Dockerfile.simple`** - Simple build using pre-built JAR (recommended)

### Docker Compose Files
- **`docker-compose.yml`** - Full stack (Backend + PostgreSQL + Keycloak)
- **`docker-compose-dev.yml`** - Infrastructure only (PostgreSQL + Keycloak)
- **`.dockerignore`** - Excludes unnecessary files from build context

### Service Dependencies
```
Backend → Keycloak → PostgreSQL
```

### Health Checks
- **PostgreSQL**: `pg_isready` command
- **Keycloak**: HTTP health endpoint
- **Backend**: HTTP health endpoint

### Build Strategy
1. **Local Build**: JAR file is built locally using Maven
2. **Docker Build**: Only the runtime environment is built in Docker
3. **Benefits**: Faster builds, no internet dependency during Docker build

## 🔐 **JWT Configuration & Troubleshooting**

### JWT Environment Variables
- `SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_ISSUER_URI` - Keycloak realm issuer URI
- `SPRING_SECURITY_OAUTH2_RESOURCESERVER_JWT_JWK_SET_URI` - JWT public key endpoint

### Common JWT Issues

#### **JwtDecoderInitializationException**
**Symptoms**: Backend fails to start with JWT decoder errors
**Causes**: 
- Keycloak not accessible from backend container
- Incorrect issuer URI
- Keycloak realm not configured
**Solutions**:
1. Run `debug-jwt.bat` to diagnose
2. Ensure Keycloak is running and healthy
3. Verify realm configuration
4. Use `restart-with-jwt-fix.bat` to restart with correct config

#### **Invalid Issuer**
**Symptoms**: JWT tokens rejected with issuer validation errors
**Causes**: Mismatch between token issuer and configured issuer URI
**Solutions**:
1. Check Keycloak realm name matches configuration
2. Verify issuer URI in application-prod.yml
3. Ensure backend can reach Keycloak internally

#### **Connection Refused**
**Symptoms**: Backend cannot connect to Keycloak
**Causes**: Network issues between containers
**Solutions**:
1. Check Docker network configuration
2. Verify container dependencies
3. Ensure Keycloak health checks pass

### JWT Debugging Steps
1. **Run diagnostics**: `debug-jwt.bat`
2. **Check container connectivity**: Test internal network communication
3. **Verify Keycloak setup**: Ensure realm and client are configured
4. **Restart with fixes**: `restart-with-jwt-fix.bat`

## 🛠️ **Development**

### Adding New Features
1. Create entity classes in `entity` package
2. Create repository interfaces in `repository` package
3. Create service classes in `service` package
4. Create controller classes in `controller` package
5. Add DTOs in `dto` package

### Testing
- Use `local` profile for local development with containers
- Use `dev` profile for development testing
- Use `prod` profile for production testing

### Batch Scripts Encoding
All `.bat` files use UTF-8 encoding (`chcp 65001`) for proper display of special characters.

## 🚀 **Deployment**

### Docker Compose (Recommended)
```bash
# Production - Build and run
build-and-run.bat

# Development - Infrastructure only
start-dev-stack.bat
```

### Docker
```bash
# Build JAR locally first
mvn clean package -DskipTests

# Build and run Docker container
docker build -f Dockerfile.simple -t workout-backend .
docker run -p 8080:8080 workout-backend
```

### Traditional
```bash
mvn clean package
java -jar -Dspring.profiles.active=prod target/workout-backend-1.0.0.jar
```

## 📋 **API Endpoints**

### **Workouts**
- `GET /api/workouts` - Получить все тренировки
- `POST /api/workouts` - Создать тренировку
- `GET /api/workouts/{id}` - Получить тренировку по ID
- `PUT /api/workouts/{id}` - Обновить тренировку
- `DELETE /api/workouts/{id}` - Удалить тренировку

### **Exercises**
- `GET /api/exercises` - Получить все упражнения
- `POST /api/exercises` - Создать упражнение
- `GET /api/exercises/{id}` - Получить упражнение по ID
- `PUT /api/exercises/{id}` - Обновить упражнение
- `DELETE /api/exercises/{id}` - Удалить упражнение

### **Schedule**
- `GET /api/schedule` - Получить расписание
- `POST /api/schedule` - Создать расписание
- `PUT /api/schedule/{id}` - Обновить расписание
- `DELETE /api/schedule/{id}` - Удалить расписание

### **Progressions**
- `GET /api/progressions` - Получить все прогрессии
- `POST /api/progressions` - Создать прогрессию
- `PUT /api/progressions/{id}` - Обновить прогрессию
- `DELETE /api/progressions/{id}` - Удалить прогрессию

### **Workout Generation**
- `POST /api/generate-workouts` - Сгенерировать тренировки

### **Workout Sessions**
- `GET /api/workout-sessions` - Получить все сессии тренировок
- `POST /api/workout-sessions` - Создать сессию тренировки
- `GET /api/workout-sessions/{id}` - Получить сессию по ID
- `PUT /api/workout-sessions/{id}` - Обновить сессию
- `DELETE /api/workout-sessions/{id}` - Удалить сессию

### **Exercise Sets**
- `GET /api/exercise-sets` - Получить все подходы
- `POST /api/exercise-sets` - Создать подход
- `GET /api/exercise-sets/{id}` - Получить подход по ID
- `PUT /api/exercise-sets/{id}` - Обновить подход
- `DELETE /api/exercise-sets/{id}` - Удалить подход
