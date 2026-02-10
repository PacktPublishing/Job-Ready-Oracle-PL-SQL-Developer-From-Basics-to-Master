DECLARE
  -- Define collection types for employee data
  TYPE t_emp_ids IS TABLE OF employees.employee_id%TYPE;
  TYPE t_emp_names IS TABLE OF employees.last_name%TYPE;
  TYPE t_emp_sals IS TABLE OF employees.salary%TYPE;
  
  l_emp_ids    t_emp_ids;
  l_emp_names  t_emp_names;
  l_emp_sals   t_emp_sals;
BEGIN
  -- Fetch multiple columns into separate collections
  SELECT employee_id, last_name, salary
    BULK COLLECT INTO l_emp_ids, l_emp_names, l_emp_sals
    FROM employees
    WHERE department_id = 80;
    
  -- Display results
  FOR i IN 1..l_emp_ids.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(
      'Employee: ' || l_emp_ids(i) ||
      ', Name: ' || l_emp_names(i) ||
      ', Salary: ' || l_emp_sals(i));
  END LOOP;
END;
