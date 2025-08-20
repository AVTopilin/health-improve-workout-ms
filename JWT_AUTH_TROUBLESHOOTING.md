# 🔐 JWT Authentication Troubleshooting Guide

## 🚨 Проблема: "I/O error while reading input message"

### **Описание ошибки**
```
HTTP: {"path":"uri=/api/workouts","error":"Bad Request","message":"Invalid JSON format: I/O error while reading input message","timestamp":"2025-08-18T23:10:23","status":400}
```

### **Корень проблемы**
Ошибка **НЕ в JSON парсинге**, а в **JWT аутентификации**:

1. **Фронтенд** отправляет POST `/api/workouts` без `Authorization: Bearer <token>`
2. **Spring Security** блокирует запрос в `BearerTokenAuthenticationFilter`
3. **Запрос не доходит до контроллера** - отсюда "I/O error"
4. **Фронтенд** получает 401 Unauthorized

## ✅ Решения

### **Решение 1: Временно отключить JWT (для отладки)**

Используйте профиль `debug` или `dev`:

```bash
# PowerShell
.\switch-profile.ps1 debug

# Batch
switch-profile.bat debug
```

Затем перезапустите контейнеры:
```bash
docker-compose down
docker-compose up -d
```

### **Решение 2: Настроить JWT аутентификацию**

#### **Шаг 1: Настроить Keycloak**
```bash
# Откройте Keycloak
http://localhost:8081

# Создайте realm: workout-realm
# Создайте client: workout-backend
# Создайте пользователя
```

#### **Шаг 2: Получить JWT токен**
```bash
# Используйте скрипт
.\get-token-auto.bat

# Или вручную
curl -X POST http://localhost:8081/realms/workout-realm/protocol/openid-connect/token \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=password&client_id=workout-backend&username=your-username&password=your-password"
```

#### **Шаг 3: Использовать токен в запросах**
```bash
curl -X POST http://localhost:8080/api/workouts \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"test","dayOfWeek":"MONDAY","weeksCount":1,"startDate":"2025-08-18"}'
```

### **Решение 3: Настроить фронтенд для отправки JWT токенов**

Добавьте в заголовки запросов:
```javascript
headers: {
  'Authorization': `Bearer ${jwtToken}`,
  'Content-Type': 'application/json'
}
```

## 🔧 Профили Spring Boot

### **prod** - Продакшн (с JWT)
- ✅ `/health`, `/test-json` - без аутентификации
- ❌ `/api/**` - требует JWT токен
- 🔒 Все остальные endpoints защищены

### **debug** - Отладка (без JWT)
- ✅ `/health`, `/test-json` - без аутентификации
- ✅ `/api/**` - без аутентификации
- 🔓 Все endpoints открыты

### **dev** - Разработка (без JWT)
- ✅ `/health`, `/test-json` - без аутентификации
- ✅ `/api/**` - без аутентификации
- 🔓 Все endpoints открыты

## 🧪 Тестирование

### **Тест health endpoint**
```bash
curl http://localhost:8080/health
```

### **Тест JSON парсинга**
```bash
curl -X POST http://localhost:8080/test-json \
  -H "Content-Type: application/json" \
  -d '{"test":"data"}'
```

### **Тест API без аутентификации (debug/dev профиль)**
```bash
curl -X POST http://localhost:8080/api/workouts \
  -H "Content-Type: application/json" \
  -d '{"name":"test","dayOfWeek":"MONDAY","weeksCount":1,"startDate":"2025-08-18"}'
```

### **Тест API с JWT (prod профиль)**
```bash
curl -X POST http://localhost:8080/api/workouts \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -H "Content-Type: application/json" \
  -d '{"name":"test","dayOfWeek":"MONDAY","weeksCount":1,"startDate":"2025-08-18"}'
```

## 📋 Чек-лист решения

- [ ] Определить профиль Spring Boot (`prod`/`debug`/`dev`)
- [ ] Если `prod` - настроить JWT аутентификацию
- [ ] Если `debug`/`dev` - проверить, что JWT отключен
- [ ] Протестировать `/health` endpoint
- [ ] Протестировать `/test-json` endpoint
- [ ] Протестировать API endpoints
- [ ] Настроить фронтенд для отправки JWT токенов (если нужно)

## 🚀 Быстрый старт для отладки

```bash
# 1. Переключиться на debug профиль
.\switch-profile.ps1 debug

# 2. Перезапустить контейнеры
docker-compose down
docker-compose up -d

# 3. Протестировать endpoints
.\test-json.ps1
```

## 📚 Полезные ссылки

- [Spring Security OAuth2 Resource Server](https://docs.spring.io/spring-security/reference/servlet/oauth2/resource-server/index.html)
- [Keycloak Documentation](https://www.keycloak.org/documentation)
- [JWT Debugger](https://jwt.io/)
