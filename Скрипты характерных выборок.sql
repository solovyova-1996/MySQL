-- 1. Вывести ФИО преподавателей,которые работают на факультете id=1, которые оставили хотябы одно объявление
USE education_portal;
SELECT CONCAT(l.surname, ' ', l.name, ' ',l.patronymic) AS 'ФИО' 
FROM lecturer l 
WHERE l.facultet_id = 1 AND l.id 
IN 
(SELECT lecturer_id FROM ads);

-- Решение с помощью JOIN
SELECT DISTINCT CONCAT(l.surname, ' ', l.name, ' ',l.patronymic) AS 'ФИО'
FROM 
lecturer l 
JOIN
ads a
ON l.facultet_id = 1 AND l.id = a.lecturer_id;


-- 2. Определить факультет, на котором учатся больше всего студентов
SELECT 
(SELECT name_fuculties FROM faculties f WHERE f.id = students.faculties_id) AS 'name facultet',
COUNT(*) AS total_students
FROM students 
GROUP BY faculties_id 
ORDER BY total_students DESC LIMIT 1;

-- Решение с помощью JOIN

SELECT 
f.name_fuculties AS 'name facultet',
COUNT(*) AS total_students
FROM 
students s
JOIN
faculties f
ON f.id = s.faculties_id
GROUP BY faculties_id 
ORDER BY total_students DESC LIMIT 1;

-- 3.Вывести информацию  (ФИО студента, названние его группы и факультета, количество баллов) о студенте с самым большим количеством баллов

SELECT CONCAT (s.surname, ' ',s.name,' ',s.patronymic) AS 'ФИО', 
gs.name_group AS 'Группа', 
f.name_fuculties AS 'Факультет', 
SUM(e.scores) AS summ_scores
FROM 
evaluation e 
JOIN 
students s
JOIN faculties f 
JOIN group_students gs 
ON e.student_id = s.id AND f.id = s.faculties_id AND gs.id = s.group_students_id 
GROUP BY s.id ORDER BY summ_scores DESC LIMIT 1;

-- 4.Определить название факультета, на котором работает меньше всего мужчин

SELECT  
CASE 
WHEN l.facultet_id THEN f.name_fuculties
END AS 'Имя факультета',
COUNT(*) AS total_m
FROM lecturer l 
JOIN 
faculties f 
ON l.gender LIKE 'm' AND l.facultet_id = f.id 
GROUP BY l.facultet_id 
ORDER BY total_m LIMIT 1;

-- 5. Вывести текст объявления и имена всех преподавателей женщин, которые имеют степень доктор наук (не важно в какой области) 
-- оставивших эти объявления и название группы, для которой предназначается объявление

SELECT
l.id,
CONCAT( l.name, ' ', l.surname ) AS 'Преподаватель',
a.body AS 'Объявление',
gs.name_group AS 'Для группы'
FROM 
lecturer l  
JOIN 
ads a
JOIN
group_students gs 
ON l.academic_degree RLIKE 'доктор' AND l.gender LIKE 'f' AND l.id = a.lecturer_id AND a.group_students_id = gs.id ;


-- 6. Определить максимальный средний балл, отсортировав студентов по году поступления

SELECT MAX(avg_scores) FROM  
(SELECT AVG(e.scores) AS avg_scores, s.year_of_admission 
FROM 
students s 
JOIN 
evaluation e 
ON e.student_id = s.id 
GROUP BY s.year_of_admission) AS tbl;























