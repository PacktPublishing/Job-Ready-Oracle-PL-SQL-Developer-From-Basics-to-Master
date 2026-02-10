DECLARE
    TYPE emp_cur_type IS REF CURSOR;
    TYPE emp_rec_type IS RECORD (
        emp_id      employees.employee_id%TYPE,
        emp_name    employees.last_name%TYPE,
        dept_id     employees.department_id%TYPE,
        salary      employees.salary%TYPE,
        raise_count NUMBER
    );
    TYPE emp_tab_type IS TABLE OF emp_rec_type 
         INDEX BY PLS_INTEGER;
         
    emp_cur       emp_cur_type;
    emp_tab       emp_tab_type;
    v_sql         VARCHAR2(4000);
    v_fetch_count PLS_INTEGER := 0;
    v_total_rows  PLS_INTEGER := 0;
    
BEGIN
    v_sql := 'SELECT e.employee_id, e.last_name, 
                     e.department_id, e.salary,
                     (SELECT COUNT(*) 
                      FROM SALARY_CHANGES_LOG scl 
                      WHERE scl.employee_id = e.employee_id 
                        AND scl.change_date >= ADD_MONTHS(SYSDATE, -12)
                        AND scl.new_salary > scl.old_salary) as raise_count
              FROM employees e
              WHERE e.department_id = :1
              ORDER BY e.salary DESC';
              
    OPEN emp_cur FOR v_sql USING 60; -- IT Department
    
    DBMS_OUTPUT.PUT_LINE('Processing IT Department Employees...');
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    
    LOOP
        emp_tab.DELETE;  -- Clear collection before next fetch
        
        FETCH emp_cur
        BULK COLLECT INTO emp_tab LIMIT 5;
        
        v_fetch_count := emp_tab.COUNT;
        v_total_rows := v_total_rows + v_fetch_count;
        
        -- Process records
        FOR i IN 1..emp_tab.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Employee: ' || RPAD(emp_tab(i).emp_name, 20) ||
                ' Salary: $' || TO_CHAR(emp_tab(i).salary, '999,999') ||
                ' Raises in past year: ' || emp_tab(i).raise_count
            );
            
            -- Check if employee has received more than three raises
            IF emp_tab(i).raise_count > 3 THEN
                DBMS_OUTPUT.PUT_LINE('   *** This employee has received more than three raises in the past year! ***');
            END IF;
        END LOOP;
        
        EXIT WHEN v_fetch_count = 0;
    END LOOP;
    
    DBMS_OUTPUT.PUT_LINE('------------------------------------');
    DBMS_OUTPUT.PUT_LINE('Total Employees Processed: ' || v_total_rows);
    
    CLOSE emp_cur;
    
EXCEPTION
    WHEN OTHERS THEN
        IF emp_cur%ISOPEN THEN
            CLOSE emp_cur;
        END IF;
        RAISE;
END;
