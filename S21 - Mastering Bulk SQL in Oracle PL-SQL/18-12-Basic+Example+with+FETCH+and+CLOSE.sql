DECLARE
    -- Cursor and collection types
    TYPE emp_cur_type IS REF CURSOR;
    TYPE emp_rec_type IS RECORD (
        emp_id    employees.employee_id%TYPE,
        emp_name  employees.last_name%TYPE,
        dept_id   employees.department_id%TYPE,
        salary    employees.salary%TYPE
    );
    TYPE emp_tab_type IS TABLE OF emp_rec_type 
        INDEX BY PLS_INTEGER;
    
    -- Variables
    emp_cur     emp_cur_type;
    emp_tab     emp_tab_type;
    v_sql       VARCHAR2(1000);
    v_fetch_count PLS_INTEGER := 0;
    v_total_rows  PLS_INTEGER := 0;
BEGIN
    -- Prepare dynamic query
    v_sql := 'SELECT e.employee_id, e.last_name, 
                     e.department_id, e.salary
              FROM employees e
              WHERE e.department_id = :1
              ORDER BY e.salary DESC';
    
    -- Open cursor
    OPEN emp_cur FOR v_sql USING 60; -- IT Department
    
    -- Fetch in batches of 5 rows
    LOOP
        -- Clear collection before each fetch
        emp_tab.DELETE;
        
        -- Fetch batch of records
        FETCH emp_cur 
        BULK COLLECT INTO emp_tab LIMIT 5;
        
        -- Process fetched batch
        v_fetch_count := emp_tab.COUNT;
        v_total_rows := v_total_rows + v_fetch_count;
        
        -- Display batch information
        DBMS_OUTPUT.PUT_LINE('Processing batch of ' || 
                            v_fetch_count || ' records:');
        DBMS_OUTPUT.PUT_LINE('--------------------');
        
        -- Process records in current batch
        FOR i IN 1..v_fetch_count LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Employee ' || emp_tab(i).emp_id ||
                ' - ' || emp_tab(i).emp_name ||
                ' (Dept ' || emp_tab(i).dept_id ||
                ') Salary: $' || emp_tab(i).salary
            );
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('--------------------' || CHR(10));
        
        -- Exit when no more rows
        EXIT WHEN v_fetch_count = 0;
    END LOOP;
    
    -- Always close cursor
    CLOSE emp_cur;
    
    -- Display final count
    DBMS_OUTPUT.PUT_LINE('Total rows processed: ' || v_total_rows);
    
EXCEPTION
    WHEN OTHERS THEN
        -- Ensure cursor is closed in case of errors
        IF emp_cur%ISOPEN THEN
            CLOSE emp_cur;
        END IF;
        RAISE;
END;