CREATE TABLE rides (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    capacity INT NOT NULL,
    duration INT NOT NULL,
    status ENUM('operational', 'maintenance', 'closed') DEFAULT 'operational'
);

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE bookings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ride_id INT NOT NULL,
    booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (ride_id) REFERENCES rides(id)
);

INSERT INTO rides (name, description, capacity, duration, status) VALUES
('Roller Coaster', 'A thrilling roller coaster ride.', 24, 120, 'operational'),
('Ferris Wheel', 'A giant wheel offering a great view.', 40, 300, 'operational'),
('Haunted House', 'A spooky haunted house experience.', 10, 180, 'operational');

INSERT INTO users (username, password, email) VALUES
('admin', 'admin_password', 'admin@example.com'),
('user1', 'user1_password', 'user1@example.com');