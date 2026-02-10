SET SERVEROUTPUT ON;

DECLARE
    TYPE emp_id_type IS TABLE OF employees.employee_id%TYPE;
    TYPE name_type IS TABLE OF employees.last_name%TYPE;
    TYPE salary_type IS TABLE OF employees.salary%TYPE;
    
    l_emp_ids    emp_id_type;
    l_emp_names  name_type;
    l_salaries   salary_type;
    
    no_employees_updated EXCEPTION;
    negative_salary EXCEPTION;
    v_department_id NUMBER := 999; -- Non-existent department for demonstration
    v_raise_percentage NUMBER := 1.1; -- 10% raise
    
BEGIN
    -- Check if department exists and has employees
    DECLARE
        v_dept_count NUMBER;
        v_emp_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_dept_count
        FROM departments
        WHERE department_id = v_department_id;
        
        IF v_dept_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20001, 'Department does not exist');
        END IF;
        
        SELECT COUNT(*) INTO v_emp_count
        FROM employees
        WHERE department_id = v_department_id;
        
        IF v_emp_count = 0 THEN
            RAISE_APPLICATION_ERROR(-20002, 'Department exists but has no employees');
        END IF;
    END;

    -- Update salaries and collect affected employee information
    UPDATE employees
    SET salary = salary * v_raise_percentage
    WHERE department_id = v_department_id
    RETURNING employee_id, last_name, salary
    BULK COLLECT INTO l_emp_ids, l_emp_names, l_salaries;
    
    IF l_emp_ids.COUNT = 0 THEN
        RAISE no_employees_updated;
    END IF;
    
    -- Check for negative salaries
    FOR i IN 1..l_salaries.COUNT LOOP
        IF l_salaries(i) < 0 THEN
            RAISE negative_salary;
        END IF;
    END LOOP;
    
    -- If we get here, we updated some employees successfully
    DBMS_OUTPUT.PUT_LINE('Updated ' || l_emp_ids.COUNT || ' employees:');
    FOR i IN 1..l_emp_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || l_emp_ids(i) || 
                             ', Name: ' || l_emp_names(i) ||
                             ', New Salary: ' || l_salaries(i));
    END LOOP;
    
EXCEPTION
    WHEN no_employees_updated THEN
        DBMS_OUTPUT.PUT_LINE('No employees were updated. Check your department ID!');
    WHEN negative_salary THEN
        DBMS_OUTPUT.PUT_LINE('Error: Negative salary detected after update.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/