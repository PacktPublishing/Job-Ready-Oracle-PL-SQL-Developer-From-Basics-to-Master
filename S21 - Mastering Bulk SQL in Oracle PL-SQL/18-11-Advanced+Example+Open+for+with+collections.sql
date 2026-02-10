DECLARE
    -- Cursor types
    TYPE emp_cur_type IS REF CURSOR;
    
    -- Record types
    TYPE emp_rec_type IS RECORD (
        emp_id    employees.employee_id%TYPE,
        emp_name  employees.last_name%TYPE,
        dept_id   employees.department_id%TYPE,
        salary    employees.salary%TYPE
    );
    
    -- Collection types
    TYPE emp_tab_type IS TABLE OF emp_rec_type 
        INDEX BY PLS_INTEGER;
    
    -- Variables
    emp_cur     emp_cur_type;
    emp_tab     emp_tab_type;
    v_sql       VARCHAR2(1000);
    v_min_salary NUMBER := 5000;
    v_dept_list  VARCHAR2(100) := '60, 90, 100'; -- IT, Executive, Finance
    
    -- For error handling
    v_err_count NUMBER := 0;
BEGIN
    -- Dynamic query with multiple conditions
    v_sql := 'SELECT e.employee_id, e.last_name, 
                     e.department_id, e.salary
              FROM employees e
              WHERE e.department_id IN (' || v_dept_list || ')
              AND e.salary >= :1
              ORDER BY e.salary DESC';
              
    -- Open cursor with parameter
    OPEN emp_cur FOR v_sql USING v_min_salary;
    
    -- Fetch data in batches of 10 rows
    LOOP
        FETCH emp_cur 
        BULK COLLECT INTO emp_tab LIMIT 10;
        
        EXIT WHEN emp_tab.COUNT = 0;
        
        -- Process each batch
        DBMS_OUTPUT.PUT_LINE('Processing batch of ' || emp_tab.COUNT || ' records:');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        
        FOR i IN emp_tab.FIRST..emp_tab.LAST LOOP
            BEGIN
                -- Display employee information
                DBMS_OUTPUT.PUT_LINE(
                    'Dept ' || LPAD(emp_tab(i).dept_id, 3) ||
                    ': Employee ' || LPAD(emp_tab(i).emp_id, 3) ||
                    ' - ' || RPAD(emp_tab(i).emp_name, 20) ||
                    ' Salary: $' || TO_CHAR(emp_tab(i).salary, '999,999')
                );
                
                -- Simulate some processing
                IF emp_tab(i).salary > 15000 THEN
                    DBMS_OUTPUT.PUT_LINE('  ** High salary flagged for review **');
                END IF;
                
            EXCEPTION
                WHEN OTHERS THEN
                    v_err_count := v_err_count + 1;
                    DBMS_OUTPUT.PUT_LINE('Error processing employee ' || 
                                       emp_tab(i).emp_id || ': ' || 
                                       SQLERRM);
            END;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------------------' || CHR(10));
    END LOOP;
    
    -- Close cursor
    CLOSE emp_cur;
    
    -- Final status report
    DBMS_OUTPUT.PUT_LINE('Processing complete.');
    IF v_err_count > 0 THEN
        DBMS_OUTPUT.PUT_LINE('Errors encountered: ' || v_err_count);
    END IF;
    
EXCEPTION
    WHEN OTHERS THEN
        IF emp_cur%ISOPEN THEN
            CLOSE emp_cur;
        END IF;
        RAISE;
END;