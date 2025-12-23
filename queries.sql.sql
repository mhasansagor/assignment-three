SELECT 
    b.booking_id,
    b.start_date,
    b.end_date,
    b.status,
    b.total_cost,
    u.name AS customer_name,
    v.name AS vehicle_name
FROM 
    Bookings b
INNER JOIN 
    Users u ON b.user_id = u.user_id
INNER JOIN 
    Vehicles v ON b.vehicle_id = v.vehicle_id;

SELECT 
    v.*
FROM 
    Vehicles v
WHERE 
    NOT EXISTS (
        SELECT 1
        FROM Bookings b
        WHERE b.vehicle_id = v.vehicle_id
    );

SELECT 
    *
FROM 
    Vehicles
WHERE 
    type = 'car' AND availability_status = 'available';

SELECT 
    v.vehicle_id,
    v.name,
    COUNT(b.booking_id) AS booking_count
FROM 
    Vehicles v
JOIN 
    Bookings b ON v.vehicle_id = b.vehicle_id
GROUP BY 
    v.vehicle_id, v.name
HAVING 
    COUNT(b.booking_id) > 2;

CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    user_role ENUM('Admin', 'Customer') NOT NULL,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    phone_number VARCHAR(20)
);

CREATE TABLE Vehicles (
    vehicle_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    type ENUM('car', 'bike', 'truck') NOT NULL,
    model VARCHAR(50) NOT NULL,
    registration_number VARCHAR(20) NOT NULL UNIQUE,
    rental_price_per_day DECIMAL(10, 2) NOT NULL,
    availability_status ENUM('available', 'rented', 'maintenance') NOT NULL DEFAULT 'available'
);

CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    vehicle_id INT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status ENUM('pending', 'confirmed', 'completed', 'cancelled') NOT NULL DEFAULT 'pending',
    total_cost DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (user_id) REFERENCES Users(user_id),
    FOREIGN KEY (vehicle_id) REFERENCES Vehicles(vehicle_id)
);