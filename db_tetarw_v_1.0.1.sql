-- База данных: TETARW
-- Tracking Employee Time At Remote Work (отслеживание рабочего времени сотрудника на удаленной работ)
-- version 1.0.0
-- date of creation 02.02.2021 г.
-- 
/* ====================================================================================================
 * 1. Описание.
 * ====================================================================================================
 * База данных `tetarw` в совокупности со специализированным програмным обеспечением предназначена
 * для отслеживания времени, проведенного сотрудником организации, при удаленном выполнении обязанностей
 * в соответствии с трудовым договором и указаниями руководящего состава.
 * 
 * ==================================================================================================== 
 * 2. Задачи.
 * ====================================================================================================
 * 
 * Осуществление функций хранения данных:
 * - о сотруднике;
 * - о подразделениях организации и перечня долностей;
 * - регламента рабочего времени в подразделениях организации;
 * - о времени начала и окончания рабочего дня сотрудника;
 * - o наличии сотрудника на удаленном рабочем месте;
 * - о поставленных задачах сотруднику и сроках их выполнения;
 * - о програмном обеспечении, используемом сотрудником для выполнения поставленной задачи и времени 
 *   его использования;
 * - служебных сообщений, переданных (принятых) в служебном мессенжере;
 * - об использовании програмного обеспечения и действиях, запрещенных при выполнении обязанностей, 
 *   в соответствии с договором и указаниями руководящего состава;
 * - о причинах отсутствия сотрудника на удаленном рабочем месте.
 */
-- 
-- ===================================================================================================
-- 3. Создание базы данных
-- ===================================================================================================
DROP DATABASE IF EXISTS tetarw;
CREATE DATABASE tetarw;
USE tetarw;

-- ---------------------------------------------------------------------------------------------------
-- Таблица `employees` - сотрудники
-- ---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
	id SERIAL PRIMARY KEY,
	lastname VARCHAR(100) NOT NULL COMMENT 'Фамилия',
    firstname VARCHAR(100) DEFAULT NULL COMMENT 'Имя',
    middlename VARCHAR(100) DEFAULT NULL COMMENT 'Отчество', 
    staff_id BIGINT UNSIGNED NOT NULL COMMENT 'id занимаемой должности',
    email VARCHAR(100) UNIQUE,
    password_hash VARCHAR(100),
    phone BIGINT DEFAULT NULL,
    created_at DATETIME DEFAULT NOW(),    
    is_deleted BIT DEFAULT 0
);


-- ---------------------------------------------------------------------------------------------------
-- Таблица `working_ststus` - cтатус сотрудника
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS working_ststus;
CREATE TABLE working_ststus (
	employees_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	working_ststus ENUM('Прогул', 'Работает', 'Выходной', 'Отпуск', 'Болен', 'Командировка') NOT NULL,	
	PRIMARY KEY (employees_id, created_at) 
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `profiles` - профили сотрудников
-- ---------------------------------------------------------------------------------------------------

DROP TABLE IF EXISTS `profiles`;
CREATE TABLE `profiles` (
	employees_id SERIAL PRIMARY KEY,
    gender CHAR(1),
    birthday DATE,
    hometown VARCHAR(100),
    marital_status ENUM('unmarried', 'married') NOT NULL COMMENT 'Семейное положение',
    number_of_children TINYINT UNSIGNED COMMENT 'Количество детей',    
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW()        
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `staff_list` - штатно-должностной список организации
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `staff_list`;
CREATE TABLE `staff_list` (
	id SERIAL PRIMARY KEY,
	departament_id BIGINT UNSIGNED NOT NULL,	
    job_title VARCHAR(100) NOT NULL COMMENT 'Наименование должности'
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `department` - отделы организации
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `departament`;
CREATE TABLE `departament` (
	id SERIAL PRIMARY KEY,
    departament_name VARCHAR(100) NOT NULL COMMENT 'Наименование отдела',
    email VARCHAR(100) UNIQUE,
    office_hours JSON NOT NULL COMMENT 'Регламент служебного времени'
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `employees_admin` - допуск к администрированию
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS employees_admin;
CREATE TABLE employees_admin(
	staff_list_id BIGINT UNSIGNED NOT NULL,
	departament_id BIGINT UNSIGNED NOT NULL,
	access_level ENUM('1', '2', '3') NOT NULL COMMENT 'Допуск к администрированию',
	created_at DATETIME DEFAULT NOW(),
	PRIMARY KEY (staff_list_id, departament_id) 
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `messages` - сообщения
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS messages;
CREATE TABLE messages (
	id SERIAL PRIMARY KEY,
	from_employees_id BIGINT UNSIGNED NOT NULL,
    to_employees_id BIGINT UNSIGNED NOT NULL,
    body TEXT,
    created_at DATETIME DEFAULT NOW()
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `rest_break` - перерыв на отдых
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS rest_break;
CREATE TABLE rest_break(
	tasks_id BIGINT UNSIGNED NOT NULL,
	break_on DATETIME DEFAULT NOW(),
	break_of DATETIME ON UPDATE NOW(),	  
	PRIMARY KEY (tasks_id, break_on)    
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `tasks` - задачи
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks (
	id SERIAL PRIMARY KEY,
	from_employees_id BIGINT UNSIGNED NOT NULL,
    to_employees_id BIGINT UNSIGNED NOT NULL,    
    task_body TEXT,    
    created_at DATETIME DEFAULT NOW(), 
    data_completion DATETIME,
	completion_at DATETIME ON UPDATE NOW()   
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `software_block_list` - запрещенное к использованию ПО
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `sw_block_list`;
CREATE TABLE `sw_block_list`(
	id SERIAL PRIMARY KEY,
    software_name VARCHAR(255) NOT NULL,
    browser_url VARCHAR(255) DEFAULT NULL
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица `software_work` - используемое ПО
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS `software_work`;
CREATE TABLE `software_work`(	
	tasks_id BIGINT UNSIGNED NOT NULL,	
    software_name VARCHAR(255),
    browser_url VARCHAR(255) DEFAULT NULL,    
    created_at DATETIME DEFAULT NOW(),    
	completion_at DATETIME ON UPDATE NOW(),
	PRIMARY KEY (tasks_id, created_at)
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица media_types - используемые типы медиафайлов
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS media_types;
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255)    
);

-- ---------------------------------------------------------------------------------------------------
-- Таблица media - хранение информации о медиафайлах
-- ---------------------------------------------------------------------------------------------------
DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED,
    tasks_id BIGINT UNSIGNED,
    filename VARCHAR(255),
    url_add VARCHAR(255),
	metadata JSON,
    created_at DATETIME DEFAULT NOW()    
);


-- ==================================================================================================
-- 4. Добавление внешних ключей
-- ==================================================================================================

-- Внешний ключ с профиля сотрудника profiles
ALTER TABLE profiles 
-- (employees_id) на сотрудника employees(id)
ADD FOREIGN KEY (employees_id) REFERENCES employees(id) ON UPDATE CASCADE ON DELETE CASCADE,
-- (photo_id) на таблицу с информацией о медиафайлах media(id)
ADD FOREIGN KEY (photo_id) REFERENCES media(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ со статуса сотрудника working_ststus на сотрудника employees(id)
ALTER TABLE working_ststus 
ADD FOREIGN KEY (employees_id) REFERENCES employees(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ с сотрудника employees(staff_id) на занимаемую должность staff_list(id)
ALTER TABLE employees 
ADD FOREIGN KEY employees(staff_id) REFERENCES staff_list(id);

-- Внешний ключ с перечня должностей staff_list(departament_id) на отдел организации departament(id)
ALTER TABLE staff_list 
ADD FOREIGN KEY staff_list(departament_id) REFERENCES departament(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ с сотрудников с допуском к администрированию employees_admin
ALTER TABLE employees_admin
-- на занимаемую должность staff_list(id) 
ADD FOREIGN KEY (staff_list_id) REFERENCES staff_list(id) ON UPDATE CASCADE ON DELETE CASCADE,
-- на отдел организации departament(id)
ADD FOREIGN KEY (departament_id) REFERENCES departament(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ с месенжера сотрудников messages 
ALTER TABLE messages 
-- на сотрудника employees(id), отправителя сообщения 
ADD FOREIGN KEY (from_employees_id) REFERENCES employees(id) ON UPDATE CASCADE ON DELETE CASCADE,
-- на сотрудника employees(id), получателя сообщения 
ADD FOREIGN KEY (to_employees_id) REFERENCES employees(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ с таблицы с информацией о медиафайлах media(media_type_id) 
ALTER TABLE media 
-- на тип медиафайла media_type(id)
ADD FOREIGN KEY (media_type_id) REFERENCES media_types(id) ON UPDATE CASCADE ON DELETE CASCADE,
-- на выполняемую задачу
ADD FOREIGN KEY (tasks_id) REFERENCES tasks(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ с полученных задач tasks 
ALTER TABLE tasks 
-- на сотрудника employees(id), поставившего задачу
ADD FOREIGN KEY (from_employees_id) REFERENCES employees(id) ON UPDATE CASCADE ON DELETE CASCADE,
-- на сотрудника employees(id), получившего задачу 
ADD FOREIGN KEY (to_employees_id) REFERENCES employees(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний двойной ключ с перерывов rest_break на id задачи
ALTER TABLE rest_break 
ADD FOREIGN KEY (tasks_id) REFERENCES tasks(id) ON UPDATE CASCADE ON DELETE CASCADE;

-- Внешний ключ с используемого ПО software_work на выполняемую задачу tasks(id)
ALTER TABLE software_work 
ADD FOREIGN KEY (tasks_id) REFERENCES tasks(id);



-- ==================================================================================================
-- 5. Добавление индексов
-- ==================================================================================================

CREATE INDEX lastname_index
ON employees(lastname);


-- ==================================================================================================
--
-- ==================================================================================================


SELECT * FROM departament;
INSERT departament(id, departament_name, email, office_hours) 
VALUES
	(1, 'Сompany management', 'managers@gmail.com', '{"a": "123"}'),
	(2, 'Development department', 'developer@gmail.com', '{"a": "234"}'),
	(3, 'Testing department', 'test@gmail.com', '{"a": "345"}');

SELECT * FROM staff_list;
INSERT staff_list(id, departament_id, job_title) 
VALUES
	(1, 1, 'Chef Executive Officer'),
	(2, 1, 'Chef Technology Officer'),
	(3, 1, 'Project Manager'),
	(4, 1, 'Software Architect'),
	(5, 2, 'Team Lead'),
	(6, 2, 'Developer Senior'),
	(7, 2, 'Developer Middle'),
	(8, 2, 'Developer Junior'),
	(9, 3, 'Tech Lead'),
	(10, 3, 'QA Automation Engineer'),
	(11, 3, 'QA Engineer'),
	(12, 3, 'Technical Writers');

SELECT * FROM employees;
INSERT employees(lastname, firstname, middlename, staff_id, email, password_hash, phone) 
VALUES
	('Анохин', 'Сергей', 'Александрович', 1, 'anohin@mail.ru', 'AogfP4cmSJI1vc8lpXRW9', 9208764532),
	('Беляева', 'Софья', 'Дмитриевна', 2, 'belyaev@mail.ru', 'xB6GaHi4O0cEPtGYk4jD', 9168776542),
	('Аликов', 'Ярослав', 'Антонович', 3, 'alikov@mail.ru', 'SuQ1L3nV8YVpO3D5cagg', 9258743565),
	('Домбровский', 'Арсений', 'Александрович', 4, 'dombr@mail.ru', 'cTk4K48a0N7nxx6rf2x3', 9267658790),
	('Гоцко', 'Илья', 'Вячеславович', 5, 'gotcko@mail.ru', '05k8Do3I7Aq7jf7m3135', 9251234512),
	('Родькина', 'Марина', 'Ивановна', 7, 'rodkina@mail.ru', 'V85Vjx5AhpTRT0OD61Ua', 9251234513),
	('Сафонова', 'Александра', 'Александровна', 8, 'safonova@mail.ru', 'L8Oe02gyoe0132vt1d75', 9251234514),
	('Никифоров', 'Эдуард', 'Андреевич', 6, 'nikiforovn@mail.ru', '73UX875MqjE866ylXU4W', 9251234515),
	('Полонская', 'Елена', 'Сергеевна', 8, 'polonskaya@mail.ru', 'h5Dow021htOT1XH4WGWa', 9251234516),
	('Борисов', 'Макар', 'Андреевич', 7, 'borisov@mail.ru', '3e7Au4khCvaS462mxQiq', 9251234517),
	('Скрыпников', 'Артем', 'Сергеевич', 7, 'skripnikov@mail.ru', '7I0kd3JF8V701peL8PIL', 9251234518),
	('Першин', 'Кирилл', 'Павлович', 9, 'pershin@mail.ru', '75HUR7CJOt1Tv6FAOv0U', 9251234519),
	('Сурков', 'Андрей', 'Алексеевич', 10, 'surkov@mail.ru', 'HRXwkvDGSQo38SdAI6a5', 9251234520),
	('Понкратов', 'Денис', 'Александрович', 11, 'ponkrat@mail.ru', '3561p58OG6sGQuGfi6VU', 9251234521),
	('Хлыстов', 'Евгений', 'Андреевич', 12, 'hlistov@mail.ru', '70BVDh334L2s6e11osSY', 9251234522);

SELECT * FROM employees_admin;
INSERT employees_admin(staff_list_id, departament_id, access_level) 
VALUES
	(1, 1, 3),
	(2, 1, 3),
	(3, 1, 2),
	(4, 1, 2),
	(5, 2, 1),
	(9, 3, 1);

SELECT * FROM media_types;
INSERT media_types(name) 
VALUES
	('Photo'),
	('Screenshot'),
	('Webcam_photo');	

SELECT * FROM media;
INSERT media(media_type_id, filename, url_add) 
VALUES
	(1, 'Анохин', 'https://skr.sh/s6raGQ62D1s?a'),       -- 1
	(1, 'Беляева', 'https://skr.sh/s6riXlxfbtf?a'),		 -- 2
	(1, 'Аликов', 'https://skr.sh/s6r5F6SgI0u?a'),       -- 3
	(1, 'Домбровский', 'https://skr.sh/s6rp6203yvz?a'),  -- 4
	(1, 'Гоцко', 'https://skr.sh/s6rbpFZy1yV?a'),        -- 5
	(1, 'Родькина', 'https://skr.sh/s6rXffX9Dne?a'),     -- 6
	(1, 'Сафонова', 'https://skr.sh/s6rH8m7CiK5?a'),     -- 7
	(1, 'Никифоров', 'https://skr.sh/s6rmFK53vU8?a'),    -- 8
	(1, 'Полонская', 'https://skr.sh/s6rsEv90Toq?a'),    -- 9
	(1, 'Борисов', 'https://skr.sh/s6r5bddpuWC?a'),      -- 10
	(1, 'Скрыпников', 'https://skr.sh/s6rLdkaInLO?a'),   -- 11
	(1, 'Першин', 'https://skr.sh/s6rqb9Bmg7T?a'),       -- 12
	(1, 'Сурков', 'https://skr.sh/s6rdYISGlne?a'),       -- 13
	(1, 'Понкратов', 'https://skr.sh/s6rhLnLWuxN?a'),    -- 14
	(1, 'Хлыстов', 'https://skr.sh/s6rmWxPio3K?a');      -- 15
	
SELECT * FROM profiles;	
INSERT profiles(employees_id, gender, birthday, hometown, marital_status, number_of_children, photo_id) 
VALUES
	(1, 'М', '1976-06-25', 'Москва', 'married', 2, 1),
	(2, 'Ж', '1981-11-12', 'Москва', 'married', 2, 2),		
	(3, 'М', '1986-08-18', 'Москва', 'married', 1, 3),
	(4, 'М', '1979-01-28', 'Москва', 'married', 3, 4),
	(5, 'М', '1988-04-03', 'Москва', 'married', 1, 5),
	(6, 'Ж', '1986-01-15', 'Москва', 'married', 1, 6),
	(7, 'Ж', '1996-07-07', 'Москва', 'unmarried', 0, 7),
	(8, 'М', '1991-05-22', 'Люберцы', 'unmarried', 0, 8),
	(9, 'Ж', '1994-07-13', 'Коломна', 'unmarried', 0, 9),
	(10, 'M', '1996-10-26', 'Москва', 'unmarried', 0, 10),
	(11, 'M', '1988-04-21', 'Одинцово', 'married', 2, 11),
	(12, 'M', '1987-09-15', 'Москва', 'married', 1, 12),
	(13, 'M', '1988-08-02', 'Москва', 'married', 1, 13),
	(14, 'M', '1896-08-15', 'Калуга', 'unmarried', 1, 14),
	(15, 'M', '1994-06-02', 'Москва', 'unmarried', 1, 15);

SELECT * FROM messages;		
INSERT messages(from_employees_id, to_employees_id, body, created_at) 
VALUES
	(10, 8, 'Подскажи, как понять формулировку: вычислить прибыль каждой компании, а также среднюю прибыль. Если фирма получила убытки, в расчет средней прибыли ее не включать. Не могу понять от чего считать среднюю прибыль для фирмы', '2020-11-15 12:29:32'),	
	(8, 10, 'Нужно сложить прибыли всех компаний и поделить на количество компаний (у которых есть прибыль, само собой)', '2020-11-15 12:54:55'),	
	(8, 10, 'В сумме прибылей и количестве компаний компании с убытками не учитывать.', '2020-11-15 12:55:12'),
	(8, 10, 'Это не средняя прибыль для фирмы, а средняя прибыль по фирмам вообще. Из формата итогового списка словарей это видно.', '2020-11-15 12:57:21'),
	(10, 8, 'Понял, спасибо 😊', '2020-11-15 12:57:21'),
	(10, 8, 'А то я по каждой пытался', '2020-11-15 12:57:45'),
	(9, 5, 'Добрый день! Подскажите, пожалуйста - необходимо, чтобы светофор постоянно переключался после вызова метода, либо до какого-то предела (или прошел один цикл красный-желтый-зеленый). Не совсем понял из условия.', '2020-11-18 16:00:15'),
	(5, 9, 'Выход из цикла скорее нажатие любой клавиши, как там запилить ошибку, я сам не понял. А почему клавиша, потому, что цикл получится бесконечный. Как-то так)). Надеюсь помог.', '2020-11-18 16:17:55'),
	(9, 5, 'Да, спасибо', '2020-11-18 16:28:00'),
	(11, 5, '2.5 часа ушло на 1 задание 😅😅 это не норм походу', '2020-11-19 16:44:00'),
	(5, 11, 'Почему же, нормальный результат, над некоторыми заданиями я дольше сидел.))))', '2020-11-19 17:02:00'),
	(7, 6, 'Привет 0/  Необходим боевой совет) result += "*" * row + "\n" как тут можно избавиться от конкатенации', '2020-11-23 10:42:00'),
	(6, 7, 'Привет). Ну к примеру можно так result += f"{"*" * row}\n"', '2020-11-23 10:51:00'),
	(7, 6, 'я был близок)) пробовал так f" "*" {* row}\n" он меня материл, спасибо ;)', '2020-11-23 10:55:00'),
	(6, 7, 'Всегда пожалуйста)', '2020-11-23 10:56:00'),
	(14, 12, 'Ваще не врублюсь по зданию "Используя команду cat, прочитать содержимое каталога etc". Как это можно сделать?', '2020-12-16 15:38:00'),
	(12, 14, 'В голову только такое приходит cat /etc/* 2>/dev/null', '2020-12-16 15:40:00'),
	(14, 12, 'это ошибка, cat не читает каталоги, только файлы', '2020-12-16 15:42:00'),
	(12, 14, 'мне ошибка и нужна, судя по заданию, чтоб перенаправить её в file2.txt', '2020-12-16 15:42:00'),
	(14, 12, 'тогда верно', '2020-12-16 15:43:00'),
	(12, 14, 'но как-то это... не знаю что. Надо неправильно использовать команду, чтоб получить ошибку, чтоб записать ошибку в файл. Не врубаюсь, правильно ли я понял задание', '2020-12-16 15:44:00'),
	(14, 12, 'Надо читать не сам каталог, а его содержимое. Т.е. cat /etc/* Ошибки будут возникать из-за подкаталогов, их и надо перенаправлять', '2020-12-16 15:46:00');
	

/*
--процедура ------------------------------------
SELECT 
	t.task_body, 
	e.lastname, 
	m.url_add, 
	mt.name, 
	t.created_at, 
	t.data_completion,
	CONCAT
		(TIMESTAMPDIFF(HOUR, t.created_at, t.data_completion), ':', 
		(TIMESTAMPDIFF(MINUTE, t.created_at, t.data_completion) - 
		TIMESTAMPDIFF(HOUR, t.created_at, t.data_completion) * 60)) AS execution_time
	FROM tasks t
JOIN employees e ON t.to_employees_id = e.id 
JOIN media m ON t.employee_photo = m.id 
LEFT JOIN media_types mt ON mt.id = m.media_type_id;
-- --------------------------------------------------------
*/


-- Проверка на наличие вакантных должностей
SELECT e.lastname, sl.job_title FROM employees e RIGHT JOIN staff_list sl ON e.staff_id = sl.id WHERE sl.departament_id = 2;
	
	
	
	
	
	
	
	
	
































