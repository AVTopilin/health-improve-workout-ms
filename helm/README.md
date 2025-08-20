# Workout Backend Helm Charts

Этот Helm chart разворачивает полный стек приложения Workout Backend в Kubernetes.

## Компоненты

- **workout-backend** - Основное Spring Boot приложение
- **postgresql** - База данных PostgreSQL
- **minio** - Объектное хранилище MinIO
- **keycloak** - Система аутентификации и авторизации

## Установка

### Предварительные требования

- Kubernetes 1.19+
- Helm 3.0+
- StorageClass для PersistentVolumes

### Установка зависимостей

```bash
helm dependency update
```

### Установка приложения

```bash
# Установка с настройками по умолчанию
helm install workout-backend .

# Установка с кастомными настройками
helm install workout-backend . -f values-custom.yaml

# Установка в определенном namespace
helm install workout-backend . --namespace workout --create-namespace
```

### Обновление приложения

```bash
helm upgrade workout-backend .
```

### Удаление приложения

```bash
helm uninstall workout-backend
```

## Конфигурация

### Основные параметры

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| `replicaCount` | Количество реплик приложения | `1` |
| `image.repository` | Репозиторий Docker образа | `workout-backend` |
| `image.tag` | Тег Docker образа | `"1.0.0"` |
| `service.type` | Тип Kubernetes Service | `ClusterIP` |

### База данных

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| `database.host` | Хост PostgreSQL | `postgresql` |
| `database.port` | Порт PostgreSQL | `5432` |
| `database.name` | Имя базы данных | `workout_db` |
| `database.username` | Пользователь БД | `workout_user` |
| `database.password` | Пароль БД | `workout_password` |

### MinIO

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| `minio.host` | Хост MinIO | `minio` |
| `minio.port` | Порт MinIO API | `9000` |
| `minio.accessKey` | Access Key | `minioadmin` |
| `minio.secretKey` | Secret Key | `minioadmin` |
| `minio.bucket` | Имя bucket | `workout-media` |

### Keycloak

| Параметр | Описание | По умолчанию |
|----------|----------|--------------|
| `keycloak.host` | Хост Keycloak | `keycloak` |
| `keycloak.port` | Порт Keycloak | `8080` |
| `keycloak.realm` | Realm | `workout` |
| `keycloak.clientId` | Client ID | `workout-backend` |

## Масштабирование

### Автоматическое масштабирование

```yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 80
  targetMemoryUtilizationPercentage: 80
```

### Ручное масштабирование

```bash
kubectl scale deployment workout-backend --replicas=3
```

## Мониторинг

### Health Checks

Приложение предоставляет следующие endpoints для проверки здоровья:

- `/health` - Общая проверка здоровья
- `/actuator/health` - Детальная информация о здоровье (если включен Spring Boot Actuator)

### Логи

```bash
# Просмотр логов приложения
kubectl logs -f deployment/workout-backend

# Просмотр логов базы данных
kubectl logs -f deployment/postgresql

# Просмотр логов MinIO
kubectl logs -f deployment/minio

# Просмотр логов Keycloak
kubectl logs -f deployment/keycloak
```

## Troubleshooting

### Проверка статуса подов

```bash
kubectl get pods -l app.kubernetes.io/name=workout-backend
```

### Проверка сервисов

```bash
kubectl get services -l app.kubernetes.io/name=workout-backend
```

### Проверка PersistentVolumeClaims

```bash
kubectl get pvc -l app.kubernetes.io/name=workout-backend
```

### Описание подов

```bash
kubectl describe pod <pod-name>
```

## Безопасность

### Secrets

Для продакшена рекомендуется использовать Kubernetes Secrets:

```yaml
database:
  existingSecret: "workout-db-secret"

minio:
  existingSecret: "workout-minio-secret"

keycloak:
  existingSecret: "workout-keycloak-secret"
```

### Network Policies

Рекомендуется настроить Network Policies для ограничения сетевого доступа между компонентами.

## Производительность

### Ресурсы

Настройте ресурсы в соответствии с нагрузкой:

```yaml
resources:
  limits:
    cpu: 2000m
    memory: 2Gi
  requests:
    cpu: 1000m
    memory: 1Gi
```

### JVM настройки

Для оптимизации производительности Spring Boot приложения добавьте JVM параметры:

```yaml
env:
  - name: JAVA_OPTS
    value: "-Xms512m -Xmx1g -XX:+UseG1GC"
```
