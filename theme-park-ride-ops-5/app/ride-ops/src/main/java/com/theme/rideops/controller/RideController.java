package com.theme.rideops.controller;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/rides")
public class RideController {

    @GetMapping
    public String getAllRides() {
        return "List of all rides";
    }

    // Additional endpoints for ride operations can be added here
}