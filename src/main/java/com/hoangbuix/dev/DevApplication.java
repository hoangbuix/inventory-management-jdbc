package com.hoangbuix.dev;

import lombok.RequiredArgsConstructor;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@RequiredArgsConstructor
public class DevApplication {
    public static void main(String[] args) {
        SpringApplication.run(DevApplication.class, args);
    }

}
