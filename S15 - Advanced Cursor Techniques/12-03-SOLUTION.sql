DECLARE
  -- Standalone cursor variables
  v_emp_cursor SYS_REFCURSOR;
  v_dept_cursor SYS_REFCURSOR;
  v_emp_list_cursor SYS_REFCURSOR;
  
  v_table_name VARCHAR2(30);
  
  -- Record types without cursor variables
  TYPE emp_record IS RECORD (
    employee_id employees.employee_id%TYPE,
    first_name employees.first_name%TYPE,
    last_name employees.last_name%TYPE
  );
  
  TYPE dept_record IS RECORD (
    department_id departments.department_id%TYPE,
    department_name departments.department_name%TYPE
  );

  v_emp emp_record;
  v_dept dept_record;
  v_emp_first_name employees.first_name%TYPE;
  v_emp_last_name employees.last_name%TYPE;

BEGIN
  -- Prompt user for table name
  v_table_name := UPPER('&table_name');

  IF v_table_name = 'EMPLOYEES' THEN
    OPEN v_emp_cursor FOR
      SELECT employee_id, first_name, last_name
      FROM employees
      WHERE ROWNUM <= 5;  -- Limit to 5 rows for demonstration

    LOOP
      FETCH v_emp_cursor INTO v_emp;
      EXIT WHEN v_emp_cursor%NOTFOUND;
      DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp.first_name || ' ' || v_emp.last_name);
    END LOOP;
    
    CLOSE v_emp_cursor;

  ELSIF v_table_name = 'DEPARTMENTS' THEN
    OPEN v_dept_cursor FOR
      SELECT department_id, department_name
      FROM departments
      WHERE ROWNUM <= 3;  -- Limit to 3 departments for demonstration

    LOOP
      FETCH v_dept_cursor INTO v_dept;
      EXIT WHEN v_dept_cursor%NOTFOUND;
      
      DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept.department_name);
      
      -- Open a nested cursor for employees in this department
      OPEN v_emp_list_cursor FOR
        SELECT first_name, last_name
        FROM employees
        WHERE department_id = v_dept.department_id;
      
      LOOP
        FETCH v_emp_list_cursor INTO v_emp_first_name, v_emp_last_name;
        EXIT WHEN v_emp_list_cursor%NOTFOUND;
        
        DBMS_OUTPUT.PUT_LINE('  Employee: ' || v_emp_first_name || ' ' || v_emp_last_name);
      END LOOP;
      
      CLOSE v_emp_list_cursor;
    END LOOP;
    
    CLOSE v_dept_cursor;

  ELSE
    DBMS_OUTPUT.PUT_LINE('Invalid table name. Please enter EMPLOYEES or DEPARTMENTS.');
  END IF;

EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    
    -- Ensure cursors are closed if they are open
    IF v_emp_cursor%ISOPEN THEN
      CLOSE v_emp_cursor;
    END IF;
    
    IF v_dept_cursor%ISOPEN THEN
      CLOSE v_dept_cursor;
    END IF;
    
    IF v_emp_list_cursor%ISOPEN THEN
      CLOSE v_emp_list_cursor;
    END IF;
END;
