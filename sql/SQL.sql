create table college
(
    id bigint primary key ,
    name varchar not null ,
    size integer not null  default 100
);

insert into college(id, name, size) values (10, 'КФУ',50000);
insert into college(id, name, size) values (20, 'МГУ',38000);
insert into college(id, name, size) values (30, 'МФТИ',7000);
insert into college(id, name, size) values (40, 'Иннополис',1077);
insert into college(id, name, size) values (50, 'Сколково',1070);

create table student
(
    id bigint primary key ,
    city varchar not null ,
    name varchar not null ,
    telegram_contact varchar not null,
    college_id bigint not null,
    constraint fk_college_id foreign key (college_id) references college(id)
);

insert into student(id, city, name, telegram_contact, college_id) values (10, 'Казань','Иван Иванов','@ivanov1991',10);
insert into student(id, city, name, telegram_contact, college_id) values (20, 'Москва','Екатерина Андреева','@kate_',20);
insert into student(id, city, name, telegram_contact, college_id) values (30, 'Новосибирск','Анна Потапова','@apotap',30);
insert into student(id, city, name, telegram_contact, college_id) values (40, 'Казань','Ильяс Мухаметшин','@ilyas',40);
insert into student(id, city, name, telegram_contact, college_id) values (50, 'Москва','Сергей Петров','@spetrov',50);

create table course
(
    id bigint primary key ,
    name varchar not null,
    is_online boolean not null  DEFAULT false,
    amount_of_students integer check ( amount_of_students >= 1 ),
    college_id bigint NOT NULL,

    constraint fk_course_college_id foreign key (college_id) references college(id)
);

insert into course(id, name, is_online, amount_of_students, college_id) values (10,'Введение в РСУБД', true, 300 , 10);
insert into course(id, name, is_online, amount_of_students, college_id) values (20,'Data Mining', true, 10 , 20);
insert into course(id, name, is_online, amount_of_students, college_id) values (30,'Нейронные сети', true, 25 , 30);
insert into course(id, name, is_online, amount_of_students, college_id) values (40,'Цифровая трансформация', true, 50 , 40);
insert into course(id, name, is_online, amount_of_students, college_id) values (50,'Актерское мастерство', false, 15 , 50);


create table student_on_course
(
    id bigint primary key ,
    student_id bigint not null ,
    course_id bigint not null ,
    student_rating integer not null DEFAULT 50 check ( student_rating BETWEEN 0 and 100 ),
    finished_date date,
    constraint fk_student_id foreign key (student_id) references student(id),
    constraint fk_course_id foreign key (course_id) references course(id)
);

insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (10,10,10,75, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (20,10,20,83, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (30,10,40,40, null);

insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (40,20,50,95, '2022-12-12');

insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (50,30,30,76, '2022-12-12');
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (60,30,40,42, null);

insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (70,40,10,76, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (80,40,20,83, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (90,40,50,96, null);

insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (100,50,10,12, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (110,50,20,21, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (120,50,30,56, null);
insert into student_on_course(id, student_id, course_id, student_rating, finished_date) VALUES (130,50,40,92, null);

-- a.
SELECT
    name,
    telegram_contact
FROM student
WHERE city IN ( 'Казань', 'Москва' )
ORDER BY 1 DESC;

-- b.
SELECT
    FORMAT( 'университет: %s; количество студентов: %s', name, size ) AS "полная информация"
FROM college
ORDER BY 1;

-- c.
SELECT
    name,
    size
FROM college
WHERE id IN ( 10, 30, 50 )
ORDER BY 2, 1;

-- d.
SELECT
    name,
    size
FROM college
WHERE id NOT IN ( 10, 30, 50 )
ORDER BY 2, 1;

-- e.
SELECT
    name,
    amount_of_students
FROM course
WHERE amount_of_students BETWEEN 27 AND 310 AND is_online
ORDER BY 1 DESC, 2 DESC;

-- f.
SELECT
    name
FROM student
UNION
SELECT
    name
FROM course
ORDER BY name DESC;

-- g.
SELECT
    name,
    'университет' AS object_type
FROM college
UNION
SELECT
    name,
    'курс'
FROM course
ORDER BY object_type DESC, name;

-- h.
SELECT
    name,
    amount_of_students
FROM course
ORDER BY CASE WHEN amount_of_students = 300 THEN 0 ELSE 1 END, amount_of_students
LIMIT 3;

-- i.
INSERT INTO course
SELECT
    60,
    'Machine Learning',
    FALSE,
    17,
    ( SELECT college_id FROM course WHERE name = 'Data Mining' );

SELECT * FROM course;

-- j.
( SELECT id FROM course EXCEPT SELECT id FROM student_on_course )
UNION
( SELECT id FROM student_on_course EXCEPT SELECT id FROM course )
ORDER BY 1;

-- k.
SELECT
    s.name  AS student_name,
    c.name  AS course_name,
    c2.name AS student_college,
    student_rating
FROM student_on_course
JOIN student s ON student_on_course.student_id = s.id
JOIN course  c ON student_on_course.course_id = c.id
JOIN college c2 ON s.college_id = c2.id
WHERE student_rating > 50 AND size > 5000
ORDER BY 1, 2;

-- l.
SELECT
    s1.name AS student_1,
    s2.name AS student_2,
    s1.city
FROM student s1
JOIN student s2 ON s1.city = s2.city AND s1.name > s2.name
ORDER BY 1;

-- m.
SELECT
    CASE
        WHEN student_rating < 30
            THEN 'неудовлетворительно'
        WHEN student_rating >= 30 AND student_rating < 60
            THEN 'удовлетворительно'
        WHEN student_rating >= 60 AND student_rating < 85
            THEN 'хорошо'
        ELSE 'отлично' END AS "оценка",
    COUNT( * )             AS "количество студентов"
FROM student_on_course
GROUP BY 1
ORDER BY 1;

-- n.
SELECT
    c.name,
    CASE
        WHEN student_rating < 30
            THEN 'неудовлетворительно'
        WHEN student_rating >= 30 AND student_rating < 60
            THEN 'удовлетворительно'
        WHEN student_rating >= 60 AND student_rating < 85
            THEN 'хорошо'
        ELSE 'отлично' END AS "оценка",
    COUNT( * )             AS "количество студентов"
FROM student_on_course
JOIN course c ON student_on_course.course_id = c.id
GROUP BY 1, 2
ORDER BY 1, 2;