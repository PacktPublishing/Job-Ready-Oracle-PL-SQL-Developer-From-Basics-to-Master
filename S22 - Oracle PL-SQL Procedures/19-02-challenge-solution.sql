CREATE OR REPLACE PROCEDURE calculate_employee_raise(
    p_emp_id        IN      NUMBER,
    p_raise_percent IN      NUMBER,
    p_old_salary    OUT     NUMBER,
    p_new_salary    OUT     NUMBER,
    p_job_title     IN OUT  VARCHAR2
)
IS
    v_min_salary    NUMBER;
    v_max_salary    NUMBER;
    v_calculated_salary NUMBER;
BEGIN
    -- Fetch current salary and job details
    SELECT e.salary, e.job_id, j.job_title, j.min_salary, j.max_salary
    INTO p_old_salary, p_job_title, p_job_title, v_min_salary, v_max_salary
    FROM employees e
    JOIN jobs j ON e.job_id = j.job_id
    WHERE e.employee_id = p_emp_id;

    -- Calculate the new salary
    v_calculated_salary := p_old_salary * (1 + p_raise_percent / 100);

    -- Validate the new salary against job salary range
    IF v_calculated_salary BETWEEN v_min_salary AND v_max_salary THEN
        p_new_salary := v_calculated_salary;
    ELSE
        -- If new salary is out of range, cap it at the maximum
        p_new_salary := LEAST(v_calculated_salary, v_max_salary);
    END IF;

    -- Update the employee's salary in the database
    UPDATE employees
    SET salary = p_new_salary
    WHERE employee_id = p_emp_id;

    -- Commit the transaction
    COMMIT;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20001, 'Employee not found');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE_APPLICATION_ERROR(-20002, 'An error occurred: ' || SQLERRM);
END calculate_employee_raise;



-- Block to execute the procedure
DECLARE
    v_emp_id NUMBER := 103; -- Example employee ID
    v_raise_percent NUMBER := 10; -- 10% raise
    v_old_salary NUMBER;
    v_new_salary NUMBER;
    v_job_title VARCHAR2(35) := NULL; -- We don't know the job title initially
BEGIN
    calculate_employee_raise(
        p_emp_id => v_emp_id,
        p_raise_percent => v_raise_percent,
        p_old_salary => v_old_salary,
        p_new_salary => v_new_salary,
        p_job_title => v_job_title
    );
    
    DBMS_OUTPUT.PUT_LINE('Employee ID: ' || v_emp_id);
    DBMS_OUTPUT.PUT_LINE('Job Title: ' || v_job_title);
    DBMS_OUTPUT.PUT_LINE('Old Salary: $' || v_old_salary);
    DBMS_OUTPUT.PUT_LINE('New Salary: $' || v_new_salary);
    DBMS_OUTPUT.PUT_LINE('Raise Amount: $' || (v_new_salary - v_old_salary));
END;
/