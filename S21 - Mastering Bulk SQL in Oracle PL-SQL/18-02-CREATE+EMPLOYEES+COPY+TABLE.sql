-- DROP TABLE IF IT EXISTS JUST EXECUTE THE DROP TABLE COMMAND BELLOW.
-- DROP TABLE employees_copy;
CREATE TABLE employees_copy AS
SELECT *
FROM employees;


-- Add a constraint to ensure salaries cannot be negative
ALTER TABLE employees_copy
ADD CONSTRAINT salary_min CHECK (salary >= 0);
