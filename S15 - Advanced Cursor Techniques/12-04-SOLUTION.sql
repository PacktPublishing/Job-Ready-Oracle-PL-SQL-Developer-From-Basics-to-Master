DECLARE
  CURSOR c_emp_update IS
    SELECT e.employee_id, e.salary, e.commission_pct, j.job_id
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    WHERE e.department_id = 50  -- Choose your department
    FOR UPDATE OF e.salary, e.commission_pct NOWAIT;
  
  v_avg_salary NUMBER;
  v_counter NUMBER := 0;
  v_batch_size CONSTANT NUMBER := 5;

BEGIN
  FOR emp_rec IN c_emp_update LOOP
    -- Get average salary for the job
    SELECT AVG(salary) INTO v_avg_salary
    FROM employees
    WHERE job_id = emp_rec.job_id;
    
    -- Update salary if below average
    IF emp_rec.salary < v_avg_salary THEN
      UPDATE employees
      SET salary = salary * 1.05
      WHERE CURRENT OF c_emp_update;
      
      DBMS_OUTPUT.PUT_LINE('Updated salary for employee ' || emp_rec.employee_id);
    END IF;
    
    -- Set commission if null
    IF emp_rec.commission_pct IS NULL THEN
      UPDATE employees
      SET commission_pct = 0.1
      WHERE CURRENT OF c_emp_update;
      
      DBMS_OUTPUT.PUT_LINE('Updated commission for employee ' || emp_rec.employee_id);
    END IF;
    
    v_counter := v_counter + 1;
    
    -- Commit every 5 employees
    IF MOD(v_counter, v_batch_size) = 0 THEN
      COMMIT;
      DBMS_OUTPUT.PUT_LINE('Committed batch of ' || v_batch_size || ' updates');
    END IF;
  END LOOP;
  
  -- Final commit for any remaining updates
  COMMIT;
  DBMS_OUTPUT.PUT_LINE('Final commit. Total updates: ' || v_counter);

EXCEPTION
  WHEN NO_DATA_FOUND THEN
    DBMS_OUTPUT.PUT_LINE('No employees found in the specified department.');
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    ROLLBACK;
END;
/