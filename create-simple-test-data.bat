@echo off
echo Creating Simple Test Data for Workout System (English names)...

echo.
echo ========================================
echo 1. Getting JWT Token for Authentication
echo ========================================
echo Getting JWT token from Keycloak...
powershell -ExecutionPolicy Bypass -Command "try { $body = @{ grant_type = 'password'; client_id = 'workout-client'; username = 'testuser'; password = 'password' }; $response = Invoke-RestMethod -Uri 'http://localhost:8081/realms/workout-realm/protocol/openid-connect/token' -Method POST -Body $body -ContentType 'application/x-www-form-urlencoded'; $token = $response.access_token; Write-Host '[SUCCESS] Token received!' -ForegroundColor Green; Write-Host 'Token length: ' + $token.Length -ForegroundColor Yellow; $token | Out-File -FilePath 'jwt_token_simple.txt' -Encoding UTF8; Write-Host 'Token saved to jwt_token_simple.txt' -ForegroundColor Green } catch { Write-Host '[ERROR] Token retrieval failed:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red; exit 1 }"

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
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Chest\",\"description\":\"Chest muscles for presses and flyes\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Chest muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'chest_muscle_group.json' } catch { Write-Host 'Error creating chest muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Back muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Back\",\"description\":\"Back muscles for rows and pull-ups\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Back muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'back_muscle_group.json' } catch { Write-Host 'Error creating back muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Legs muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Legs\",\"description\":\"Leg muscles for squats and lunges\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Legs muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'legs_muscle_group.json' } catch { Write-Host 'Error creating legs muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Shoulders muscle group...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Shoulders\",\"description\":\"Deltoid muscles for presses and flyes\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/muscle-groups' -Method POST -Headers $headers -Body $body; Write-Host 'Shoulders muscle group created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'shoulders_muscle_group.json' } catch { Write-Host 'Error creating shoulders muscle group:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 3. Creating Equipment
echo ========================================
echo Creating Barbell equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Barbell\",\"description\":\"Olympic barbell for compound exercises\",\"type\":\"BARBELL\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Barbell equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'barbell_equipment.json' } catch { Write-Host 'Error creating barbell equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Dumbbells equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Dumbbells\",\"description\":\"Adjustable dumbbells for isolation exercises\",\"type\":\"DUMBBELLS\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Dumbbells equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'dumbbells_equipment.json' } catch { Write-Host 'Error creating dumbbells equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Bench equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Bench\",\"description\":\"Adjustable bench for presses and flyes\",\"type\":\"BENCH\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Bench equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_equipment.json' } catch { Write-Host 'Error creating bench equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Pull-up Bar equipment...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Pull-up Bar\",\"description\":\"Pull-up bar for pull-ups and hangs\",\"type\":\"PULL_UP_BAR\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/equipment' -Method POST -Headers $headers -Body $body; Write-Host 'Pull-up bar equipment created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pullup_bar_equipment.json' } catch { Write-Host 'Error creating pull-up bar equipment:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 4. Creating Exercise Templates
echo ========================================
echo Creating Bench Press template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $chestId = (Get-Content chest_muscle_group.json | ConvertFrom-Json).id; $barbellId = (Get-Content barbell_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Bench Press\",\"description\":\"Compound exercise for chest muscles\",\"instructions\":\"Lie on bench, lower barbell to chest, press up\",\"tips\":\"Keep elbows at 45 degree angle\",\"difficultyLevel\":\"INTERMEDIATE\",\"muscleGroupId\":' + $chestId + ',\"equipmentId\":' + $barbellId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Bench Press template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_press_template.json' } catch { Write-Host 'Error creating bench press template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Squat template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $legsId = (Get-Content legs_muscle_group.json | ConvertFrom-Json).id; $barbellId = (Get-Content barbell_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Barbell Squat\",\"description\":\"Compound exercise for leg muscles\",\"instructions\":\"Place barbell on shoulders, squat to parallel\",\"tips\":\"Keep back straight, knees behind toes\",\"difficultyLevel\":\"INTERMEDIATE\",\"muscleGroupId\":' + $legsId + ',\"equipmentId\":' + $barbellId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Squat template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'squat_template.json' } catch { Write-Host 'Error creating squat template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Pull-up template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $backId = (Get-Content back_muscle_group.json | ConvertFrom-Json).id; $pullupId = (Get-Content pullup_bar_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Pull-up\",\"description\":\"Compound exercise for back muscles\",\"instructions\":\"Hang on bar, pull up to chin over bar\",\"tips\":\"Keep body tense, don\'t swing\",\"difficultyLevel\":\"BEGINNER\",\"muscleGroupId\":' + $backId + ',\"equipmentId\":' + $pullupId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Pull-up template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pullup_template.json' } catch { Write-Host 'Error creating pull-up template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Dumbbell Press template...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $shouldersId = (Get-Content shoulders_muscle_group.json | ConvertFrom-Json).id; $dumbbellsId = (Get-Content dumbbells_equipment.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Dumbbell Press\",\"description\":\"Exercise for deltoid muscles\",\"instructions\":\"Stand straight, raise dumbbells to shoulders, press up\",\"tips\":\"Keep core tense, don\'t arch lower back\",\"difficultyLevel\":\"BEGINNER\",\"muscleGroupId\":' + $shouldersId + ',\"equipmentId\":' + $dumbbellsId + '}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercise-templates' -Method POST -Headers $headers -Body $body; Write-Host 'Dumbbell Press template created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'dumbbell_press_template.json' } catch { Write-Host 'Error creating dumbbell press template:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 5. Creating Workouts
echo ========================================
echo Creating Push Workout (Chest, Shoulders, Triceps)...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Push Workout\",\"description\":\"Push muscles workout\",\"dayOfWeek\":\"MONDAY\",\"weeksCount\":4,\"startDate\":\"2025-08-19\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Push Workout created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'push_workout.json' } catch { Write-Host 'Error creating push workout:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Pull Workout (Back, Biceps)...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Pull Workout\",\"description\":\"Pull muscles workout\",\"dayOfWeek\":\"WEDNESDAY\",\"weeksCount\":4,\"startDate\":\"2025-08-19\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Pull Workout created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pull_workout.json' } catch { Write-Host 'Error creating pull workout:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Legs Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Legs Workout\",\"description\":\"Leg muscles workout\",\"dayOfWeek\":\"FRIDAY\",\"weeksCount\":4,\"startDate\":\"2025-08-19\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/workouts' -Method POST -Headers $headers -Body $body; Write-Host 'Legs Workout created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'legs_workout.json' } catch { Write-Host 'Error creating legs workout:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 6. Creating Exercises in Workouts
echo ========================================
echo Adding Bench Press to Push Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $pushWorkoutId = (Get-Content push_workout.json | ConvertFrom-Json).id; $benchPressTemplateId = (Get-Content bench_press_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Bench Press\",\"description\":\"Compound exercise for chest muscles\",\"sets\":4,\"reps\":8,\"weight\":60.0,\"workoutId\":' + $pushWorkoutId + ',\"exerciseTemplateId\":' + $benchPressTemplateId + ',\"restTime\":120}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Bench Press exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_press_exercise.json' } catch { Write-Host 'Error creating bench press exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Adding Dumbbell Press to Push Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $pushWorkoutId = (Get-Content push_workout.json | ConvertFrom-Json).id; $dumbbellPressTemplateId = (Get-Content dumbbell_press_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Dumbbell Press\",\"description\":\"Exercise for deltoid muscles\",\"sets\":3,\"reps\":12,\"weight\":20.0,\"workoutId\":' + $pushWorkoutId + ',\"exerciseTemplateId\":' + $dumbbellPressTemplateId + ',\"restTime\":90}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Dumbbell Press exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'dumbbell_press_exercise.json' } catch { Write-Host 'Error creating dumbbell press exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Adding Squat to Legs Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $legsWorkoutId = (Get-Content legs_workout.json | ConvertFrom-Json).id; $squatTemplateId = (Get-Content squat_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Barbell Squat\",\"description\":\"Compound exercise for leg muscles\",\"sets\":4,\"reps\":6,\"weight\":80.0,\"workoutId\":' + $legsWorkoutId + ',\"exerciseTemplateId\":' + $squatTemplateId + ',\"restTime\":180}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Squat exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'squat_exercise.json' } catch { Write-Host 'Error creating squat exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Adding Pull-up to Pull Workout...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $pullWorkoutId = (Get-Content pull_workout.json | ConvertFrom-Json).id; $pullupTemplateId = (Get-Content pullup_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"name\":\"Pull-up\",\"description\":\"Compound exercise for back muscles\",\"sets\":3,\"reps\":8,\"weight\":0.0,\"workoutId\":' + $pullWorkoutId + ',\"exerciseTemplateId\":' + $pullupTemplateId + ',\"restTime\":120}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/exercises' -Method POST -Headers $headers -Body $body; Write-Host 'Pull-up exercise created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'pullup_exercise.json' } catch { Write-Host 'Error creating pull-up exercise:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 7. Creating Progressions
echo ========================================
echo Creating Bench Press progression...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $benchPressExerciseId = (Get-Content bench_press_exercise.json | ConvertFrom-Json).id; $benchPressTemplateId = (Get-Content bench_press_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"exerciseId\":' + $benchPressExerciseId + ',\"exerciseTemplateId\":' + $benchPressTemplateId + ',\"weeksCount\":4,\"startDate\":\"2025-08-19\",\"weightProgressionEnabled\":true,\"repsProgressionEnabled\":false,\"setsProgressionEnabled\":false,\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":2.5,\"weightPeriodicity\":\"EVERY_WORKOUT\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/progressions' -Method POST -Headers $headers -Body $body; Write-Host 'Bench Press progression created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'bench_press_progression.json' } catch { Write-Host 'Error creating bench press progression:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo Creating Squat progression...
powershell -ExecutionPolicy Bypass -Command "$token = Get-Content jwt_token_simple.txt -Raw; $token = $token.Trim(); $squatExerciseId = (Get-Content squat_exercise.json | ConvertFrom-Json).id; $squatTemplateId = (Get-Content squat_template.json | ConvertFrom-Json).id; $headers = @{ 'Authorization' = 'Bearer ' + $token; 'Content-Type' = 'application/json' }; $body = '{\"exerciseId\":' + $squatExerciseId + ',\"exerciseTemplateId\":' + $squatTemplateId + ',\"weeksCount\":4,\"startDate\":\"2025-08-19\",\"weightProgressionEnabled\":true,\"repsProgressionEnabled\":false,\"setsProgressionEnabled\":false,\"weightIncrementType\":\"INCREMENT\",\"weightIncrementValue\":5.0,\"weightPeriodicity\":\"EVERY_WORKOUT\"}'; try { $response = Invoke-WebRequest -Uri 'http://localhost:8080/api/progressions' -Method POST -Headers $headers -Body $body; Write-Host 'Squat progression created with ID: ' + ($response.Content | ConvertFrom-Json).id -ForegroundColor Green; $response.Content | ConvertFrom-Json | ConvertTo-Json | Out-File -FilePath 'squat_progression.json' } catch { Write-Host 'Error creating squat progression:' -ForegroundColor Red; Write-Host $_.Exception.Message -ForegroundColor Red }"

echo.
echo ========================================
echo 8. Summary of Created Data
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
echo.
echo All data files saved to JSON files for reference
echo.
echo ========================================
echo Simple Test Data Creation Completed!
echo ========================================
pause
