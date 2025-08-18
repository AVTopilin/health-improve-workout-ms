package com.workout.service;

import com.workout.entity.User;
import com.workout.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.Optional;

@Service
@RequiredArgsConstructor
public class UserService {
    
    private final UserRepository userRepository;
    
    public User createUser(String username, String email, String keycloakId) {
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setKeycloakId(keycloakId);
        return userRepository.save(user);
    }
    
    public Optional<User> findByKeycloakId(String keycloakId) {
        return userRepository.findByKeycloakId(keycloakId);
    }
    
    public Optional<User> findByUsername(String username) {
        return userRepository.findByUsername(username);
    }
    
    public User saveUser(User user) {
        return userRepository.save(user);
    }
}
