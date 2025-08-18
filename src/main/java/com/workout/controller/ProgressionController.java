package com.workout.controller;

import com.workout.dto.ProgressionDto;
import com.workout.entity.User;
import com.workout.service.ProgressionService;
import com.workout.service.UserService;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;
import jakarta.validation.Valid;
import java.util.List;

@RestController
@RequestMapping("/api/progressions")
@CrossOrigin(origins = "*")
public class ProgressionController extends BaseController {
    
    private final ProgressionService progressionService;
    
    public ProgressionController(ProgressionService progressionService, UserService userService) {
        super(userService);
        this.progressionService = progressionService;
    }
    
    @GetMapping
    public ResponseEntity<List<ProgressionDto>> getProgressions(@RequestParam Long exerciseId, 
                                                              @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        // TODO: Добавить проверку доступа к упражнению
        List<ProgressionDto> progressions = progressionService.getProgressionsByExerciseId(exerciseId);
        return ResponseEntity.ok(progressions);
    }
    
    @PostMapping
    public ResponseEntity<ProgressionDto> createProgression(@Valid @RequestBody ProgressionDto progressionDto,
                                                          @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        // TODO: Добавить проверку доступа к упражнению
        ProgressionDto createdProgression = progressionService.createProgression(progressionDto);
        return ResponseEntity.ok(createdProgression);
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ProgressionDto> updateProgression(@PathVariable Long id,
                                                          @Valid @RequestBody ProgressionDto progressionDto,
                                                          @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        // TODO: Добавить проверку доступа к прогрессии
        ProgressionDto updatedProgression = progressionService.updateProgression(id, progressionDto);
        return ResponseEntity.ok(updatedProgression);
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteProgression(@PathVariable Long id, @AuthenticationPrincipal Jwt jwt) {
        User user = getCurrentUser(jwt);
        // TODO: Добавить проверку доступа к прогрессии
        progressionService.deleteProgression(id);
        return ResponseEntity.noContent().build();
    }
}
