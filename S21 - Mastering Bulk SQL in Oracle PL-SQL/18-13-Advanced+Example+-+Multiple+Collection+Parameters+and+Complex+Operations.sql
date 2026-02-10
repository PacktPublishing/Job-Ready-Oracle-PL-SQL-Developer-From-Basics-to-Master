DECLARE
    -- Collection types
    TYPE number_table_type IS TABLE OF NUMBER 
        INDEX BY PLS_INTEGER;
    TYPE varchar_table_type IS TABLE OF VARCHAR2(100) 
        INDEX BY PLS_INTEGER;
    TYPE salary_table_type IS TABLE OF employees.salary%TYPE 
        INDEX BY PLS_INTEGER;
    
    -- Declare collections
    v_emp_ids     number_table_type;
    v_dept_ids    number_table_type;
    v_emp_names   varchar_table_type;
    v_salaries    salary_table_type;
    
    -- Cursor type
    TYPE ref_cursor_type IS REF CURSOR;
    v_result_set  ref_cursor_type;
    
    -- Other variables
    v_sql         VARCHAR2(4000);
    v_where_clause VARCHAR2(1000);
    v_params_clause VARCHAR2(1000);
    v_dept_list   VARCHAR2(500);
    v_min_salary  NUMBER := 5000;
    v_count       NUMBER := 0;
    
    -- For error handling
    v_error_occurred BOOLEAN := FALSE;
BEGIN
    -- Initialize department list
    v_dept_ids(1) := 60;  -- IT
    v_dept_ids(2) := 90;  -- Executive
    v_dept_ids(3) := 100; -- Finance
    
    -- Create department IN-list
    FOR i IN v_dept_ids.FIRST..v_dept_ids.LAST LOOP
        IF i > v_dept_ids.FIRST THEN
            v_dept_list := v_dept_list || ',';
        END IF;
        v_dept_list := v_dept_list || v_dept_ids(i);
    END LOOP;
    
    -- Build dynamic query with multiple conditions
    v_sql := 'SELECT employee_id, last_name, salary, department_id 
              FROM employees 
              WHERE department_id IN (' || v_dept_list || ')
              AND salary >= :1
              ORDER BY department_id, salary DESC';
              
    -- Open cursor with parameter
    OPEN v_result_set FOR v_sql USING v_min_salary;
    
    -- Fetch and process results
    LOOP
        -- Fetch employee data into collections
        FETCH v_result_set 
        BULK COLLECT INTO v_emp_ids, v_emp_names, v_salaries, v_dept_ids 
        LIMIT 10;
        
        EXIT WHEN v_emp_ids.COUNT = 0;
        
        -- Process each batch
        FOR i IN v_emp_ids.FIRST..v_emp_ids.LAST LOOP
            v_count := v_count + 1;
            BEGIN
                -- Build dynamic update statement
                v_sql := 'UPDATE employees 
                         SET salary = :1 
                         WHERE employee_id = :2 
                         RETURNING last_name INTO :3';
                         
                -- Perform update with salary increase
                EXECUTE IMMEDIATE v_sql 
                USING (v_salaries(i) * 1.05), 
                      v_emp_ids(i) 
                RETURNING INTO v_emp_names(i);
                
                -- Display update information
                DBMS_OUTPUT.PUT_LINE(
                    'Updated: ' || v_emp_names(i) ||
                    ' (ID: ' || v_emp_ids(i) ||
                    ', Dept: ' || v_dept_ids(i) ||
                    ') New Salary: $' || (v_salaries(i) * 1.05)
                );
                
            EXCEPTION
                WHEN OTHERS THEN
                    v_error_occurred := TRUE;
                    DBMS_OUTPUT.PUT_LINE(
                        'Error updating employee ' || v_emp_ids(i) ||
                        ': ' || SQLERRM
                    );
            END;
        END LOOP;
        
        -- Commit after each batch
        IF NOT v_error_occurred THEN
            COMMIT;
            DBMS_OUTPUT.PUT_LINE('Batch committed successfully.');
        ELSE
            ROLLBACK;
            DBMS_OUTPUT.PUT_LINE('Batch rolled back due to errors.');
        END IF;
    END LOOP;
    
    -- Close cursor
    CLOSE v_result_set;
    
    -- Final summary
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Processing Complete:');
    DBMS_OUTPUT.PUT_LINE('Total records processed: ' || v_count);
    
EXCEPTION
    WHEN OTHERS THEN
        IF v_result_set%ISOPEN THEN
            CLOSE v_result_set;
        END IF;
        ROLLBACK;
        RAISE;
END;