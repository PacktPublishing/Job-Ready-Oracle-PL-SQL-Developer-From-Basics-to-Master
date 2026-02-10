CREATE OR REPLACE PROCEDURE transfer_employee
    (p_emp_id         IN  NUMBER,
     p_new_dept_id    IN  NUMBER,
     p_new_job_id     IN  VARCHAR2,
     p_new_salary     IN  NUMBER,
     p_status         OUT VARCHAR2)
IS
    v_old_dept_id    NUMBER;
    v_old_job_id     VARCHAR2(10);
    v_dept_name      VARCHAR2(100);  -- Increased size
    v_manager_id     NUMBER;
    v_hire_date      DATE;
BEGIN
    -- Get current employee details including hire_date
    SELECT department_id, job_id, hire_date
      INTO v_old_dept_id, v_old_job_id, v_hire_date
      FROM employees
     WHERE employee_id = p_emp_id;

    -- Get department details
    SELECT department_name, manager_id
      INTO v_dept_name, v_manager_id
      FROM departments
     WHERE department_id = p_new_dept_id;

    -- Validate manager
    IF v_manager_id = p_emp_id THEN
        RAISE_APPLICATION_ERROR(-20002, 
            'Employee cannot be transferred to a department they manage');
    END IF;

    -- Update employee record
    -- This will trigger UPDATE_JOB_HISTORY
    UPDATE employees
       SET department_id = p_new_dept_id,
           job_id = p_new_job_id,
           salary = p_new_salary
     WHERE employee_id = p_emp_id;

    p_status := 'Transfer successful to ' || v_dept_name;
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        p_status := 'Error: Invalid department or employee ID';
        ROLLBACK;
    WHEN OTHERS THEN
        p_status := SQLERRM;
        ROLLBACK;
END transfer_employee;