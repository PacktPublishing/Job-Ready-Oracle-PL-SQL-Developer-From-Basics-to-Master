-- THIS IS THE SAMPLE EXPLORED IN THE LECTURE
DECLARE
  CURSOR emp_cur IS
    SELECT employee_id, last_name, salary
    FROM employees
    WHERE department_id = 50;
    
  TYPE emp_rec_type IS RECORD (
    emp_id    employees.employee_id%TYPE,
    emp_name  employees.last_name%TYPE,
    emp_sal   employees.salary%TYPE
  );
  
  TYPE emp_tab_type IS TABLE OF emp_rec_type;
  
  l_emp_data emp_tab_type;
  l_batch_size PLS_INTEGER := 10; -- Process 10 rows at a time
BEGIN
  OPEN emp_cur;
  
  LOOP
    FETCH emp_cur
    BULK COLLECT INTO l_emp_data
    LIMIT l_batch_size;
    
    EXIT WHEN l_emp_data.COUNT = 0;
    
    -- Process current batch
    FOR i IN 1..l_emp_data.COUNT LOOP
      DBMS_OUTPUT.PUT_LINE(
        'Processing Employee: ' || l_emp_data(i).emp_id ||
        ', Name: ' || l_emp_data(i).emp_name);
    END LOOP;
  END LOOP;
  
  CLOSE emp_cur;
END;