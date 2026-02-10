DECLARE
    -- Cursor and collection types for employee data
    TYPE dept_cur_type IS REF CURSOR;
    
    -- Record type to store employee data including salary totals
    TYPE emp_dept_rec_type IS RECORD (
        dept_id     departments.department_id%TYPE,
        dept_name   departments.department_name%TYPE,
        emp_count   NUMBER,
        salary_sum  NUMBER
    );
    
    -- Collection to store department statistics
    TYPE dept_stats_tab_type IS TABLE OF emp_dept_rec_type 
        INDEX BY PLS_INTEGER;
    
    -- Variables
    v_dept_cur     dept_cur_type;
    v_dept_stats   dept_stats_tab_type;
    v_batch_size   PLS_INTEGER := 5;
    v_total_depts  PLS_INTEGER := 0;
    v_sql          VARCHAR2(2000);
    
    -- For running totals
    v_current_dept NUMBER;
    v_dept_total   NUMBER := 0;
    v_emp_count    NUMBER := 0;
    
BEGIN
    -- Dynamic SQL to get department statistics
    v_sql := 'SELECT d.department_id, d.department_name,
                     COUNT(*) as emp_count,
                     SUM(e.salary) as salary_sum
              FROM departments d
              JOIN employees e ON d.department_id = e.department_id
              GROUP BY d.department_id, d.department_name
              ORDER BY d.department_id';
              
    -- Open cursor
    DBMS_OUTPUT.PUT_LINE('Starting department analysis...');
    DBMS_OUTPUT.PUT_LINE('--------------------------------');
    
    OPEN v_dept_cur FOR v_sql;
    
    -- Process departments in batches
    LOOP
        -- Clear collection before each fetch
        v_dept_stats.DELETE;
        
        -- Fetch batch of department statistics
        FETCH v_dept_cur 
        BULK COLLECT INTO v_dept_stats LIMIT v_batch_size;
        
        -- Exit if no more departments
        EXIT WHEN v_dept_stats.COUNT = 0;
        
        -- Process each department in the batch
        FOR i IN 1..v_dept_stats.COUNT LOOP
            v_total_depts := v_total_depts + 1;
            
            -- Display department statistics
            DBMS_OUTPUT.PUT_LINE(
                'Department: ' || RPAD(v_dept_stats(i).dept_name, 20) ||
                ' | Employees: ' || LPAD(TO_CHAR(v_dept_stats(i).emp_count), 3) ||
                ' | Total Salary: $' || 
                TO_CHAR(v_dept_stats(i).salary_sum, '999,999.00')
            );
            
            -- Update running totals
            v_dept_total := v_dept_total + v_dept_stats(i).salary_sum;
            v_emp_count  := v_emp_count + v_dept_stats(i).emp_count;
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('--------------------------------');
    END LOOP;
    
    -- Always close the cursor
    CLOSE v_dept_cur;
    
    -- Display final summary
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Final Summary:');
    DBMS_OUTPUT.PUT_LINE('Total Departments: ' || v_total_depts);
    DBMS_OUTPUT.PUT_LINE('Total Employees: ' || v_emp_count);
    DBMS_OUTPUT.PUT_LINE('Total Salary Budget: $' || 
                        TO_CHAR(v_dept_total, '999,999,999.00'));

EXCEPTION
    WHEN OTHERS THEN
        -- Ensure cursor is closed in case of errors
        IF v_dept_cur%ISOPEN THEN
            CLOSE v_dept_cur;
        END IF;
        -- Re-raise the error
        RAISE;
END;

