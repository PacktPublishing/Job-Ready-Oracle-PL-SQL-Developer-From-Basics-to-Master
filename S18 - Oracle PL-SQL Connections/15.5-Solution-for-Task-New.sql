DECLARE
    -- Collection type definitions
    TYPE skill_t IS TABLE OF VARCHAR2(50);
    TYPE employee_record IS RECORD (
        emp_id    NUMBER,
        name      VARCHAR2(100),
        skills    skill_t
    );
    TYPE emp_list_t IS TABLE OF employee_record INDEX BY PLS_INTEGER;
    
    -- Declare the collection
    v_employees emp_list_t;

BEGIN
    -- Initialize first employee using qualified expression
    v_employees(1).skills := skill_t('SQL', 'PL/SQL', 'Java');
    v_employees(1).emp_id := 101;
    v_employees(1).name := 'John Doe';
    
    -- Let's add a second employee to make it more interesting
    v_employees(2).skills := skill_t('Python', 'React', 'Docker');
    v_employees(2).emp_id := 102;
    v_employees(2).name := 'Jane Smith';
    
    -- Task 1: Print all skills for employee #1 using VALUES OF
    DBMS_OUTPUT.PUT_LINE('Skills for ' || v_employees(1).name || ':');
    FOR skill IN VALUES OF v_employees(1).skills LOOP
        DBMS_OUTPUT.PUT_LINE('- ' || skill);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CHR(10)); -- Add blank line for readability
    
    -- Task 2: Print record indices using INDICES OF
    DBMS_OUTPUT.PUT_LINE('Employee Record Indices:');
    FOR idx IN INDICES OF v_employees LOOP
        DBMS_OUTPUT.PUT_LINE('Index: ' || idx);
    END LOOP;
    DBMS_OUTPUT.PUT_LINE(CHR(10));
    
    -- Task 3: Print employee details using PAIRS OF
    DBMS_OUTPUT.PUT_LINE('Employee Details:');
    FOR i, emp IN PAIRS OF v_employees LOOP
        DBMS_OUTPUT.PUT_LINE('ID: ' || emp.emp_id || ', Name: ' || emp.name);
        DBMS_OUTPUT.PUT_LINE('Skills:');
        -- Nested loop to show skills for each employee
        FOR skill IN VALUES OF emp.skills LOOP
            DBMS_OUTPUT.PUT_LINE('  - ' || skill);
        END LOOP;
        DBMS_OUTPUT.PUT_LINE(CHR(10));
    END LOOP;
END;
/