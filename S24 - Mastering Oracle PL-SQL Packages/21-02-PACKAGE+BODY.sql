CREATE OR REPLACE PACKAGE BODY emp_mgmt AS
  -- Private cursor declaration
  CURSOR emp_cur(p_dept_id departments.department_id%TYPE) IS
    SELECT e.employee_id, e.first_name || ' ' || e.last_name AS full_name,
           j.job_title, d.department_name
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.department_id = p_dept_id;

  -- Implement get_employee procedure
  PROCEDURE get_employee(p_emp_id IN employees.employee_id%TYPE, p_emp_info OUT emp_info_type) IS
  BEGIN
    SELECT e.employee_id, e.first_name || ' ' || e.last_name,
           j.job_title, d.department_name
    INTO p_emp_info
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    JOIN departments d ON e.department_id = d.department_id
    WHERE e.employee_id = p_emp_id;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      p_emp_info := NULL;
  END get_employee;

  -- Implement is_manager function
  FUNCTION is_manager(p_emp_id IN employees.employee_id%TYPE) RETURN BOOLEAN IS
    v_direct_reports NUMBER;
  BEGIN
    SELECT COUNT(*)
    INTO v_direct_reports
    FROM employees
    WHERE manager_id = p_emp_id;
    
    RETURN v_direct_reports > 0;
  END is_manager;

  -- Implement get_department_employees procedure
  PROCEDURE get_department_employees(p_dept_id IN departments.department_id%TYPE, p_emp_table OUT emp_table_type) IS
    v_index PLS_INTEGER := 1;
  BEGIN
    p_emp_table.DELETE;  -- Clear the table
    FOR emp_rec IN emp_cur(p_dept_id) LOOP
      p_emp_table(v_index) := emp_rec;
      v_index := v_index + 1;
    END LOOP;
  END get_department_employees;

  -- Package initialization
  BEGIN
    last_accessed_emp := 0;
    DBMS_OUTPUT.PUT_LINE('emp_mgmt package initialized');
  END emp_mgmt;