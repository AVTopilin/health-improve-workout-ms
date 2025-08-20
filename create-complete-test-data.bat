@echo off
echo Creating Complete Test Data for Workout System...

echo.
echo ========================================
echo 1. Getting JWT Token for Authentication
echo ========================================
echo Getting JWT token from Keycloak...
powershell -ExecutionPolicy Bypass -Command "try { $body = @{ grant_type = 'password'; client_id = 'workout-client'; username = 'testuser'; password = 'password' }; $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'; $token = $response.access_token; Write-Host '[SUCCESS] Token received!' -ForegroundColor Green; Write-Host 'Token length: ' + $token.Length -ForegroundColor Yellow; $token | Out-File -FilePath 'jwt_token_test_data.txt' -Encoding UTF8; Write-Host 'Token saved to jwt_token_test_data.txt' -ForegroundColor Green } catch { Write-Host '[ERROR] Token retrieval failed:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; exit 1 }"

if %errorlevel% neq 0 (
    echo Failed to get JWT token
    pause
    exit /b 1
)

echo.
echo ========================================
echo 2. Creating Muscle Groups
echo ========================================
echo Creating Chest muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Грудные мышцы\",\"description\":\"Основные мышцы груди для жимов и разводок\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Chest muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'chest_muscle_group.json' } catch { Write-Host 'Error creating chest muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Back muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Спина\",\"description\":\"Мышцы спины для тяг и подтягиваний\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Back muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'back_muscle_group.json' } catch { Write-Host 'Error creating back muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Legs muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Ноги\",\"description\":\"Мышцы ног для приседаний и выпадов\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Legs muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'legs_muscle_group.json' } catch { Write-Host 'Error creating legs muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Shoulders muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Плечи\",\"description\":\"Дельтовидные мышцы для жимов и разводок\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Shoulders muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'shoulders_muscle_group.json' } catch { Write-Host 'Error creating shoulders muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 3. Creating Equipment
echo ========================================
echo Creating Barbell equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Штанга\",\"description\":\"Олимпийская штанга для базовых упражнений\",\"type\":\"BARBELL\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Barbell equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'barbell_equipment.json' } catch { Write-Host 'Error creating barbell equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Dumbbells equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Гантели\",\"description\":\"Разборные гантели для изолированных упражнений\",\"type\":\"DUMBBELLS\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Dumbbells equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'dumbbells_equipment.json' } catch { Write-Host 'Error creating dumbbells equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Bench equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Скамья\",\"description\":\"Регулируемая скамья для жимов и разводок\",\"type\":\"BENCH\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Bench equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_equipment.json' } catch { Write-Host 'Error creating bench equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Pull-up Bar equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Турник\",\"description\":\"Турник для подтягиваний и висов\",\"type\":\"PULL_UP_BAR\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Pull-up bar equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pullup_bar_equipment.json' } catch { Write-Host 'Error creating pull-up bar equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 4. Creating Exercise Templates
echo ========================================
echo Creating Bench Press template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $chestId = (Get-Content chest_muscle_group.json | ConvertFrom-Json).id; $barbellId = (Get-Content barbell_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Жим лежа\",\"description\":\"Базовое упражнение для грудных мышц\",\"instructions\":\"Лягте на скамью, опустите штангу к груди, выжмите вверх\",\"tips\":\"Держите локти под углом 45 градусов\",\"difficultyLevel\":\"INTERMEDIATE\",\"muscleGroupId\":' + $chestId + ',\"equipmentId\":' + $barbellId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Bench Press template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_press_template.json' } catch { Write-Host 'Error creating bench press template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Squat template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $legsId = (Get-Content legs_muscle_group.json | ConvertFrom-Json).id; $barbellId = (Get-Content barbell_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Приседания со штангой\",\"description\":\"Базовое упражнение для мышц ног\",\"instructions\":\"Поставьте штангу на плечи, присядьте до параллели бедер с полом\",\"tips\":\"Держите спину прямой, колени не выходят за носки\",\"difficultyLevel\":\"INTERMEDIATE\",\"muscleGroupId\":' + $legsId + ',\"equipmentId\":' + $barbellId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Squat template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'squat_template.json' } catch { Write-Host 'Error creating squat template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Pull-up template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $backId = (Get-Content back_muscle_group.json | ConvertFrom-Json).id; $pullupId = (Get-Content pullup_bar_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Подтягивания\",\"description\":\"Базовое упражнение для мышц спины\",\"instructions\":\"Повисните на турнике, подтянитесь до касания подбородком перекладины\",\"tips\":\"Держите корпус напряженным, не раскачивайтесь\",\"difficultyLevel\":\"BEGINNER\",\"muscleGroupId\":' + $backId + ',\"equipmentId\":' + $pullupId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Pull-up template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pullup_template.json' } catch { Write-Host 'Error creating pull-up template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Dumbbell Press template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $shouldersId = (Get-Content shoulders_muscle_group.json | ConvertFrom-Json).id; $dumbbellsId = (Get-Content dumbbells_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Жим гантелей стоя\",\"description\":\"Упражнение для дельтовидных мышц\",\"instructions\":\"Встаньте прямо, поднимите гантели к плечам, выжмите вверх\",\"tips\":\"Держите корпус напряженным, не прогибайтесь в пояснице\",\"difficultyLevel\":\"BEGINNER\",\"muscleGroupId\":' + $shouldersId + ',\"equipmentId\":' + $dumbbellsId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Dumbbell Press template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'dumbbell_press_template.json' } catch { Write-Host 'Error creating dumbbell press template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 5. Creating Workouts
echo ========================================
echo Creating Push Workout (Chest, Shoulders, Triceps)...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Push Workout\",\"description\":\"Тренировка толкающих мышц\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":4,\"startDate\":\"2025-08-19\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Push Workout created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'push_workout.json' } catch { Write-Host 'Error creating push workout:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Pull Workout (Back, Biceps)...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Pull Workout\",\"description\":\"Тренировка тянущих мышц\",\"dayOfWeek\":\"WEDNESDAY\",\"weeksCount\":4,\"startDate\":\"2025-08-19\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Pull Workout created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pull_workout.json' } catch { Write-Host 'Error creating pull workout:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Legs Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Legs Workout\",\"description\":\"Тренировка мышц ног\",\"dayOfWeek\":\"FRIDAY\",\"weeksCount\":4,\"startDate\":\"2025-08-19\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Legs Workout created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'legs_workout.json' } catch { Write-Host 'Error creating legs workout:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 6. Creating Exercises in Workouts
echo ========================================
echo Adding Bench Press to Push Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $pushWorkoutId = (Get-Content push_workout.json | ConvertFrom-Json).id; $benchPressTemplateId = (Get-Content bench_press_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Жим лежа\",\"description\":\"Базовое упражнение для грудных мышц\",\"sets\":4,\"reps\":8,\"weight\":60.0,\"workoutId\":' + $pushWorkoutId + ',\"exerciseTemplateId\":' + $benchPressTemplateId + ',\"restTime\":120}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Bench Press exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_press_exercise.json' } catch { Write-Host 'Error creating bench press exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Adding Dumbbell Press to Push Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $pushWorkoutId = (Get-Content push_workout.json | ConvertFrom-Json).id; $dumbbellPressTemplateId = (Get-Content dumbbell_press_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Жим гантелей стоя\",\"description\":\"Упражнение для дельтовидных мышц\",\"sets\":3,\"reps\":12,\"weight\":20.0,\"workoutId\":' + $pushWorkoutId + ',\"exerciseTemplateId\":' + $dumbbellPressTemplateId + ',\"restTime\":90}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Dumbbell Press exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'dumbbell_press_exercise.json' } catch { Write-Host 'Error creating dumbbell press exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Adding Squat to Legs Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $legsWorkoutId = (Get-Content legs_workout.json | ConvertFrom-Json).id; $squatTemplateId = (Get-Content squat_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Приседания со штангой\",\"description\":\"Базовое упражнение для мышц ног\",\"sets\":4,\"reps\":6,\"weight\":80.0,\"workoutId\":' + $legsWorkoutId + ',\"exerciseTemplateId\":' + $squatTemplateId + ',\"restTime\":180}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Squat exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'squat_exercise.json' } catch { Write-Host 'Error creating squat exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Adding Pull-up to Pull Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $pullWorkoutId = (Get-Content pull_workout.json | ConvertFrom-Json).id; $pullupTemplateId = (Get-Content pullup_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Подтягивания\",\"description\":\"Базовое упражнение для мышц спины\",\"sets\":3,\"reps\":8,\"weight\":0.0,\"workoutId\":' + $pullWorkoutId + ',\"exerciseTemplateId\":' + $pullupTemplateId + ',\"restTime\":120}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Pull-up exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pullup_exercise.json' } catch { Write-Host 'Error creating pull-up exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 7. Creating Progressions
echo ========================================
echo Creating Bench Press progression...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $benchPressExerciseId = (Get-Content bench_press_exercise.json | ConvertFrom-Json).id; $benchPressTemplateId = (Get-Content bench_press_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"exerciseId\":' + $benchPressExerciseId + ',\"exerciseTemplateId\":' + $benchPressTemplateId + ',\"weeksCount\":4,\"startDate\":\"2025-08-19\",\"weightProgressionEnabled\":true,\"repsProgressionEnabled\":false,\"setsProgressionEnabled\":false,\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":2.5,\"weightPeriodicity\":\"EVERY_WORKOUT\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/progressions' -Method POST -Headers $headers -Body $body; Write-Host 'Bench Press progression created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_press_progression.json' } catch { Write-Host 'Error creating bench press progression:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Squat progression...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $squatExerciseId = (Get-Content squat_exercise.json | ConvertFrom-Json).id; $squatTemplateId = (Get-Content squat_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"exerciseId\":' + $squatExerciseId + ',\"exerciseTemplateId\":' + $squatTemplateId + ',\"weeksCount\":4,\"startDate\":\"2025-08-19\",\"weightProgressionEnabled\":true,\"repsProgressionEnabled\":false,\"setsProgressionEnabled\":false,\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":5.0,\"weightPeriodicity\":\"EVERY_WORKOUT\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/progressions' -Method POST -Headers $headers -Body $body; Write-Host 'Squat progression created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'squat_progression.json' } catch { Write-Host 'Error creating squat progression:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 8. Creating Workout Schedule
echo ========================================
echo Creating weekly workout schedule...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $pushWorkoutId = (Get-Content push_workout.json | ConvertFrom-Json).id; $pullWorkoutId = (Get-Content pull_workout.json | ConvertFrom-Json).id; $legsWorkoutId = (Get-Content legs_workout.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"workoutId\":' + $pushWorkoutId + ',\"scheduledDate\":\"2025-08-19\",\"executionStatus\":\"PLANNED\",\"notes\":\"Понедельник - Push день\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workout-schedules' -Method POST -Headers $headers -Body $body; Write-Host 'Monday workout schedule created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green } catch { Write-Host 'Error creating Monday workout schedule:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"workoutId\":' + $pullWorkoutId + ',\"scheduledDate\":\"2025-08-21\",\"executionStatus\":\"PLANNED\",\"notes\":\"Среда - Pull день\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workout-schedules' -Method POST -Headers $headers -Body $body; Write-Host 'Wednesday workout schedule created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green } catch { Write-Host 'Error creating Wednesday workout schedule:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_test_data.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"workoutId\":' + $legsWorkoutId + ',\"scheduledDate\":\"2025-08-23\",\"executionStatus\":\"PLANNED\",\"notes\":\"Пятница - Legs день\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workout-schedules' -Method POST -Headers $headers -Body $body; Write-Host 'Friday workout schedule created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green } catch { Write-Host 'Error creating Friday workout schedule:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 9. Summary of Created Data
echo ========================================
echo.
echo Created Test Data Summary:
echo =========================
echo.
echo Muscle Groups: 4 (Chest, Back, Legs, Shoulders)
echo Equipment: 4 (Barbell, Dumbbells, Bench, Pull-up Bar)
echo Exercise Templates: 4 (Bench Press, Squat, Pull-up, Dumbbell Press)
echo Workouts: 3 (Push, Pull, Legs)
echo Exercises: 4 (Bench Press, Dumbbell Press, Squat, Pull-up)
echo Progressions: 2 (Bench Press, Squat)
echo Workout Schedules: 3 (Monday, Wednesday, Friday)
echo.
echo All data files saved to JSON files for reference
echo.
echo ========================================
echo Test Data Creation Completed!
echo ========================================
pause
