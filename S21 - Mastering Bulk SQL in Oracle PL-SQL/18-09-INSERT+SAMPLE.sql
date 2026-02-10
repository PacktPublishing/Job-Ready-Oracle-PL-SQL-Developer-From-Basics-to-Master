SET SERVEROUTPUT ON;

DECLARE
    TYPE num_tab_type IS TABLE OF employees.employee_id%TYPE;
    TYPE name_tab_type IS TABLE OF employees.last_name%TYPE;
    
    l_emp_ids    num_tab_type;
    l_emp_names  name_tab_type;
    
    l_new_emp_id employees.employee_id%TYPE;
BEGIN
    -- Get the next employee ID
    SELECT employees_seq.NEXTVAL INTO l_new_emp_id FROM DUAL;

    -- Insert new employee and capture data
    INSERT INTO employees (employee_id, last_name, email, hire_date, job_id)
    VALUES (l_new_emp_id, 'Smith', 'JSMITH', SYSDATE, 'SA_REP')
    RETURNING employee_id, last_name
    BULK COLLECT INTO l_emp_ids, l_emp_names;
    
    -- Display results
    DBMS_OUTPUT.PUT_LINE('Inserted ' || l_emp_ids.COUNT || ' employee(s):');
    FOR i IN 1..l_emp_ids.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('Employee ID: ' || l_emp_ids(i) || ', Name: ' || l_emp_names(i));
    END LOOP;
    
    -- Rollback for demonstration purposes
    ROLLBACK;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        ROLLBACK;
END;
/
