package com.exemple.repository;

import org.springframework.data.repository.CrudRepository;
import org.springframework.stereotype.Repository;
import org.springframework.data.jpa.repository.JpaRepository;
import com.exemple.model.ThemeParkRide;

import java.util.List;

@Repository
public interface ThemeParkRideRepository extends JpaRepository<ThemeParkRide, Long> {
	List<ThemeParkRide> findByName(String name);
}