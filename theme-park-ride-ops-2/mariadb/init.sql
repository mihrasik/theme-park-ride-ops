-- Create the database
CREATE DATABASE theme_park_ride_ops;

-- Use the newly created database
USE theme_park_ride_ops;

-- Create tables for the application
CREATE TABLE rides (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    status ENUM('operational', 'maintenance', 'closed') NOT NULL
);

CREATE TABLE visitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    visit_date DATE NOT NULL
);

CREATE TABLE ride_visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ride_id INT NOT NULL,
    visitor_id INT NOT NULL,
    visit_time DATETIME NOT NULL,
    FOREIGN KEY (ride_id) REFERENCES rides(id),
    FOREIGN KEY (visitor_id) REFERENCES visitors(id)
);

-- Insert initial data
INSERT INTO rides (name, type, capacity, status) VALUES
('Ferris Wheel', 'Observation', 40, 'operational'),
('Roller Coaster', 'Thrill', 24, 'operational'),
('Bumper Cars', 'Family', 20, 'operational');

INSERT INTO visitors (name, age, visit_date) VALUES
('Alice', 30, '2023-10-01'),
('Bob', 25, '2023-10-01'),
('Charlie', 35, '2023-10-01');