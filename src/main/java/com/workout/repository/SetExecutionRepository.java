package com.workout.repository;

import com.workout.entity.SetExecution;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface SetExecutionRepository extends JpaRepository<SetExecution, Long> {
}
