-- database/schema.sql — физическая модель service_quality
DROP DATABASE IF EXISTS service_quality;
CREATE DATABASE service_quality
  CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE service_quality;
SET NAMES utf8mb4;

-- 1. Справочник категорий услуг
CREATE TABLE service_categories (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(100) NOT NULL,
  description TEXT NULL,
  CONSTRAINT uq_categories_name UNIQUE (name)
) ENGINE=InnoDB;

-- 2. Услуги
CREATE TABLE services (
  id          INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NOT NULL,
  name        VARCHAR(150) NOT NULL,
  description TEXT NULL,
  is_active   TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT fk_services_category FOREIGN KEY (category_id)
    REFERENCES service_categories(id) ON DELETE RESTRICT ON UPDATE CASCADE,
  INDEX idx_services_category (category_id)
) ENGINE=InnoDB;

-- 3. Пользователи (клиенты, менеджеры, админы)
CREATE TABLE users (
  id            INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  email         VARCHAR(120) NOT NULL,
  password_hash VARCHAR(255) NOT NULL,
  role          ENUM('client', 'manager', 'employee', 'admin') NOT NULL,
  is_active     TINYINT(1) NOT NULL DEFAULT 1,
  CONSTRAINT uq_users_email UNIQUE (email)
) ENGINE=InnoDB;

-- 4. Сотрудники (мастера, исполнители)
CREATE TABLE employees (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  last_name  VARCHAR(60) NOT NULL,
  first_name VARCHAR(60) NOT NULL,
  position   VARCHAR(100) NOT NULL,
  user_id    INT UNSIGNED NULL,
  CONSTRAINT uq_employees_user UNIQUE (user_id),
  CONSTRAINT fk_employees_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB;

-- 5. Отзывы (основная таблица)
CREATE TABLE reviews (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    INT UNSIGNED NOT NULL,
  service_id INT UNSIGNED NOT NULL,
  rating     INT NOT NULL,
  text       TEXT NULL,
  created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_reviews_rating CHECK (rating >= 1 AND rating <= 5),
  CONSTRAINT fk_reviews_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_reviews_service FOREIGN KEY (service_id)
    REFERENCES services(id) ON DELETE CASCADE ON UPDATE CASCADE,
  INDEX idx_reviews_service (service_id)
) ENGINE=InnoDB;

-- 6. Избранное (связь M:N)
CREATE TABLE favorites (
  id         INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  user_id    INT UNSIGNED NOT NULL,
  service_id INT UNSIGNED NOT NULL,
  CONSTRAINT uq_favorites_user_service UNIQUE (user_id, service_id),
  CONSTRAINT fk_favorites_user FOREIGN KEY (user_id)
    REFERENCES users(id) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT fk_favorites_service FOREIGN KEY (service_id)
    REFERENCES services(id) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB;