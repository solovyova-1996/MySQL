-- 1. Триггер на выставление оценок в таблицу evaluation, максимальная оценка 100 баллов, 
-- при выставлении оценки выше максимума не добавлять запись в таблицу и выводить соответствующее сообщении об ошибке

USE education_portal;
DROP TRIGGER IF EXISTS before_insert_evaluation;
DELIMITER //
CREATE TRIGGER before_insert_evaluation BEFORE INSERT ON evaluation
FOR EACH ROW 
BEGIN 
	IF NEW.scores > 100 THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка!Максимальная оценка 100 баллов';
	END IF;
END//
DELIMITER ;

-- 2. Триггер на добавление записей в таблицу lecturer, необходимо, чтобы id кафедры(departmen_id) соответствовало указанному 
-- факультету (facultet_id). Например факультету с id = 1 соответствуют кафедры с id (1,2,3).
-- При попытке добавления записей не соответствующих вышеуказанному условию не добавлять запись и вывести соответствующую ошибку.

DROP TRIGGER IF EXISTS before_insert_lecturer;
DELIMITER //
CREATE TRIGGER before_insert_lecturer BEFORE INSERT ON lecturer
FOR EACH ROW 
BEGIN 
	SET @facultet = NEW.facultet_id;
	IF NEW.departmen_id NOT IN (SELECT d.id FROM departmens d WHERE d.facultet_id = @facultet) THEN 
	SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка!Кафедра не соответствует указанному факультету';
	END IF;
END//
DELIMITER ;

-- 1. Функция возвращающая средний балл студента по всем предметам

DROP FUNCTION IF EXISTS average_score;
DELIMITER //
CREATE FUNCTION average_score(student_id BIGINT)
RETURNS float 
READS SQL DATA
BEGIN
	DECLARE number_subject INT;
	DECLARE sum_scores BIGINT;
	SET number_subject = (SELECT COUNT(*) FROM evaluation e WHERE e.student_id = student_id);
	SET sum_scores = (SELECT SUM(e.scores) FROM evaluation e WHERE e.student_id = student_id);
	RETURN sum_scores / number_subject;
END//
DELIMITER ; 

-- например вывести средний балл студента с id = 14
SELECT average_score (14);

-- 2. Хранимая процедура, которая выводит список студентов(фамилия имя),обучающихся на курсе,
--  введенном в параметр corse   
DROP PROCEDURE IF EXISTS course_studentes ;
DELIMITER //
CREATE PROCEDURE course_studentes (IN corse INT)
BEGIN
	
	IF corse = 1 THEN (SELECT CONCAT(s.surname,' ',s.name) AS 'Фамилия Имя'FROM students s WHERE s.year_of_admission = 2021);
	ELSEIF corse = 2 THEN (SELECT CONCAT(s.surname,' ',s.name) AS 'Фамилия Имя'FROM students s WHERE s.year_of_admission = 2020);
	ELSEIF corse = 3 THEN (SELECT CONCAT(s.surname,' ',s.name) AS 'Фамилия Имя'FROM students s WHERE s.year_of_admission = 2019);
	ELSEIF corse = 4 THEN (SELECT CONCAT(s.surname,' ',s.name) AS 'Фамилия Имя'FROM students s WHERE s.year_of_admission = 2018);
	ELSE
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ошибка!Нет студентов указанного курса';
	END IF;
END//

DELIMITER ;

-- Например показать студентов четвертого курса
CALL course_studentes(4) ;






