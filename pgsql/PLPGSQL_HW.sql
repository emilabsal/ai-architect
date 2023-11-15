
create table if not exists students (
	id integer generated always as identity primary key,
	name text,
	total_score integer default 0
);

alter table students add column scholarship integer default 0;

create table if not exists activity_scores (
	student_id integer references students,
	activity_types text,
	score integer
);

-- 1.
create or replace function calculate_scholarship() returns trigger
language plpgsql as $$
declare 
	sum_score integer := 0;
	_scholarship integer;
begin
	select sum(score) into sum_score
	from activity_scores
	where student_id = new.student_id;
	if sum_score < 80 then 
		_scholarship := 0;
	elsif sum_score >= 80 and sum_score < 90 then 
		_scholarship := 500;
	else
		_scholarship := 1000;
	end if;

	update students
	set scholarship = _scholarship
	where id = new.student_id;

	return new;
end;
$$

create trigger update_scholarship_trigger
after insert on activity_scores
for each row execute function calculate_scholarship();

insert into students(name)
values
('Ivan'),
('Sasha'),
('Petya'),
('Vitya'),
('Vova');

select * from students;

insert into activity_scores 
values (1, 'Answer', 5);

insert into activity_scores 
values
(1, 'Exam', 50),
(1, 'Homework', 25);

select * from activity_scores;

--2. 
create or replace function update_total_score() returns trigger
language plpgsql as $$
declare 
	sum_score integer := 0;
	score_ integer;
begin
	for score_ in
		select score 
		from activity_scores
		where student_id = new.student_id
	loop 
		sum_score := sum_score + score_;
	end loop;

	update students
	set total_score = sum_score
	where id = new.student_id;

	return new;
end;
$$

create trigger update_total_score_trigger
after insert on activity_scores 
for each row execute function update_total_score();

insert into activity_scores 
values (1, 'Answer', 5);

select * from students;

insert into activity_scores 
values (2, 'Exam', 79),
(3, 'Exam', 80),
(4, 'Exam', 81),
(5, 'Exam', 99);

select * from students;


