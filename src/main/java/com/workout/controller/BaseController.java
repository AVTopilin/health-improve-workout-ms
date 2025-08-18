package com.workout.controller;

import com.workout.entity.User;
import com.workout.service.UserService;
import org.springframework.security.oauth2.jwt.Jwt;

public abstract class BaseController {
    
    protected final UserService userService;
    
    protected BaseController(UserService userService) {
        this.userService = userService;
    }
    
    protected User getCurrentUser(Jwt jwt) {
        if (jwt == null) {
            // В dev режиме создаем тестового пользователя
            return userService.findByKeycloakId("dev-user")
                    .orElseGet(() -> userService.createUser("dev-user", "dev@example.com", "dev-user"));
        }
        
        String keycloakId = jwt.getSubject();
        return userService.findByKeycloakId(keycloakId)
                .orElseGet(() -> {
                    String username = jwt.getClaimAsString("preferred_username");
                    String email = jwt.getClaimAsString("email");
                    return userService.createUser(username, email, keycloakId);
                });
    }
}
