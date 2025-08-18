package com.workout.controller;

import com.workout.dto.EquipmentDto;
import com.workout.entity.Equipment;
import com.workout.service.EquipmentService;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/equipment")
@RequiredArgsConstructor
public class EquipmentController {
    
    private final EquipmentService equipmentService;
    
    /**
     * Получить все активное оборудование
     */
    @GetMapping
    public ResponseEntity<List<EquipmentDto>> getAllActiveEquipment() {
        List<EquipmentDto> equipment = equipmentService.getAllActiveEquipment();
        return ResponseEntity.ok(equipment);
    }
    
    /**
     * Получить оборудование по ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<EquipmentDto> getEquipmentById(@PathVariable Long id) {
        EquipmentDto equipment = equipmentService.getEquipmentById(id);
        return ResponseEntity.ok(equipment);
    }
    
    /**
     * Получить оборудование по типу
     */
    @GetMapping("/type/{type}")
    public ResponseEntity<List<EquipmentDto>> getEquipmentByType(@PathVariable String type) {
        List<EquipmentDto> equipment = equipmentService.getEquipmentByType(type);
        return ResponseEntity.ok(equipment);
    }
    
    /**
     * Получить оборудование с упражнениями
     */
    @GetMapping("/with-exercises")
    public ResponseEntity<List<EquipmentDto>> getEquipmentWithExercises() {
        List<EquipmentDto> equipment = equipmentService.getEquipmentWithExercises();
        return ResponseEntity.ok(equipment);
    }
    
    /**
     * Создать новое оборудование
     */
    @PostMapping
    public ResponseEntity<EquipmentDto> createEquipment(@Valid @RequestBody EquipmentDto equipmentDto) {
        EquipmentDto created = equipmentService.createEquipment(equipmentDto);
        return ResponseEntity.status(HttpStatus.CREATED).body(created);
    }
    
    /**
     * Обновить оборудование
     */
    @PutMapping("/{id}")
    public ResponseEntity<EquipmentDto> updateEquipment(
            @PathVariable Long id, 
            @Valid @RequestBody EquipmentDto equipmentDto) {
        EquipmentDto updated = equipmentService.updateEquipment(id, equipmentDto);
        return ResponseEntity.ok(updated);
    }
    
    /**
     * Деактивировать оборудование
     */
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deactivateEquipment(@PathVariable Long id) {
        equipmentService.deactivateEquipment(id);
        return ResponseEntity.noContent().build();
    }
    
    /**
     * Активировать оборудование
     */
    @PatchMapping("/{id}/activate")
    public ResponseEntity<EquipmentDto> activateEquipment(@PathVariable Long id) {
        EquipmentDto activated = equipmentService.activateEquipment(id);
        return ResponseEntity.ok(activated);
    }
}
