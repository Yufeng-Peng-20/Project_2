create schema if not exists project_2;

CREATE table IF NOT EXISTS employees( 
	emp_id SERIAL, 
	first_name VARCHAR(100), 
	last_name VARCHAR(100), 
	dob DATE, 
	city VARCHAR(100), 
	salary INT );

select * from employees;