package com.workout.controller;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import lombok.extern.slf4j.Slf4j;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;
import com.workout.dto.WorkoutDto;

@Slf4j
@RestController
@RequestMapping("/")
public class TestController {

    @GetMapping("/health")
    public ResponseEntity<Map<String, Object>> health() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "UP");
        response.put("timestamp", LocalDateTime.now());
        response.put("service", "Workout Backend");
        response.put("version", "1.0.0");
        return ResponseEntity.ok(response);
    }

    @GetMapping("/")
    public ResponseEntity<String> home() {
        return ResponseEntity.ok("Workout Backend API is running!");
    }
    
    @PostMapping("/test-json")
    public ResponseEntity<Map<String, Object>> testJson(@RequestBody Map<String, Object> data) {
        log.info("=== TEST JSON ENDPOINT ===");
        log.info("Received data: {}", data);
        log.info("Data type: {}", data.getClass().getName());
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("received", data);
        response.put("timestamp", LocalDateTime.now());
        response.put("message", "JSON parsed successfully");
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/test-workout-dto")
    public ResponseEntity<Map<String, Object>> testWorkoutDto(@RequestBody WorkoutDto workoutDto) {
        log.info("=== TEST WORKOUT DTO ENDPOINT ===");
        log.info("Received WorkoutDto: {}", workoutDto);
        log.info("DTO class: {}", workoutDto.getClass().getName());
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("received", workoutDto);
        response.put("timestamp", LocalDateTime.now());
        response.put("message", "WorkoutDto parsed successfully");
        
        return ResponseEntity.ok(response);
    }
    
    @PostMapping("/test-raw-json")
    public ResponseEntity<Map<String, Object>> testRawJson(@RequestBody String rawJson) {
        log.info("=== TEST RAW JSON ENDPOINT ===");
        log.info("Received raw JSON: {}", rawJson);
        log.info("JSON length: {}", rawJson.length());
        log.info("JSON class: {}", rawJson.getClass().getName());
        
        Map<String, Object> response = new HashMap<>();
        response.put("status", "success");
        response.put("received", rawJson);
        response.put("timestamp", LocalDateTime.now());
        response.put("message", "Raw JSON received successfully");
        
        return ResponseEntity.ok(response);
    }
}
