# Инструкции по развертыванию Workout Backend в Kubernetes

## Быстрый старт

### 1. Предварительные требования

- Kubernetes кластер (локальный или облачный)
- Helm 3.0+
- kubectl настроен для подключения к кластеру
- StorageClass для PersistentVolumes

### 2. Клонирование и подготовка

```bash
# Клонирование репозитория
git clone <your-repo-url>
cd health-improve-workout-ms/helm

# Обновление зависимостей
helm dependency update
```

### 3. Развертывание

#### Локальное окружение (minikube/kind)

```bash
# Создание namespace
kubectl create namespace workout

# Установка с настройками по умолчанию
helm install workout-backend . -n workout

# Или с кастомными настройками
helm install workout-backend . -n workout -f values-custom.yaml
```

#### Продакшн

```bash
# Установка в продакшн namespace
helm install workout-backend . -n workout-prod -f values-prod.yaml
```

### 4. Проверка развертывания

```bash
# Статус подов
kubectl get pods -n workout

# Статус сервисов
kubectl get services -n workout

# Логи приложения
kubectl logs -f deployment/workout-backend -n workout
```

## Детальная настройка

### Конфигурация базы данных

Для использования внешней PostgreSQL:

```yaml
# values-custom.yaml
database:
  enabled: false  # Отключаем встроенную PostgreSQL
  
# В основном values.yaml измените:
database:
  host: your-external-postgresql-host
  port: 5432
  name: workout_db
  username: workout_user
  password: your-secure-password
```

### Конфигурация MinIO

Для использования внешнего S3-совместимого хранилища:

```yaml
# values-custom.yaml
minio:
  enabled: false  # Отключаем встроенный MinIO
  
# В основном values.yaml измените:
minio:
  host: your-s3-endpoint
  port: 443  # Для HTTPS
  accessKey: your-access-key
  secretKey: your-secret-key
  bucket: workout-media
```

### Конфигурация Keycloak

Для использования внешнего Keycloak:

```yaml
# values-custom.yaml
keycloak:
  enabled: false  # Отключаем встроенный Keycloak
  
# В основном values.yaml измените:
keycloak:
  host: your-keycloak-host
  port: 8080
  realm: workout
  clientId: workout-backend
```

## Масштабирование

### Автоматическое масштабирование

```yaml
# values-custom.yaml
autoscaling:
  enabled: true
  minReplicas: 2
  maxReplicas: 10
  targetCPUUtilizationPercentage: 70
  targetMemoryUtilizationPercentage: 70
```

### Ручное масштабирование

```bash
# Масштабирование до 3 реплик
kubectl scale deployment workout-backend --replicas=3 -n workout
```

## Мониторинг и логирование

### Включение Spring Boot Actuator

Добавьте в `pom.xml`:

```xml
<dependency>
    <groupId>org.springframework.boot</groupId>
    <artifactId>spring-boot-starter-actuator</artifactId>
</dependency>
```

И настройте в `application.yml`:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,prometheus
  endpoint:
    health:
      show-details: always
```

### Prometheus метрики

```yaml
# values-custom.yaml
podAnnotations:
  prometheus.io/scrape: "true"
  prometheus.io/port: "8080"
  prometheus.io/path: "/actuator/prometheus"
```

## Безопасность

### Использование Secrets

Создайте Kubernetes Secrets:

```bash
# База данных
kubectl create secret generic workout-db-secret \
  --from-literal=username=workout_user \
  --from-literal=password=your-secure-password \
  -n workout

# MinIO
kubectl create secret generic workout-minio-secret \
  --from-literal=access-key=your-access-key \
  --from-literal=secret-key=your-secret-key \
  -n workout

# Keycloak
kubectl create secret generic workout-keycloak-secret \
  --from-literal=client-secret=your-client-secret \
  -n workout
```

И укажите их в values:

```yaml
database:
  existingSecret: "workout-db-secret"

minio:
  existingSecret: "workout-minio-secret"

keycloak:
  existingSecret: "workout-keycloak-secret"
```

### Network Policies

Создайте Network Policy для ограничения доступа:

```yaml
# network-policy.yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: workout-backend-network-policy
  namespace: workout
spec:
  podSelector:
    matchLabels:
      app.kubernetes.io/name: workout-backend
  policyTypes:
  - Ingress
  - Egress
  ingress:
  - from:
    - namespaceSelector:
        matchLabels:
          name: ingress-nginx
    ports:
    - protocol: TCP
      port: 8080
  egress:
  - to:
    - namespaceSelector:
        matchLabels:
          name: workout
    ports:
    - protocol: TCP
      port: 5432  # PostgreSQL
    - protocol: TCP
      port: 9000  # MinIO
    - protocol: TCP
      port: 8080  # Keycloak
```

## Troubleshooting

### Проблемы с подключением к базе данных

```bash
# Проверка статуса PostgreSQL
kubectl get pods -l app.kubernetes.io/name=postgresql -n workout

# Логи PostgreSQL
kubectl logs -f deployment/postgresql -n workout

# Проверка подключения
kubectl exec -it deployment/workout-backend -n workout -- pg_isready -h postgresql -p 5432
```

### Проблемы с MinIO

```bash
# Проверка статуса MinIO
kubectl get pods -l app.kubernetes.io/name=minio -n workout

# Логи MinIO
kubectl logs -f deployment/minio -n workout

# Проверка bucket
kubectl exec -it deployment/minio -n workout -- mc ls myminio/
```

### Проблемы с Keycloak

```bash
# Проверка статуса Keycloak
kubectl get pods -l app.kubernetes.io/name=keycloak -n workout

# Логи Keycloak
kubectl logs -f deployment/keycloak -n workout

# Проверка health endpoint
kubectl exec -it deployment/keycloak -n workout -- curl http://localhost:8080/health
```

### Общие проблемы

```bash
# Описание пода
kubectl describe pod <pod-name> -n workout

# События namespace
kubectl get events -n workout --sort-by='.lastTimestamp'

# Проверка PersistentVolumeClaims
kubectl get pvc -n workout

# Проверка PersistentVolumes
kubectl get pv
```

## Обновление приложения

### Обновление образа

```bash
# Обновление с новым образом
helm upgrade workout-backend . -n workout --set image.tag=new-version

# Или через values файл
helm upgrade workout-backend . -n workout -f values-new-version.yaml
```

### Rollback

```bash
# Просмотр истории релизов
helm history workout-backend -n workout

# Откат к предыдущей версии
helm rollback workout-backend 1 -n workout
```

## Удаление

```bash
# Удаление релиза
helm uninstall workout-backend -n workout

# Удаление namespace (осторожно!)
kubectl delete namespace workout
```

## Полезные команды

```bash
# Порт-форвардинг для локального доступа
kubectl port-forward -n workout svc/workout-backend 8080:8080

# Просмотр всех ресурсов
kubectl get all -n workout

# Просмотр конфигурации
helm get values workout-backend -n workout

# Экспорт манифестов
helm template workout-backend . -n workout > manifests.yaml
```
