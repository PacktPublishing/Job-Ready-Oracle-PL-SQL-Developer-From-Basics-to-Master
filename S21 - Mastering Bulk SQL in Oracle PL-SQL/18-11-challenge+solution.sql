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
    
    -- Collection for department totals
    TYPE dept_total_type IS TABLE OF NUMBER 
        INDEX BY PLS_INTEGER;
    
    -- Variables
    emp_cur       emp_cur_type;
    emp_tab       emp_tab_type;
    dept_totals   dept_total_type;
    v_sql         VARCHAR2(1000);
    v_batch_size  PLS_INTEGER := 5;
    v_total_rows  PLS_INTEGER := 0;
    v_curr_dept   NUMBER := 0;
    v_running_total NUMBER := 0;
BEGIN
    -- Dynamic query for all departments
    v_sql := 'SELECT e.employee_id, e.last_name, 
                     e.department_id, e.salary
              FROM employees e
              ORDER BY e.department_id, e.employee_id';
    
    -- Open cursor
    OPEN emp_cur FOR v_sql;
    
    -- Process in batches
    LOOP
        -- Clear collection before each fetch
        emp_tab.DELETE;
        
        -- Fetch batch of records
        FETCH emp_cur 
        BULK COLLECT INTO emp_tab LIMIT v_batch_size;
        
        EXIT WHEN emp_tab.COUNT = 0;
        
        -- Process each record in batch
        FOR i IN 1..emp_tab.COUNT LOOP
            -- Check if we're starting a new department
            IF emp_tab(i).dept_id != v_curr_dept THEN
                -- Display previous department total if exists
                IF v_curr_dept != 0 THEN
                    DBMS_OUTPUT.PUT_LINE(
                        '----------------------------------------');
                    DBMS_OUTPUT.PUT_LINE(
                        'Department ' || v_curr_dept || 
                        ' Total: $' || v_running_total);
                    DBMS_OUTPUT.PUT_LINE(CHR(10));
                END IF;
                
                -- Reset for new department
                v_curr_dept := emp_tab(i).dept_id;
                v_running_total := 0;
                
                -- Print department header
                DBMS_OUTPUT.PUT_LINE(
                    'Processing Department: ' || v_curr_dept);
                DBMS_OUTPUT.PUT_LINE(
                    '----------------------------------------');
            END IF;
            
            -- Update running total
            v_running_total := v_running_total + emp_tab(i).salary;
            
            -- Store department total
            dept_totals(v_curr_dept) := v_running_total;
            
            -- Display employee info
            DBMS_OUTPUT.PUT_LINE(
                'Employee: ' || RPAD(emp_tab(i).emp_name, 20) ||
                ' Salary: $' || LPAD(TO_CHAR(emp_tab(i).salary), 10) ||
                ' Running Total: $' || 
                LPAD(TO_CHAR(v_running_total), 12));
                
            v_total_rows := v_total_rows + 1;
        END LOOP;
    END LOOP;
    
    -- Display final department total
    IF v_curr_dept != 0 THEN
        DBMS_OUTPUT.PUT_LINE(
            '----------------------------------------');
        DBMS_OUTPUT.PUT_LINE(
            'Department ' || v_curr_dept || 
            ' Total: $' || v_running_total);
    END IF;
    
    -- Display grand total
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 
        '======================================');
    DBMS_OUTPUT.PUT_LINE('Summary:');
    DBMS_OUTPUT.PUT_LINE('Total employees processed: ' || v_total_rows);
    DBMS_OUTPUT.PUT_LINE('Number of departments: ' || 
        dept_totals.COUNT);
    
    -- Close cursor
    CLOSE emp_cur;
    
EXCEPTION
    WHEN OTHERS THEN
        IF emp_cur%ISOPEN THEN
            CLOSE emp_cur;
        END IF;
        RAISE;
END;
