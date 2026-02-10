DECLARE
  -- Define record type based on employees table
  TYPE emp_rec_type IS RECORD (
    emp_id    employees.employee_id%TYPE,
    emp_name  employees.last_name%TYPE,
    emp_sal   employees.salary%TYPE
  );
  
  -- Define table type of records
  TYPE emp_tab_type IS TABLE OF emp_rec_type;
  
  l_emp_data emp_tab_type;
BEGIN
  -- Fetch multiple rows into collection of records
  SELECT employee_id, last_name, salary
    BULK COLLECT INTO l_emp_data
    FROM employees
    WHERE department_id = 60;
    
  -- Display results
  FOR i IN 1..l_emp_data.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Employee: ' || l_emp_data(i).emp_id ||
      ', Name: ' || l_emp_data(i).emp_name ||
      ', Salary: ' || l_emp_data(i).emp_sal);
  END LOOP;
END;
