DECLARE
  -- Parameterized cursor with default values
  CURSOR c_employees (
    p_job_title VARCHAR2 DEFAULT 'Sales Representative',
    p_salary_threshold NUMBER DEFAULT 5000
  ) IS
    SELECT first_name, last_name, job_title, salary
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    WHERE j.job_title = p_job_title
    AND e.salary > p_salary_threshold;

  v_first_name employees.first_name%TYPE;
  v_last_name employees.last_name%TYPE;
  v_job_title jobs.job_title%TYPE;
  v_salary employees.salary%TYPE;

BEGIN
  -- Test with default values
  DBMS_OUTPUT.PUT_LINE('Employees with default parameters:');
  FOR emp_rec IN c_employees LOOP
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || 
                         ' - ' || emp_rec.job_title || ' - $' || emp_rec.salary);
  END LOOP;

  -- Test with different job title
  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Programmers with salary > 6000:');
  FOR emp_rec IN c_employees('Programmer', 6000) LOOP
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || 
                         ' - ' || emp_rec.job_title || ' - $' || emp_rec.salary);
  END LOOP;

  -- Test with different salary threshold
  DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Sales Representatives with salary > 8000:');
  FOR emp_rec IN c_employees('Sales Representative', 8000) LOOP
    DBMS_OUTPUT.PUT_LINE(emp_rec.first_name || ' ' || emp_rec.last_name || 
                         ' - ' || emp_rec.job_title || ' - $' || emp_rec.salary);
  END LOOP;
END;
/