package com.workout.controller;

import com.workout.entity.User;
import com.workout.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.oauth2.jwt.Jwt;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/users")
public class UserController extends BaseController {

    private final com.workout.repository.UserRepository userRepository;

    public UserController(UserService userService, com.workout.repository.UserRepository userRepository) {
        super(userService);
        this.userRepository = userRepository;
    }

    @GetMapping
    public ResponseEntity<List<User>> getUsers(@AuthenticationPrincipal Jwt jwt) {
        // В dev/debug режиме вернем всех пользователей для удобства
        List<User> users = userRepository.findAll();
        return ResponseEntity.ok(users);
    }
}


