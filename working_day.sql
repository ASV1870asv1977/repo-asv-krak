

-- ============================ Выполнение операций TETARW в течении рабочего дня ====================
USE tetarw;
SELECT * FROM employees;



--  --------------------------------------------------------------------------------------------------
/* 
 * Определение статуса сотрудника.
 * Осуществляется вначале рабочего дня путем регистрации сотрудника непосредственно или определения 
 * статуса сотрудника начальником отдела или лицом его замещающим.
 */


SELECT employees_id, created_at, working_ststus FROM working_ststus;

INSERT working_ststus(employees_id, created_at, working_ststus) 
VALUES
	(1, '2021-02-02 09:00:00', 'Отпуск'),
	(2, '2021-02-02 09:00:00', 'Болен'),
	(3, '2021-02-02 09:00:00', 'Работает'),
	(4, '2021-02-02 09:00:00', 'Командировка'),
	(5, '2021-02-02 09:00:00', 'Работает'),
	(6, '2021-02-02 09:00:00', 'Работает'),
	(7, '2021-02-02 09:00:00', 'Работает'),
	(8, '2021-02-02 09:00:00', 'Выходной'),
	(9, '2021-02-02 09:00:00', 'Работает'),
	(10, '2021-02-02 09:00:00', 'Работает'),
	(11, '2021-02-02 09:00:00', 'Болен'),
	(12, '2021-02-02 09:00:00', 'Работает'),
	(13, '2021-02-02 09:00:00', 'Прогул'),
	(14, '2021-02-02 09:00:00', 'Работает'),
	(15, '2021-02-02 09:00:00', 'Отпуск');

-- --------------------------------------------------------------------------------------------------
/* 
 * Заполнение базы при постановке и выполнении задач.
 * Постановка задач осуществляется сотрудником, имеющим соответствующий допуск в части касающейся. 
 */

SELECT id, from_employees_id, to_employees_id, task_body, created_at, data_completion, completion_at FROM tasks;	

INSERT tasks(id, from_employees_id, to_employees_id, task_body, created_at, data_completion) 
VALUES
	(1, 3, 6, 'Переделать конструктор классов', '2021-02-02 09:10:00', '2021-02-02 18:00:00'),
	(2, 5, 7, 'Верстка для iMoscow', '2021-02-02 09:10:00', '2021-02-02 18:00:00'),
	(3, 5, 9, 'Исправление багов и тех долга', '2021-02-02 09:10:00', '2021-02-02 18:00:00'),
	(4, 5, 10, 'Кулградус заменить почту для смтп', '2021-02-02 09:10:00', '2021-02-02 18:00:00'),
	(5, 12, 14, 'Тестирование ПО', '2021-02-02 09:10:00', '2021-02-02 18:00:00'),
	(6, 3, 5, 'Страница специалиста', '2021-02-02 09:10:00', '2021-02-02 18:00:00'),
	(7, 3, 12, 'Оформление презентации для ООО "Технологии Цифровой Поддержки Бизнеса"', '2021-02-02 09:10:00', '2021-02-02 18:00:00');

-- При этом осуществляется фотофиксация сотрудника, получившего задачу для выполнения.
SELECT id, media_type_id, tasks_id, filename, url_add, created_at FROM media;

INSERT media(media_type_id, tasks_id, filename, url_add, created_at) 
VALUES
	(3, 1, 'web_cam_task_1.jpeg', 'https://skr.sh/s6rXffX9Dne?a', '2021-02-02 09:10:00'),
	(3, 2, 'web_cam_task_2.jpeg', 'https://skr.sh/s6rH8m7CiK5?a', '2021-02-02 09:10:00'),
	(3, 3, 'web_cam_task_3.jpeg', 'https://skr.sh/s6rsEv90Toq?a', '2021-02-02 09:10:00'),
	(3, 4, 'web_cam_task_4.jpeg', 'https://skr.sh/s6r5bddpuWC?a', '2021-02-02 09:10:00'),
	(3, 5, 'web_cam_task_5.jpeg', 'https://skr.sh/s6rhLnLWuxN?a', '2021-02-02 09:10:00'),
	(3, 6, 'web_cam_task_6.jpeg', 'https://skr.sh/s6rbpFZy1yV?a', '2021-02-02 09:10:00'),
	(3, 7, 'web_cam_task_7.jpeg', 'https://skr.sh/s6rqb9Bmg7T?a', '2021-02-02 09:10:00');

-- После выполнения задачи фиксируется время (астрономическое) ее выполнения. 
UPDATE tasks SET completion_at = '2021-02-02 17:55:00' WHERE id = 1;
UPDATE tasks SET completion_at = '2021-02-02 17:44:00' WHERE id = 2;
UPDATE tasks SET completion_at = '2021-02-02 17:23:00' WHERE id = 3;
UPDATE tasks SET completion_at = '2021-02-02 17:48:00' WHERE id = 4;
UPDATE tasks SET completion_at = '2021-02-02 17:38:00' WHERE id = 5;
UPDATE tasks SET completion_at = '2021-02-02 17:50:00' WHERE id = 6;
UPDATE tasks SET completion_at = '2021-02-02 17:51:00' WHERE id = 7;

-- --------------------------------------------------------------------------------------------------
/* 
 * Убытие на перерыв.
 * Осуществляется после определения статуса "Перерыв". 
 */

SELECT tasks_id, break_on, break_of FROM rest_break;

INSERT rest_break(tasks_id, break_on) 
VALUES
	(1, '2021-02-02 10:30:00'),
	(2, '2021-02-02 10:55:00'),
	(3, '2021-02-02 10:50:00'),
	(4, '2021-02-02 10:45:00'),
	(5, '2021-02-02 10:54:00'),
	(6, '2021-02-02 10:48:00'),
	(7, '2021-02-02 10:52:00'),
	-- -------------------------
	(1, '2021-02-02 13:00:00'),	
	(2, '2021-02-02 13:10:00'),
	(3, '2021-02-02 12:55:00'),
	(4, '2021-02-02 13:05:00'),
	(5, '2021-02-02 13:34:00'),
	(6, '2021-02-02 13:02:00'),
	(7, '2021-02-02 12:45:00');

-- Прибытие с перерыва осуществляется после определения статуса "Работа"
-- UPDATE rest_break SET break_of = '2021-02-02 10:45:00' WHERE tasks_id = 1 AND break_on IS NULL;

UPDATE rest_break SET break_of = '2021-02-02 10:45:00' WHERE tasks_id = 1 AND break_on = '2021-02-02 10:30:00';
UPDATE rest_break SET break_of = '2021-02-02 14:15:00' WHERE tasks_id = 1 AND break_on = '2021-02-02 13:00:00';
UPDATE rest_break SET break_of = '2021-02-02 11:10:00' WHERE tasks_id = 2 AND break_on = '2021-02-02 10:55:00';
UPDATE rest_break SET break_of = '2021-02-02 14:00:00' WHERE tasks_id = 2 AND break_on = '2021-02-02 13:10:00';
UPDATE rest_break SET break_of = '2021-02-02 11:07:00' WHERE tasks_id = 3 AND break_on = '2021-02-02 10:50:00';
UPDATE rest_break SET break_of = '2021-02-02 14:10:00' WHERE tasks_id = 3 AND break_on = '2021-02-02 12:55:00';
UPDATE rest_break SET break_of = '2021-02-02 11:05:00' WHERE tasks_id = 4 AND break_on = '2021-02-02 10:45:00';
UPDATE rest_break SET break_of = '2021-02-02 14:15:00' WHERE tasks_id = 4 AND break_on = '2021-02-02 13:05:00';
UPDATE rest_break SET break_of = '2021-02-02 11:25:00' WHERE tasks_id = 5 AND break_on = '2021-02-02 10:54:00';
UPDATE rest_break SET break_of = '2021-02-02 14:20:00' WHERE tasks_id = 5 AND break_on = '2021-02-02 13:34:00';
UPDATE rest_break SET break_of = '2021-02-02 11:11:00' WHERE tasks_id = 6 AND break_on = '2021-02-02 10:48:00';
UPDATE rest_break SET break_of = '2021-02-02 14:11:00' WHERE tasks_id = 6 AND break_on = '2021-02-02 13:02:00';
UPDATE rest_break SET break_of = '2021-02-02 11:30:00' WHERE tasks_id = 7 AND break_on = '2021-02-02 10:52:00';
UPDATE rest_break SET break_of = '2021-02-02 14:14:00' WHERE tasks_id = 7 AND break_on = '2021-02-02 12:45:00';

-- ---------------------------------------------------------------------------------------------------
-- Использование ПО
SELECT tasks_id, software_name, browser_url, created_at, completion_at FROM software_work;
SELECT id, media_type_id, tasks_id, filename, url_add, created_at FROM media;

INSERT media(media_type_id, tasks_id, filename, url_add, created_at) 
VALUES
	(2, 1, 'skr_sh_task_1_1.jpeg', 'https://skr.sh/s6tryAvWknO?a', '2021-02-02 09:15:00'),
	(3, 1, 'web_cam_task_1_1.jpeg', 'https://skr.sh/s6rXffX9Dne?a', '2021-02-02 09:15:00'),	
	(2, 1, 'skr_sh_task_1_2.jpeg', 'https://skr.sh/s6rEz8fNhA0?a', '2021-02-02 09:45:00'),
	(3, 1, 'web_cam_task_1_2.jpeg', 'https://skr.sh/s6rXffX9Dne?a', '2021-02-02 09:45:00'),	
	(2, 1, 'skr_sh_task_1_3.jpeg', 'https://skr.sh/s6sd5lxsmQe?a', '2021-02-02 15:50:00'),
	(3, 1, 'web_cam_task_1_3.jpeg', 'https://skr.sh/s6rXffX9Dne?a', '2021-02-02 15:50:00'),	
	(2, 2, 'skr_sh_task_2_1.jpeg', 'https://skr.sh/s6t6btZpnai?a', '2021-02-02 09:21:00'),
	(3, 2, 'web_cam_task_2_1.jpeg', 'https://skr.sh/s6rH8m7CiK5?a', '2021-02-02 09:21:00'),	
	(2, 2, 'skr_sh_task_2_2.jpeg', 'https://skr.sh/s6twSDOtkcE?a', '2021-02-02 09:42:00'),
	(3, 2, 'web_cam_task_2_2.jpeg', 'https://skr.sh/s6rH8m7CiK5?a', '2021-02-02 09:42:00'),	
	(2, 2, 'skr_sh_task_2_3.jpeg', 'https://skr.sh/s6tkCLuIFFS?a', '2021-02-02 16:20:00'),
	(3, 2, 'web_cam_task_2_3.jpeg', 'https://skr.sh/s6rH8m7CiK5?a', '2021-02-02 16:20:00'),	
	(2, 3, 'skr_sh_task_3_1.jpeg', 'https://skr.sh/s6tZ8VLVPJQ?a', '2021-02-02 09:18:00'),
	(3, 3, 'web_cam_task_3_1.jpeg', 'https://skr.sh/s6rsEv90Toq?a', '2021-02-02 09:18:00'),	
	(2, 3, 'skr_sh_task_3_2.jpeg', 'https://skr.sh/s6tVuTU96Tb?a', '2021-02-02 11:00:00'),
	(3, 3, 'web_cam_task_3_2.jpeg', 'https://skr.sh/s6rsEv90Toq?a', '2021-02-02 11:00:00'),	
	(2, 3, 'skr_sh_task_3_3.jpeg', 'https://skr.sh/s6tryAvWknO?a', '2021-02-02 17:02:00'),
	(3, 3, 'web_cam_task_3_3.jpeg', 'https://skr.sh/s6rsEv90Toq?a', '2021-02-02 17:02:00'),	
	(2, 4, 'skr_sh_task_4_1.jpeg', 'https://skr.sh/s6r5bddpuWC?a', '2021-02-02 09:17:00'),
	(3, 4, 'web_cam_task_4_1.jpeg', 'https://skr.sh/s6rsEv90Toq?a', '2021-02-02 09:17:00'),
	(2, 4, 'skr_sh_task_4_2.jpeg', 'https://skr.sh/s6t1334mMWI?a', '2021-02-02 09:35:00'),
	(3, 4, 'web_cam_task_4_2.jpeg', 'https://skr.sh/s6rsEv90Toq?a', '2021-02-02 09:35:00'),	
	(2, 5, 'skr_sh_task_5_1.jpeg', 'https://skr.sh/s6tryAvWknO?a', '2021-02-02 09:20:00'),
	(3, 5, 'web_cam_task_5_1.jpeg', 'https://skr.sh/s6rhLnLWuxN?a', '2021-02-02 09:20:00'),
	(2, 5, 'skr_sh_task_5_2.jpeg', 'https://skr.sh/s6tT0mKsG8j?a', '2021-02-02 09:25:00'),
	(3, 5, 'web_cam_task_5_2.jpeg', 'https://skr.sh/s6rhLnLWuxN?a', '2021-02-02 09:25:00'),
	(2, 5, 'skr_sh_task_5_3.jpeg', 'https://skr.sh/s6tMIVWLMUY?a', '2021-02-02 09:45:00'),
	(3, 5, 'web_cam_task_5_3.jpeg', 'https://skr.sh/s6rhLnLWuxN?a', '2021-02-02 09:45:00'),	
	(2, 6, 'skr_sh_task_6_1.jpeg', 'https://skr.sh/s6tCONWkcyq', '2021-02-02 09:15:00'),
	(3, 6, 'web_cam_task_6_1.jpeg', 'https://skr.sh/s6rbpFZy1yV?a', '2021-02-02 09:15:00'),	
	(2, 7, 'skr_sh_task_7_1.jpeg', 'https://skr.sh/s6tRMNFSeTa?a', '2021-02-02 09:22:00'),
	(3, 7, 'web_cam_task_7_1.jpeg', 'https://skr.sh/s6rqb9Bmg7T?a', '2021-02-02 09:22:00');


INSERT software_work(tasks_id, software_name, browser_url, created_at) 
VALUES
	(1, 'google', 'https://www.google.com/', '2021-02-02 09:15:00'),
	(1, 'PyCharm professional', NULL, '2021-02-02 09:45:00'),
	(1, NULL, 'https://pypi.org/', '2021-02-02 15:50:00'),	
	(2, 'yandex', 'https://yandex.ru/', '2021-02-02 09:21:00'),
	(2, 'Sublime Text', NULL, '2021-02-02 09:42:00'),	
	(2, 'facebook', 'https://www.facebook.com/', '2021-02-02 16:20:00'),	
	(3, 'instagram', 'https://www.instagram.com/', '2021-02-02 09:18:00'),
	(3, 'PyCharm professional', NULL, '2021-02-02 11:00:00'),
	(3, 'google', 'https://www.google.com/', '2021-02-02 17:02:00'),	
	(4, 'google', 'https://www.google.com/', '2021-02-02 09:17:00'),
	(4, 'Sublime Text', NULL, '2021-02-02 09:35:00'),	
	(5, 'google', 'https://www.google.com/', '2021-02-02 09:20:00'),
	(5, NULL, 'https://github.com/', '2021-02-02 09:25:00'),
	(5, NULL, 'https://dryrun.com/', '2021-02-02 09:45:00'),	
	(6, 'DBeaver', NULL, '2021-02-02 09:15:00'),	
	(7, 'PowerPoint', NULL, '2021-02-02 09:22:00');


UPDATE software_work SET completion_at = '2021-02-02 17:55:00';

/*
-- Скриншоты ПО
PyCharm professional
https://skr.sh/s6rEz8fNhA0?a
https://skr.sh/s6tVuTU96Tb?a

https://pypi.org/
https://skr.sh/s6sd5lxsmQe?a

https://dryrun.com/
https://skr.sh/s6tMIVWLMUY?a

SublimeText
https://skr.sh/s6twSDOtkcE?a   -- HTML

SublimeText
https://skr.sh/s6t1334mMWI?a   -- JS

DBeaver
https://skr.sh/s6tCONWkcyq

yandex
https://yandex.ru/
https://skr.sh/s6t6btZpnai?a

google
https://www.google.com/
https://skr.sh/s6tryAvWknO?a

одноклассники
https://ok.ru/
https://skr.sh/s6t4S4ychdY?a

instagram
https://www.instagram.com/
https://skr.sh/s6tZ8VLVPJQ?a

facebook
https://www.facebook.com/
https://skr.sh/s6tkCLuIFFS?a

https://github.com/
https://skr.sh/s6tT0mKsG8j?a


PowerPoint
https://skr.sh/s6tRMNFSeTa?a

*/

