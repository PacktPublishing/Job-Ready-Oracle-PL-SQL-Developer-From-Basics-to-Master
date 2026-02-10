DECLARE
    -- Define collection types for employee data
    TYPE emp_id_tab_type IS TABLE OF employees.employee_id%TYPE 
        INDEX BY PLS_INTEGER;
    TYPE emp_name_tab_type IS TABLE OF employees.last_name%TYPE 
        INDEX BY PLS_INTEGER;
    
    -- Declare collection variables
    emp_ids    emp_id_tab_type;
    emp_names  emp_name_tab_type;
    
    -- Variable for dynamic SQL
    v_sql  VARCHAR2(1000);
BEGIN
    -- Step 1: Populate collections with employee data
    FOR i IN 100..105 LOOP  -- Using first 6 employees
        emp_ids(i-99) := i;
        SELECT last_name 
        INTO emp_names(i-99)
        FROM employees 
        WHERE employee_id = i;
    END LOOP;

    -- Step 2: Process and display data using dynamic SQL
    FOR i IN emp_ids.FIRST..emp_ids.LAST LOOP
        v_sql := 'BEGIN 
                    DBMS_OUTPUT.PUT_LINE(:1 || '': '' || :2);
                  END;';
        
        EXECUTE IMMEDIATE v_sql 
        USING emp_ids(i), emp_names(i);
    END LOOP;
END;
