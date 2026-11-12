-- database/seed.sql — тестовые данные
USE service_quality;
SET NAMES utf8mb4;

-- 1. Справочник категорий (3 записи)
INSERT INTO service_categories (id, name, description) VALUES
  (1, 'Парикмахерские услуги', 'Стрижки, окрашивание, укладки'),
  (2, 'Косметология', 'Уход за лицом и телом'),
  (3, 'Массаж', 'Расслабляющий и лечебный массаж');

-- 2. Услуги (4 записи)
INSERT INTO services (id, category_id, name, description, is_active) VALUES
  (1, 1, 'Стрижка мужская', 'Классическая мужская стрижка', 1),
  (2, 1, 'Стрижка женская', 'Модельная женская стрижка', 1),
  (3, 2, 'Чистка лица', 'Комплексная ультразвуковая чистка', 1),
  (4, 3, 'Массаж спины', 'Расслабляющий массаж, 60 минут', 1);

-- 3. Сотрудники (3 записи)
INSERT INTO employees (id, last_name, first_name, position, user_id) VALUES
  (1, 'Рахимов', 'Фарход', 'Мастер-универсал', NULL),
  (2, 'Назарова', 'Мадина', 'Косметолог', NULL),
  (3, 'Гуломов', 'Джамшед', 'Массажист', NULL);

-- 4. Пользователи всех ролей (5 записей)
-- Хеш получен для пароля 'Secret123!' через password_hash() в PHP
INSERT INTO users (id, email, password_hash, role, is_active) VALUES
  (1, 'admin@service.tj', '$2y$10$UNkIFfDEqAOi7ySnyD6Y/eOwI/mKH3g0is1OYNEv4OkXNXk3XRGRC', 'admin', 1),
  (2, 'manager@service.tj', '$2y$10$UNkIFfDEqAOi7ySnyD6Y/eOwI/mKH3g0is1OYNEv4OkXNXk3XRGRC', 'manager', 1),
  (3, 'rahimov@service.tj', '$2y$10$UNkIFfDEqAOi7ySnyD6Y/eOwI/mKH3g0is1OYNEv4OkXNXk3XRGRC', 'employee', 1),
  (4, 'client1@mail.ru', '$2y$10$UNkIFfDEqAOi7ySnyD6Y/eOwI/mKH3g0is1OYNEv4OkXNXk3XRGRC', 'client', 1),
  (5, 'client2@mail.ru', '$2y$10$UNkIFfDEqAOi7ySnyD6Y/eOwI/mKH3g0is1OYNEv4OkXNXk3XRGRC', 'client', 1);

-- 5. Привязываем сотрудника Рахимова к его аккаунту (обновление)
UPDATE employees SET user_id = 3 WHERE id = 1;

-- 6. Отзывы (4 записи)
INSERT INTO reviews (user_id, service_id, rating, text, created_at) VALUES
  (4, 1, 5, 'Отличная стрижка, мастер Фарход всё сделал быстро и качественно!', '2023-10-15 14:30:00'),
  (4, 3, 4, 'Чистка прошла хорошо, но было немного больно в конце.', '2023-10-20 16:00:00'),
  (5, 2, 5, 'Очень довольна результатом, спасибо!', '2023-11-01 11:15:00'),
  (5, 4, 3, 'Массаж был неплохой, но в кабинете было прохладно.', '2023-11-05 18:00:00');

-- 7. Избранное (связь M:N, 3 записи)
INSERT INTO favorites (user_id, service_id) VALUES
  (4, 1),
  (4, 3),
  (5, 2);