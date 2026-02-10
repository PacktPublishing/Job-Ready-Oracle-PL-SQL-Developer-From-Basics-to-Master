DECLARE
  -- Enhanced record type with department name
  TYPE emp_rec_type IS RECORD (
    emp_id        employees.employee_id%TYPE,
    emp_name      employees.last_name%TYPE,
    emp_sal       employees.salary%TYPE,
    dept_name     departments.department_name%TYPE  -- New field!
  );
  
  -- Table type remains the same
  TYPE emp_tab_type IS TABLE OF emp_rec_type;
  
  l_emp_data emp_tab_type;
BEGIN
  -- Modified SELECT with JOIN to get department names
  SELECT e.employee_id, 
         e.last_name, 
         e.salary,
         d.department_name          -- Added department_name
    BULK COLLECT INTO l_emp_data
    FROM employees e               -- Added alias 'e'
    JOIN departments d            -- JOIN with departments
      ON e.department_id = d.department_id
    WHERE e.department_id = 60
    ORDER BY e.employee_id;
    
  -- Enhanced display to show department
  DBMS_OUTPUT.PUT_LINE('IT Department Employees:');
  DBMS_OUTPUT.PUT_LINE('----------------------------------------');
  
  FOR i IN 1..l_emp_data.COUNT LOOP
    DBMS_OUTPUT.PUT_LINE(
      'ID: '    || RPAD(l_emp_data(i).emp_id, 4) || 
      ' | Name: ' || RPAD(l_emp_data(i).emp_name, 15) ||
      ' | Dept: ' || RPAD(l_emp_data(i).dept_name, 20) ||
      ' | Salary: $' || TO_CHAR(l_emp_data(i).emp_sal, '999,999'));
  END LOOP;
  
  -- Add summary
  DBMS_OUTPUT.PUT_LINE('----------------------------------------');
  DBMS_OUTPUT.PUT_LINE('Total employees: ' || l_emp_data.COUNT);
END;
/