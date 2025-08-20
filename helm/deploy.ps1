# PowerShell скрипт для развертывания Workout Backend в Kubernetes

param(
    [string]$Namespace = "workout",
    [string]$ReleaseName = "workout-backend",
    [string]$ValuesFile = "values.yaml",
    [switch]$DryRun,
    [switch]$Uninstall
)

Write-Host "🚀 Workout Backend Kubernetes Deployment Script" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green

# Проверка наличия Helm
try {
    $helmVersion = helm version --short
    Write-Host "✅ Helm найден: $helmVersion" -ForegroundColor Green
} catch {
    Write-Host "❌ Helm не найден. Установите Helm 3.0+" -ForegroundColor Red
    exit 1
}

# Проверка подключения к Kubernetes
try {
    $kubectlContext = kubectl config current-context
    Write-Host "✅ Kubernetes контекст: $kubectlContext" -ForegroundColor Green
} catch {
    Write-Host "❌ Не удалось подключиться к Kubernetes" -ForegroundColor Red
    exit 1
}

# Создание namespace если не существует
Write-Host "📦 Создание namespace '$Namespace'..." -ForegroundColor Yellow
kubectl create namespace $Namespace --dry-run=client -o yaml | kubectl apply -f -

# Обновление зависимостей Helm
Write-Host "📥 Обновление Helm зависимостей..." -ForegroundColor Yellow
helm dependency update

if ($Uninstall) {
    Write-Host "🗑️ Удаление релиза '$ReleaseName'..." -ForegroundColor Red
    helm uninstall $ReleaseName -n $Namespace
    Write-Host "✅ Релиз удален" -ForegroundColor Green
    exit 0
}

# Проверка существующего релиза
$existingRelease = helm list -n $Namespace -q | Where-Object { $_ -eq $ReleaseName }

if ($existingRelease) {
    Write-Host "🔄 Обновление существующего релиза '$ReleaseName'..." -ForegroundColor Yellow
    
    if ($DryRun) {
        helm upgrade $ReleaseName . -n $Namespace -f $ValuesFile --dry-run
        Write-Host "✅ Dry run завершен" -ForegroundColor Green
    } else {
        helm upgrade $ReleaseName . -n $Namespace -f $ValuesFile
        Write-Host "✅ Релиз обновлен" -ForegroundColor Green
    }
} else {
    Write-Host "🆕 Установка нового релиза '$ReleaseName'..." -ForegroundColor Yellow
    
    if ($DryRun) {
        helm install $ReleaseName . -n $Namespace -f $ValuesFile --dry-run
        Write-Host "✅ Dry run завершен" -ForegroundColor Green
    } else {
        helm install $ReleaseName . -n $Namespace -f $ValuesFile
        Write-Host "✅ Релиз установлен" -ForegroundColor Green
    }
}

if (-not $DryRun) {
    Write-Host "⏳ Ожидание готовности подов..." -ForegroundColor Yellow
    
    # Ожидание готовности основного приложения
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=workout-backend -n $Namespace --timeout=300s
    
    # Ожидание готовности PostgreSQL
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=postgresql -n $Namespace --timeout=300s
    
    # Ожидание готовности MinIO
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=minio -n $Namespace --timeout=300s
    
    # Ожидание готовности Keycloak
    kubectl wait --for=condition=ready pod -l app.kubernetes.io/name=keycloak -n $Namespace --timeout=300s
    
    Write-Host "✅ Все поды готовы!" -ForegroundColor Green
    
    # Показ статуса
    Write-Host "📊 Статус развертывания:" -ForegroundColor Cyan
    kubectl get all -n $Namespace
    
    Write-Host "🔗 Сервисы:" -ForegroundColor Cyan
    kubectl get services -n $Namespace
    
    Write-Host "💾 PersistentVolumeClaims:" -ForegroundColor Cyan
    kubectl get pvc -n $Namespace
}

Write-Host "🎉 Развертывание завершено!" -ForegroundColor Green
Write-Host "Для доступа к приложению используйте:" -ForegroundColor Cyan
Write-Host "kubectl port-forward -n $Namespace svc/$ReleaseName 8080:8080" -ForegroundColor White
