-- Create database
CREATE DATABASE IF NOT EXISTS `VC_Smashers_CourtHubDB`
  DEFAULT CHARACTER SET = utf8mb4
  DEFAULT COLLATE = utf8mb4_unicode_ci;
USE `VC_Smashers_CourtHubDB`;

-- ==============================
-- Roles
-- ==============================
CREATE TABLE IF NOT EXISTS `roles` (
  `role_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `rolename` VARCHAR(100) NOT NULL DEFAULT 'USER', -- ADMIN, USER
  PRIMARY KEY (`role_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Users
-- ==============================
CREATE TABLE IF NOT EXISTS `users` (
  `user_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `role_id` INT UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL UNIQUE,
  `phone` VARCHAR(20) DEFAULT NULL,
  `pass` VARCHAR(255) NOT NULL,
  `profile_pic` VARCHAR(255) NULL,
  `created_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`user_id`),
  CONSTRAINT `fk_users_role` FOREIGN KEY (`role_id`) 
    REFERENCES `roles`(`role_id`) 
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Bookings
-- ==============================
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `title` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `activity_name` VARCHAR(255) NOT NULL, -- Pickleball / Badminton
  `court_number` INT NOT NULL, -- 1,2,3
  `num_of_participants` INT NOT NULL,
  `fee_per_head` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `total_fee` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `event_date` DATE NOT NULL,
  `event_time` TIME NOT NULL,
  `event_end_time` TIME NOT NULL,
  `booking_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `status` VARCHAR(50) DEFAULT 'PENDING', -- PENDING, CONFIRMED, CANCELLED
  PRIMARY KEY (`booking_id`),
  CONSTRAINT `fk_bookings_user` FOREIGN KEY (`user_id`) 
    REFERENCES `users`(`user_id`) 
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Tournaments
-- ==============================
CREATE TABLE IF NOT EXISTS `tournaments` (
  `tournament_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `tournament_name` VARCHAR(255) NOT NULL,
  `description` TEXT,
  `start_datetime` DATETIME NOT NULL,
  `end_date` DATE NOT NULL,
  `max_participants` INT NOT NULL,
  `entry_fee` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `status` VARCHAR(100) DEFAULT 'SCHEDULED', -- SCHEDULED, IN PROGRESS, FINISHED, CANCELED 
  PRIMARY KEY (`tournament_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Tournament Registrations
-- ==============================
CREATE TABLE IF NOT EXISTS `tournament_registrations` (
  `registration_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT UNSIGNED NOT NULL,
  `tournament_id` INT UNSIGNED NOT NULL,
  `registration_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `fee` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `status` VARCHAR(100) DEFAULT 'PENDING', -- PENDING, CONFIRMED, CANCELLED
  PRIMARY KEY (`registration_id`),
  CONSTRAINT `fk_reg_user` FOREIGN KEY (`user_id`) 
    REFERENCES `users`(`user_id`) 
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_reg_tournament` FOREIGN KEY (`tournament_id`) 
    REFERENCES `tournaments`(`tournament_id`) 
    ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Payments
-- ==============================
CREATE TABLE IF NOT EXISTS `payments` (
  `payment_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `booking_id` INT UNSIGNED DEFAULT NULL,
  `registration_id` INT UNSIGNED DEFAULT NULL,
  `amount` DECIMAL(10,2) NOT NULL DEFAULT 0.00,
  `payment_timestamp` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `transaction_id` VARCHAR(255) DEFAULT NULL,
  `status` VARCHAR(50) DEFAULT 'UNPAID', -- UNPAID, PAID, REFUNDED
  PRIMARY KEY (`payment_id`),
  CONSTRAINT `fk_payment_booking` FOREIGN KEY (`booking_id`) 
    REFERENCES `bookings`(`booking_id`) 
    ON DELETE SET NULL ON UPDATE CASCADE,
  CONSTRAINT `fk_payment_registration` FOREIGN KEY (`registration_id`) 
    REFERENCES `tournament_registrations`(`registration_id`) 
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Virtual Tickets (linked via Payments)
-- ==============================
CREATE TABLE IF NOT EXISTS `virtual_tickets` (
  `ticket_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `payment_id` INT UNSIGNED NOT NULL,
  `user_id` INT UNSIGNED DEFAULT NULL,     -- booking owner or tournament registrant
  `guest_name` VARCHAR(255) DEFAULT NULL,  -- for additional participants
  `qr_code` VARCHAR(255) NOT NULL UNIQUE,
  `issued_at` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `is_used` TINYINT(1) NOT NULL DEFAULT 0,
  `checked_in_at` TIMESTAMP NULL DEFAULT NULL,
  PRIMARY KEY (`ticket_id`),
  CONSTRAINT `fk_ticket_payment` FOREIGN KEY (`payment_id`) 
    REFERENCES `payments`(`payment_id`) 
    ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_ticket_user` FOREIGN KEY (`user_id`) 
    REFERENCES `users`(`user_id`) 
    ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- FAQs
-- ==============================
CREATE TABLE IF NOT EXISTS `faqs` (
  `faq_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `question` TEXT NOT NULL,
  `answer` TEXT DEFAULT NULL,
  PRIMARY KEY (`faq_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Contact Submissions
-- ==============================
CREATE TABLE IF NOT EXISTS `contact_submissions` (
  `submission_id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `message` TEXT NOT NULL,
  `submission_date` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`submission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ==============================
-- Transactions - K
-- ==============================
CREATE TABLE IF NOT EXISTS transactions (
  id INT AUTO_INCREMENT PRIMARY KEY,
  payment_intent_id VARCHAR(100) NOT NULL,
  name VARCHAR(100) NOT NULL,
  email VARCHAR(150) NOT NULL,
  contact_number VARCHAR(30) NULL,
  amount DECIMAL(10,2) NOT NULL,
  currency VARCHAR(10) DEFAULT 'PHP',
  description VARCHAR(255),
  status VARCHAR(50) DEFAULT 'pending',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
