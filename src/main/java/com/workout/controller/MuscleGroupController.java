package com.workout.controller;

import com.workout.dto.MuscleGroupDto;
import com.workout.entity.MuscleGroup;
import com.workout.service.MuscleGroupService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/muscle-groups")
@RequiredArgsConstructor
public class MuscleGroupController {
    
    private final MuscleGroupService muscleGroupService;
    
    /**
     * Получить все активные группы мышц
     */
    @GetMapping
    public ResponseEntity<List<MuscleGroupDto>> getAllActiveMuscleGroups() {
        List<MuscleGroupDto> muscleGroups = muscleGroupService.getAllActiveMuscleGroups();
        return ResponseEntity.ok(muscleGroups);
    }
    
    /**
     * Получить группу мышц по ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<MuscleGroupDto> getMuscleGroupById(@PathVariable Long id) {
        MuscleGroupDto muscleGroup = muscleGroupService.getMuscleGroupById(id);
        return ResponseEntity.ok(muscleGroup);
    }
    
    /**
     * Получить группы мышц с упражнениями
     */
    @GetMapping("/with-exercises")
    public ResponseEntity<List<MuscleGroupDto>> getMuscleGroupsWithExercises() {
        List<MuscleGroupDto> muscleGroups = muscleGroupService.getMuscleGroupsWithExercises();
        return ResponseEntity.ok(muscleGroups);
    }
    
    /**
     * Создать новую группу мышц
     */
    @PostMapping
    public ResponseEntity<MuscleGroupDto> createMuscleGroup(@Valid @RequestBody MuscleGroupDto muscleGroupDto) {
        MuscleGroupDto created = muscleGroupService.createMuscleGroup(muscleGroupDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    /**
     * Обновить группу мышц
     */
    @PutMapping("/{id}")
    public ResponseEntity<MuscleGroupDto> updateMuscleGroup(
            @PathVariable Long id, 
            @Valid @RequestBody MuscleGroupDto muscleGroupDto) {
        MuscleGroupDto updated = muscleGroupService.updateMuscleGroup(id, muscleGroupDto);
        return ResponseEntity.ok(updated);
    }
    
    /**
     * Деактивировать группу мышц
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deactivateMuscleGroup(@PathVariable Long id) {
        muscleGroupService.deactivateMuscleGroup(id);
        return ResponseEntity.noContent().build();
    }
    
    /**
     * Активировать группу мышц
     */
    @PatchMapping("/{id}/activate")
    public ResponseEntity<MuscleGroupDto> activateMuscleGroup(@PathVariable Long id) {
        MuscleGroupDto activated = muscleGroupService.activateMuscleGroup(id);
        return ResponseEntity.ok(activated);
    }
}
