DECLARE
  -- Define collection types for employee data
  TYPE emp_id_type IS TABLE OF employees.employee_id%TYPE
    INDEX BY PLS_INTEGER;
  TYPE salary_type IS TABLE OF employees.salary%TYPE
    INDEX BY PLS_INTEGER;

  l_emp_ids    emp_id_type;   -- Collection for employee IDs
  l_salaries   salary_type;   -- Collection for salaries
  l_start_time NUMBER;        -- Variable to store start time
  l_end_time   NUMBER;        -- Variable to store end time
BEGIN
  -- Populate collections with employee data
  FOR i IN 1..100 LOOP
    l_emp_ids(i) := i + 1000;  -- Employee IDs start at 1001
    l_salaries(i) := 5000;     -- All salaries set to 5000
  END LOOP;

  -- First approach: Regular FOR loop
  l_start_time := DBMS_UTILITY.GET_TIME;  -- Capture start time

  FOR i IN 1..100 LOOP
    UPDATE employees_copy
    SET salary = l_salaries(i)
    WHERE employee_id = l_emp_ids(i);   -- Update employee salary row-by-row
  END LOOP;

  l_end_time := DBMS_UTILITY.GET_TIME;  -- Capture end time
  DBMS_OUTPUT.PUT_LINE('FOR loop duration: ' || TO_CHAR(l_end_time - l_start_time) || ' hsecs');

  ROLLBACK;  -- Roll back changes to maintain consistency for demonstration

  -- Second approach: FORALL statement
  l_start_time := DBMS_UTILITY.GET_TIME;  -- Capture start time

  FORALL i IN 1..100
    UPDATE employees_copy
    SET salary = l_salaries(i)
    WHERE employee_id = l_emp_ids(i);   -- Bulk operation for all updates

  l_end_time := DBMS_UTILITY.GET_TIME;  -- Capture end time
  DBMS_OUTPUT.PUT_LINE('FORALL duration: ' || TO_CHAR(l_end_time - l_start_time) || ' hsecs');

  ROLLBACK;  -- Roll back changes for the sake of this test
END;
/
