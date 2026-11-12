-- database/queries.sql — контрольные запросы
USE service_quality;
SET NAMES utf8mb4;

-- 1. JOIN трёх таблиц: список отзывов с email клиента и названием услуги (ФТ-08)
SELECT r.id, u.email AS client_email, s.name AS service_name, r.rating, r.text
FROM reviews r
JOIN users u ON u.id = r.user_id
JOIN services s ON s.id = r.service_id
ORDER BY r.created_at DESC;

-- 2. Поиск по началу названия услуги через LIKE (ФТ-03)
SELECT id, name, description FROM services WHERE name LIKE 'Стрижка%';

-- 3. GROUP BY + COUNT: количество отзывов по каждой услуге (ФТ-10)
SELECT s.name AS service_name, COUNT(r.id) AS review_count
FROM services s
LEFT JOIN reviews r ON r.service_id = s.id
GROUP BY s.id, s.name
ORDER BY review_count DESC;

-- 4. LEFT JOIN: все сотрудники и их аккаунты (показывает и тех, у кого нет аккаунта) (ФТ-11)
SELECT e.last_name, e.first_name, e.position, u.email
FROM employees e
LEFT JOIN users u ON u.id = e.user_id;

-- 5. Фильтр по категории: услуги категории "Косметология" (ФТ-09)
SELECT s.name, c.name AS category
FROM services s
JOIN service_categories c ON c.id = s.category_id
WHERE c.name = 'Косметология' AND s.is_active = 1;

-- 6. Пагинация: вторая страница услуг по 2 записи (ФТ-03)
SELECT id, name FROM services
ORDER BY id
LIMIT 2 OFFSET 2;