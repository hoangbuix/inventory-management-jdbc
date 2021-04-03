package com.hoangbuix.dev.controller;

import com.hoangbuix.dev.entity.UserEntity;
import com.hoangbuix.dev.entity.UserRoleEntity;
import com.hoangbuix.dev.service.UserRoleService;
import com.hoangbuix.dev.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.List;

@RestController
public class UserController {
    @Autowired
    private UserService userService;

    @Autowired
    private UserRoleService userRoleService;

    @GetMapping("/user-role")
    public List<UserRoleEntity> getAllUserRole(){
        return userRoleService.findAll();
    }


    @GetMapping("/user/find-by-id/{id}")
    public UserEntity getUserById(@PathVariable int id){
        UserEntity user = userService.findById(id);
        return user;
    }

    @GetMapping("/user/find-by-username/{username}")
    public UserEntity getUserByUsername(@PathVariable String username){
        UserEntity user = userService.findUserByUsername(username);
        return user;
    }

    @GetMapping("/user")
    public List<UserEntity> getAllUser(){
        return userService.getAllUser();
    }

    @PostMapping("/user/save")
    public ResponseEntity<?> saveUser(@Valid @RequestBody UserEntity req){
        UserEntity result = userService.saveUser(req);
        return new ResponseEntity<>(result, HttpStatus.OK);
    }
}
