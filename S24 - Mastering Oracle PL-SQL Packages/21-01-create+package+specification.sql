CREATE OR REPLACE PACKAGE emp_mgmt AS
  -- Define a record type for employee information
  TYPE emp_info_type IS RECORD (
    emp_id    employees.employee_id%TYPE,
    full_name VARCHAR2(100),
    job_title jobs.job_title%TYPE,
    dept_name departments.department_name%TYPE
  );
  
  -- Define a table type to hold multiple employee records
  TYPE emp_table_type IS TABLE OF emp_info_type INDEX BY PLS_INTEGER;
  
  -- Declare public procedures and functions
  PROCEDURE get_employee(p_emp_id IN employees.employee_id%TYPE, p_emp_info OUT emp_info_type);
  FUNCTION is_manager(p_emp_id IN employees.employee_id%TYPE) RETURN BOOLEAN;
  PROCEDURE get_department_employees(p_dept_id IN departments.department_id%TYPE, p_emp_table OUT emp_table_type);
END emp_mgmt;

