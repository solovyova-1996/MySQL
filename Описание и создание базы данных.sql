/*Описание базы данных
Название: education_portal (образовательный портал).
Назначение: база данных предназначена для хранения данных образовательного портала университета.
Количество таблиц: 10.
Описание таблиц
1.	Таблица faculties содержит перечень факультетов и их описание. 
2.	Таблица departmens содержит перечень кафедр и внешний ключ faculnies_id, по которому можно определить 
принадлежность кафедры к факультету.
3.	Таблица lecturer содержит информацию о преподавателях 
(фамилия, имя, отчество, пол, ученая степень, адрес электронной почты, телефон, пароль для входа на портал, внешний ключ 
facultet_id, который отражает принадлежность преподавателя к факультету и внешний ключ department_id 
отражающий принадлежность преподавателя к кафедре). 
4.	Таблица subjects содержит перечень преподаваемых дисциплин, для каждой дисциплины хранится 
следующая информация (название дисциплины и внешние ключи facultet_id и lecturer_id, которые показывают на каком факультете 
преподается дисциплина и каким преподавателем).
5.	Таблица group_students содержит названия групп и facultet_id в качестве внешнего ключа.
6.	Таблица students содержит информацию о студентах (фамилия, имя, отчество, пол, год поступления, 
адрес электронной почты, телефон, пароль для входа на портал, внешний ключ facultet_id, 
который отражает принадлежность студента к факультету и внешний ключ group_students_id отражающий принадлежность студента к группе).
7.	Таблица portfolio содержит информацию о выполненных работах студента 
(работу студента, время прикрепления работы и внешний ключ student_id, показывающий кому принадлежит работа).
8.	Таблица evaluations – это таблица оценок. Таблица, включает столбцы: student_id – внешний ключ (кому поставлена оценка), 
subject_id – внешний ключ (по какой дисциплине поставлена оценка), scores – оценка в баллах.
9.	Таблица timetable – таблица расписания занятий. Содержит расписание и внешний ключ group_students_id (для какой из групп 
составлено расписание).
10.	 Таблица ads – таблица объявлений от преподавателя. Содержит внешние ключи : lecturer_id (преподаватель, оставивший объявление) и 
group_students_id (группа, которой предназначено объявление), так же текст объявления и дату его добавления.

*/



DROP DATABASE IF EXISTS education_portal;
CREATE DATABASE education_portal;
USE education_portal;

DROP TABLE IF EXISTS faculties;
CREATE TABLE faculties(
	id SERIAL PRIMARY KEY,
	name_fuculties VARCHAR(250),
	specification_faculties TEXT COMMENT 'Описание факультета'
) COMMENT = 'Перечень факультетов';

DROP TABLE IF EXISTS departmens;
CREATE TABLE departmens(
	id SERIAL PRIMARY KEY,
	name_departmens VARCHAR(50) COMMENT 'Название кафедры',
	facultet_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (facultet_id) REFERENCES faculties(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Перечень кафедр';

DROP TABLE IF EXISTS lecturer;
CREATE TABLE lecturer(
	id SERIAL PRIMARY KEY,
	surname VARCHAR(50) COMMENT 'Фамилия преподавателя',
	name VARCHAR(50),
	patronymic VARCHAR(50) COMMENT 'Отчество перподавателя',
	gender CHAR(1) COMMENT 'm-мужской пол, f-женский пол',
	academic_degree VARCHAR(50) COMMENT 'Ученая степень',
	email VARCHAR(70) UNIQUE,
	phone BIGINT UNSIGNED,
	password_hash VARCHAR(100),
	facultet_id BIGINT UNSIGNED NOT NULL,
	departmen_id BIGINT UNSIGNED NOT NULL,
	INDEX lecturer_facultet (facultet_id),
	FOREIGN KEY (facultet_id) REFERENCES faculties(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (departmen_id) REFERENCES departmens(id) ON UPDATE CASCADE ON DELETE CASCADE
);


DROP TABLE IF EXISTS subjects;
CREATE TABLE subjects(
	id SERIAL PRIMARY KEY,
	name_subject VARCHAR(50),
	facultet_id BIGINT UNSIGNED NOT NULL,
	lecturer_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (facultet_id) REFERENCES faculties(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (lecturer_id) REFERENCES lecturer(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Перечень дисциплин';

DROP TABLE IF EXISTS group_students;
CREATE TABLE group_students(
	id SERIAL PRIMARY KEY,
	name_group VARCHAR(50),
	faculties_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (faculties_id) REFERENCES faculties(id) ON UPDATE CASCADE ON DELETE CASCADE
);

DROP TABLE IF EXISTS students;
CREATE TABLE students(
	id SERIAL PRIMARY KEY,
	surname VARCHAR(50) COMMENT 'Фамилия студента',
	name VARCHAR(50),
	patronymic VARCHAR(50) COMMENT 'Отчество студента',
	gender CHAR(1) COMMENT 'm-мужской пол, f-женский пол',
	year_of_admission YEAR COMMENT 'Год поступления',
	email VARCHAR(70) UNIQUE,
	phone BIGINT UNSIGNED,
	password_hash VARCHAR(100),
	faculties_id BIGINT UNSIGNED NOT NULL,
	group_students_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (faculties_id) REFERENCES faculties(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (group_students_id) REFERENCES group_students(id) ON UPDATE CASCADE ON DELETE CASCADE
); 

DROP TABLE IF EXISTS portfolio;
CREATE TABLE portfolio(
	id SERIAL PRIMARY KEY,
	project TEXT COMMENT 'Работа студента',
	student_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (student_id) REFERENCES students(id) ON UPDATE CASCADE ON DELETE CASCADE
);
DROP TABLE IF EXISTS evaluations;
CREATE TABLE evaluation(
	student_id BIGINT UNSIGNED NOT NULL,
	subject_id BIGINT UNSIGNED NOT NULL,
	scores TINYINT UNSIGNED COMMENT 'Оценка в баллах от 0 до 100',
	INDEX evalution_student (student_id),
	FOREIGN KEY (student_id) REFERENCES students(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (subject_id) REFERENCES subjects(id) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (student_id, subject_id)
);

DROP TABLE IF EXISTS timetable;
CREATE TABLE timetable(
	id SERIAL PRIMARY KEY,
	body TEXT COMMENT 'Расписание',
	group_students_id BIGINT UNSIGNED NOT NULL,
	FOREIGN KEY (group_students_id) REFERENCES group_students(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Таблица расписания занятий';


DROP TABLE IF EXISTS ads;
CREATE TABLE ads(
	id SERIAL PRIMARY KEY,
	body TEXT COMMENT 'Текст объявления',
	lecturer_id BIGINT UNSIGNED NOT NULL,
	group_students_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(),
	FOREIGN KEY (group_students_id) REFERENCES group_students(id) ON UPDATE CASCADE ON DELETE CASCADE,
	FOREIGN KEY (lecturer_id) REFERENCES lecturer(id) ON UPDATE CASCADE ON DELETE CASCADE
) COMMENT = 'Таблица объявлений от преподавателей';



