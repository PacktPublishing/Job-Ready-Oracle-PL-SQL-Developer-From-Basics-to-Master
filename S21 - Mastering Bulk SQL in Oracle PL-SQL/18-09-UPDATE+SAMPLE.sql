SET SERVEROUTPUT ON;

DECLARE
    TYPE num_tab_type IS TABLE OF employees.employee_id%TYPE;
    TYPE name_tab_type IS TABLE OF employees.last_name%TYPE;
    TYPE salary_tab_type IS TABLE OF employees.salary%TYPE;
    
    l_emp_ids    num_tab_type;
    l_emp_names  name_tab_type;
    l_salaries   salary_tab_type;
BEGIN
    -- Update salaries and collect affected employee information
    UPDATE employees
    SET salary = salary * 1.1
    WHERE department_id = 30
    RETURNING employee_id, last_name, salary
    BULK COLLECT INTO l_emp_ids, l_emp_names, l_salaries;
    
    -- Display results
    DBMS_OUTPUT.PUT_LINE('Updated ' || l_emp_ids.COUNT || ' employee(s):');
    FOR i IN 1..l_emp_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || l_emp_ids(i) || 
                             ', Name: ' || l_emp_names(i) || 
                             ', New Salary: ' || l_salaries(i));
    END LOOP;
    
    -- Rollback for demonstration purposes
    ROLLBACK;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
