CREATE TABLE rides (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    type VARCHAR(100) NOT NULL,
    capacity INT NOT NULL,
    duration INT NOT NULL,
    status ENUM('operational', 'maintenance', 'closed') NOT NULL DEFAULT 'operational'
);

CREATE TABLE visitors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INT NOT NULL,
    email VARCHAR(255) UNIQUE NOT NULL,
    visit_date DATE NOT NULL
);

CREATE TABLE ride_visits (
    id INT AUTO_INCREMENT PRIMARY KEY,
    visitor_id INT NOT NULL,
    ride_id INT NOT NULL,
    visit_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (visitor_id) REFERENCES visitors(id),
    FOREIGN KEY (ride_id) REFERENCES rides(id)
);

INSERT INTO rides (name, type, capacity, duration, status) VALUES
('Ferris Wheel', 'Observation', 40, 10, 'operational'),
('Roller Coaster', 'Thrill', 24, 2, 'operational'),
('Haunted House', 'Dark Ride', 30, 5, 'operational');

INSERT INTO visitors (name, age, email, visit_date) VALUES
('John Doe', 30, 'john.doe@example.com', CURDATE()),
('Jane Smith', 25, 'jane.smith@example.com', CURDATE());