DECLARE
    -- Variables for our examples
    v_salary        NUMBER;
    v_emp_name      VARCHAR2(50);
    v_commission    NUMBER := 0;
    
    -- Example 1: IN Parameter Mode
    PROCEDURE validate_employee_salary(
        p_emp_id    IN NUMBER,
        p_job_id    IN VARCHAR2)
    IS
        v_min_salary    jobs.min_salary%TYPE;
        v_max_salary    jobs.max_salary%TYPE;
        v_curr_salary   employees.salary%TYPE;
    BEGIN
        -- Get salary range for job
        SELECT min_salary, max_salary
          INTO v_min_salary, v_max_salary
          FROM jobs
         WHERE job_id = p_job_id;
         
        -- Get employee's current salary
        SELECT salary
          INTO v_curr_salary
          FROM employees
         WHERE employee_id = p_emp_id;
         
        IF v_curr_salary BETWEEN v_min_salary AND v_max_salary THEN
            DBMS_OUTPUT.PUT_LINE('Salary is within valid range');
        ELSE
            DBMS_OUTPUT.PUT_LINE('Salary is out of range');
        END IF;
    END validate_employee_salary;

    -- Example 2: OUT Parameter Mode
    PROCEDURE get_employee_details(
        p_emp_id    IN  NUMBER,
        p_name      OUT VARCHAR2,
        p_salary    OUT NUMBER)
    IS
    BEGIN
        SELECT first_name || ' ' || last_name,
               salary
          INTO p_name, p_salary
          FROM employees
         WHERE employee_id = p_emp_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_name   := 'Employee not found';
            p_salary := 0;
    END get_employee_details;

    -- Example 3: IN OUT Parameter Mode
    PROCEDURE calculate_commission(
        p_salary        IN     NUMBER,
        p_commission    IN OUT NUMBER)
    IS
        v_commission_rate   NUMBER := 0.02;  -- 2% commission rate
    BEGIN
        -- Update commission based on salary
        p_commission := p_salary * v_commission_rate;
        
        -- Apply minimum commission rule
        IF p_commission < 100 THEN
            p_commission := 100;  -- Minimum commission
        END IF;
    END calculate_commission;

BEGIN
    -- Main execution block
    -- Example 1: Call validate_employee_salary
    validate_employee_salary(103, 'IT_PROG');
    
    -- Example 2: Call get_employee_details
    get_employee_details(103, v_emp_name, v_salary);
    DBMS_OUTPUT.PUT_LINE('Employee: ' || v_emp_name);
    DBMS_OUTPUT.PUT_LINE('Salary: $' || v_salary);
    
    -- Example 3: Call calculate_commission
    v_commission := 0;  -- Initialize commission
    calculate_commission(v_salary, v_commission);
    DBMS_OUTPUT.PUT_LINE('Commission: $' || v_commission);
END;
/