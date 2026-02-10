DECLARE
    -- Define collection types
    TYPE number_table_type IS TABLE OF NUMBER 
        INDEX BY PLS_INTEGER;
    TYPE varchar_table_type IS TABLE OF VARCHAR2(100) 
        INDEX BY PLS_INTEGER;
    
    -- Declare collections
    v_dept_ids    number_table_type;
    v_emp_names   varchar_table_type;
    
    -- Other variables
    v_sql         VARCHAR2(4000);
    v_in_list     VARCHAR2(1000);
    v_count       NUMBER;
BEGIN
    -- Populate department IDs collection
    v_dept_ids(1) := 60;  -- IT
    v_dept_ids(2) := 90;  -- Executive
    v_dept_ids(3) := 100; -- Finance
    
    -- Create IN-list from collection
    v_in_list := '';
    FOR i IN v_dept_ids.FIRST..v_dept_ids.LAST LOOP
        IF i > v_dept_ids.FIRST THEN
            v_in_list := v_in_list || ',';
        END IF;
        v_in_list := v_in_list || v_dept_ids(i);
    END LOOP;
    
    -- Build and execute dynamic query
    v_sql := 'SELECT last_name 
              FROM employees 
              WHERE department_id IN (' || v_in_list || ')
              ORDER BY last_name';
              
    -- Store results in collection
    EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM (' || v_sql || ')'
    INTO v_count;
    
    DBMS_OUTPUT.PUT_LINE('Found ' || v_count || ' employees');
    DBMS_OUTPUT.PUT_LINE('In departments: ' || v_in_list);
    
    -- Fetch employee names using BULK COLLECT
    EXECUTE IMMEDIATE v_sql
    BULK COLLECT INTO v_emp_names;
    
    -- Display results
    FOR i IN v_emp_names.FIRST..v_emp_names.LAST LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || v_emp_names(i));
    END LOOP;
END;
