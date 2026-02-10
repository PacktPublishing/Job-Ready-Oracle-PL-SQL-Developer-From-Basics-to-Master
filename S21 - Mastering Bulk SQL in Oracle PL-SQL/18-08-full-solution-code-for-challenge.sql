DECLARE
  -- 1) Define a record and collection for departments
  TYPE dept_rec_type IS RECORD (
    dept_id    departments.department_id%TYPE,
    batch_size PLS_INTEGER,
    emp_count  PLS_INTEGER
  );
  TYPE dept_tab_type IS TABLE OF dept_rec_type INDEX BY BINARY_INTEGER;
  l_dept_list dept_tab_type;

  -- 2) Define a record and collection for employees
  TYPE emp_rec_type IS RECORD (
    employee_id  employees.employee_id%TYPE,
    last_name    employees.last_name%TYPE,
    salary       employees.salary%TYPE,
    department_id employees.department_id%TYPE
  );
  TYPE emp_tab_type IS TABLE OF emp_rec_type INDEX BY BINARY_INTEGER;
  l_emp_data emp_tab_type;

  -- 3) Dynamic SQL variables
  v_sql VARCHAR2(1000);
  c SYS_REFCURSOR;

BEGIN
  -- 4) Initialize department list with varying batch sizes
  l_dept_list(1).dept_id := 10;    -- HR dept
  l_dept_list(1).batch_size := 50;
  l_dept_list(1).emp_count := 0;
  
  l_dept_list(2).dept_id := 20;    -- Marketing dept
  l_dept_list(2).batch_size := 100;
  l_dept_list(2).emp_count := 0;
  
  l_dept_list(3).dept_id := 30;    -- Purchasing dept
  l_dept_list(3).batch_size := 75;
  l_dept_list(3).emp_count := 0;

  -- 5) Loop through each department
  FOR i IN 1..l_dept_list.COUNT LOOP
    v_sql := 'SELECT employee_id, last_name, salary, department_id 
              FROM employees 
              WHERE department_id = :dept_id';

    -- Open a cursor for the current department using dynamic SQL
    OPEN c FOR v_sql USING l_dept_list(i).dept_id;

    -- 6) Fetch and process employees in batches
    LOOP
      FETCH c BULK COLLECT INTO l_emp_data LIMIT l_dept_list(i).batch_size;

      -- If no more rows, exit the loop
      EXIT WHEN l_emp_data.COUNT = 0;

      -- Process each employee in this batch
      FOR j IN 1..l_emp_data.COUNT LOOP
        -- Put your real processing here, for example:
        -- UPDATE employees
        --    SET salary = salary * 1.05
        --  WHERE employee_id = l_emp_data(j).employee_id;
        
        -- For demonstration, we'll just print employee details
        DBMS_OUTPUT.PUT_LINE(
          'Processed: Emp ID: ' || l_emp_data(j).employee_id ||
          ', Name: ' || l_emp_data(j).last_name ||
          ', Dept: ' || l_emp_data(j).department_id
        );
        
        -- Increment employee count for this department
        l_dept_list(i).emp_count := l_dept_list(i).emp_count + 1;
      END LOOP;
    END LOOP;

    -- Close the cursor for this department
    CLOSE c;

    -- Output a status message
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Finished processing Dept: ' || l_dept_list(i).dept_id || 
                         ' | Employees processed: ' || l_dept_list(i).emp_count ||
                         ' | Batch size: ' || l_dept_list(i).batch_size);
    DBMS_OUTPUT.PUT_LINE('----------------------------------------');
  END LOOP;
  
  -- 7) Final summary
  DBMS_OUTPUT.PUT_LINE('Processing complete. Department summaries:');
  FOR i IN 1..l_dept_list.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE('Dept ' || l_dept_list(i).dept_id || 
                         ': Processed ' || l_dept_list(i).emp_count || 
                         ' employees (Batch size: ' || l_dept_list(i).batch_size || ')');
  END LOOP;
END;
/