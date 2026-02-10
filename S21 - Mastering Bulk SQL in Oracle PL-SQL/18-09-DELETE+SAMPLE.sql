SET SERVEROUTPUT ON;

DECLARE
    TYPE num_tab_type IS TABLE OF employees.employee_id%TYPE;
    TYPE name_tab_type IS TABLE OF employees.last_name%TYPE;
    TYPE date_tab_type IS TABLE OF employees.hire_date%TYPE;
    
    l_emp_ids    num_tab_type;
    l_emp_names  name_tab_type;
    l_hire_dates date_tab_type;
BEGIN
    -- Delete employees and capture their information
    DELETE FROM employees
    WHERE hire_date < DATE '2005-01-01'
    RETURNING employee_id, last_name, hire_date
    BULK COLLECT INTO l_emp_ids, l_emp_names, l_hire_dates;
    
    -- Display results
    DBMS_OUTPUT.PUT_LINE('Deleted ' || l_emp_ids.COUNT || ' employee(s):');
    FOR i IN 1..l_emp_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || l_emp_ids(i) || 
                             ', Name: ' || l_emp_names(i) || 
                             ', Hire Date: ' || TO_CHAR(l_hire_dates(i), 'YYYY-MM-DD'));
    END LOOP;
    
    -- Rollback for demonstration purposes
    ROLLBACK;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
