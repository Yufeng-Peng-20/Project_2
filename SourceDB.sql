create schema if not exists project_2;

CREATE table IF NOT EXISTS employees( 
	emp_id SERIAL, 
	first_name VARCHAR(100), 
	last_name VARCHAR(100), 
	dob DATE, 
	city VARCHAR(100), 
	salary INT );

CREATE table IF NOT EXISTS emp_cdc(
	action_id SERIAL primary key, 
	emp_id SERIAL, 
	first_name VARCHAR(100), 
	last_name VARCHAR(100), 
	dob DATE, 
	city VARCHAR(100), 
	salary INT, 
	action VARCHAR(100) );

CREATE table IF NOT EXISTS cdc_offsets (
    topic_name VARCHAR(255) NOT NULL,
    last_action_id BIGINT NOT NULL,
    PRIMARY KEY (topic_name)
);

CREATE OR REPLACE FUNCTION trigger_emp_cdc() RETURNS TRIGGER AS $$
BEGIN

  IF TG_OP = 'INSERT' THEN
    INSERT INTO emp_cdc (emp_id, first_name, last_name, dob, city, action)
    VALUES (NEW.emp_id, NEW.first_name, NEW.last_name, NEW.dob, NEW.city, 'INSERT');
    RETURN NEW;

  ELSIF TG_OP = 'UPDATE' THEN
    INSERT INTO emp_cdc (emp_id, first_name, last_name, dob, city, action)
    VALUES (NEW.emp_id, NEW.first_name, NEW.last_name, NEW.dob, NEW.city, 'UPDATE');
    RETURN NEW;

  ELSIF TG_OP = 'DELETE' THEN
    INSERT INTO emp_cdc (emp_id, first_name, last_name, dob, city, action)
    VALUES (OLD.emp_id, OLD.first_name, OLD.last_name, OLD.dob, OLD.city, 'DELETE');
    RETURN OLD;

  END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER emp_trigger
AFTER INSERT OR UPDATE OR DELETE ON project_2.employees
FOR EACH ROW
EXECUTE FUNCTION trigger_emp_cdc();

INSERT INTO project_2.employees (first_name, last_name, dob, city)
VALUES 
    ('Daniel', 'Williams', '1993-03-12', 'Phoenix'),
    ('Sophia', 'Davis', '1991-11-25', 'Philadelphia'),
    ('Liam', 'Miller', '1987-09-08', 'San Antonio'),
    ('Olivia', 'Garcia', '1994-06-19', 'San Diego'),
    ('Ethan', 'Martinez', '1989-02-28', 'Dallas'),
    ('Ava', 'Rodriguez', '1995-04-10', 'San Jose'),
    ('Noah', 'Wilson', '1986-12-03', 'Austin'),
    ('Isabella', 'Anderson', '1992-08-17', 'Jacksonville'),
    ('Logan', 'Taylor', '1990-10-01', 'San Francisco'),
    ('Mia', 'Thomas', '1988-01-27', 'Columbus'),
    ('Lucas', 'Hernandez', '1993-05-06', 'Fort Worth'),
    ('Charlotte', 'Moore', '1991-09-14', 'Indianapolis'),
    ('Mason', 'Martin', '1987-07-02', 'Seattle'),
    ('Amelia', 'Lee', '1994-03-21', 'Denver'),
    ('Elijah', 'Perez', '1989-11-09', 'Washington'),
    ('Harper', 'Thompson', '1995-02-18', 'Boston'),
    ('James', 'White', '1986-06-30', 'El Paso'),
    ('Evelyn', 'Harris', '1992-04-23', 'Nashville'),
    ('Benjamin', 'Clark', '1990-08-11', 'Detroit'),
    ('Abigail', 'Lewis', '1988-12-19', 'Memphis');

UPDATE project_2.employees SET city = 'Seattle' WHERE emp_id = 3;

INSERT INTO project_2.employees (first_name, last_name, dob, city)
VALUES 
    ('Jeff', 'Sung', '1990-01-01', 'Boston'),
    ('Will', 'Luk', '1985-05-15', 'Dallas');

UPDATE project_2.employees SET city = 'Dallas' WHERE emp_id = 3;