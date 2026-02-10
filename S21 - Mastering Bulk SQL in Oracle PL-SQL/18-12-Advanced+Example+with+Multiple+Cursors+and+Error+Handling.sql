DECLARE
    -- Cursor types
    TYPE emp_cur_type IS REF CURSOR;
    
    -- Record types
    TYPE emp_rec_type IS RECORD (
        emp_id    employees.employee_id%TYPE,
        emp_name  employees.last_name%TYPE,
        salary    employees.salary%TYPE
    );
    
    -- Collection types
    TYPE emp_tab_type IS TABLE OF emp_rec_type 
        INDEX BY PLS_INTEGER;
    
    -- Cursor variables
    emp_cur_it      emp_cur_type;  -- IT Department
    emp_cur_sales   emp_cur_type;  -- Sales Department
    
    -- Collection variables
    emp_tab_it      emp_tab_type;
    emp_tab_sales   emp_tab_type;
    
    -- Other variables
    v_sql           VARCHAR2(1000);
    v_batch_size    PLS_INTEGER := 5;
    v_processed_it  PLS_INTEGER := 0;
    v_processed_sales PLS_INTEGER := 0;
    
    -- Custom exception
    cursor_error EXCEPTION;
BEGIN
    -- Prepare SQL statements
    v_sql := 'SELECT employee_id, last_name, salary 
              FROM employees 
              WHERE department_id = :1 
              ORDER BY salary DESC';
    
    -- Open cursors for different departments
    OPEN emp_cur_it FOR v_sql USING 60;     -- IT
    OPEN emp_cur_sales FOR v_sql USING 80;  -- Sales
    
    -- Process both departments simultaneously
    LOOP
        -- Fetch IT department employees
        FETCH emp_cur_it 
        BULK COLLECT INTO emp_tab_it LIMIT v_batch_size;
        
        -- Fetch Sales department employees
        FETCH emp_cur_sales 
        BULK COLLECT INTO emp_tab_sales LIMIT v_batch_size;
        
        -- Exit if both fetches return no rows
        EXIT WHEN emp_tab_it.COUNT = 0 AND emp_tab_sales.COUNT = 0;
        
        -- Process IT department records
        IF emp_tab_it.COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('IT Department Batch:');
            DBMS_OUTPUT.PUT_LINE('-------------------');
            FOR i IN 1..emp_tab_it.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE(
                    'IT: ' || emp_tab_it(i).emp_name ||
                    ' (ID: ' || emp_tab_it(i).emp_id ||
                    ') Salary: $' || emp_tab_it(i).salary
                );
                v_processed_it := v_processed_it + 1;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(CHR(10));
        END IF;
        
        -- Process Sales department records
        IF emp_tab_sales.COUNT > 0 THEN
            DBMS_OUTPUT.PUT_LINE('Sales Department Batch:');
            DBMS_OUTPUT.PUT_LINE('----------------------');
            FOR i IN 1..emp_tab_sales.COUNT LOOP
                DBMS_OUTPUT.PUT_LINE(
                    'Sales: ' || emp_tab_sales(i).emp_name ||
                    ' (ID: ' || emp_tab_sales(i).emp_id ||
                    ') Salary: $' || emp_tab_sales(i).salary
                );
                v_processed_sales := v_processed_sales + 1;
            END LOOP;
            DBMS_OUTPUT.PUT_LINE(CHR(10));
        END IF;
    END LOOP;
    
    -- Close cursors
    IF emp_cur_it%ISOPEN THEN
        CLOSE emp_cur_it;
    END IF;
    
    IF emp_cur_sales%ISOPEN THEN
        CLOSE emp_cur_sales;
    END IF;
    
    -- Display summary
    DBMS_OUTPUT.PUT_LINE('Processing Complete:');
    DBMS_OUTPUT.PUT_LINE('IT Department: ' || v_processed_it || ' records');
    DBMS_OUTPUT.PUT_LINE('Sales Department: ' || v_processed_sales || ' records');
    DBMS_OUTPUT.PUT_LINE('Total: ' || (v_processed_it + v_processed_sales) || ' records');
    
EXCEPTION
    WHEN cursor_error THEN
        DBMS_OUTPUT.PUT_LINE('Error processing cursors');
        -- Ensure all cursors are closed
        IF emp_cur_it%ISOPEN THEN
            CLOSE emp_cur_it;
        END IF;
        IF emp_cur_sales%ISOPEN THEN
            CLOSE emp_cur_sales;
        END IF;
        RAISE;
        
    WHEN OTHERS THEN
        -- Close any open cursors
        IF emp_cur_it%ISOPEN THEN
            CLOSE emp_cur_it;
        END IF;
        IF emp_cur_sales%ISOPEN THEN
            CLOSE emp_cur_sales;
        END IF;
        RAISE;
END;