package com.workout.dto;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import java.time.LocalDateTime;
import java.util.List;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class WorkoutDto {
    private Long id;
    private String name;
    private String description;
    private List<ExerciseDto> exercises;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
