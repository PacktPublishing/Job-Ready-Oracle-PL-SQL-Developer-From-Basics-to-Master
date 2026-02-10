DECLARE
  TYPE emp_id_type IS TABLE OF employees.employee_id%TYPE
    INDEX BY PLS_INTEGER;
  TYPE salary_type IS TABLE OF employees.salary%TYPE
    INDEX BY PLS_INTEGER;
    
  l_emp_ids    emp_id_type;
  l_salaries   salary_type;
BEGIN
  -- Populate collections
  FOR i IN 1..5 LOOP
    l_emp_ids(i) := i + 100;
    l_salaries(i) := 5000;
  END LOOP;
  
  -- Delete some elements to create sparse collections
  l_emp_ids.DELETE(2);
  l_salaries.DELETE(2);
  l_emp_ids.DELETE(4);
  l_salaries.DELETE(4);
  
  -- Use INDICES OF to process only existing elements
  FORALL i IN INDICES OF l_emp_ids
    UPDATE employees_copy
    SET salary = l_salaries(i)
    WHERE employee_id = l_emp_ids(i);
    
  DBMS_OUTPUT.PUT_LINE('Number of rows updated: ' || SQL%ROWCOUNT);
END;
/