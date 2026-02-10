DECLARE
    -- First, create your collection types
    TYPE skill_t IS TABLE OF VARCHAR2(50);
    TYPE employee_record IS RECORD (
        emp_id    NUMBER,
        name      VARCHAR2(100),
        skills    skill_t
    );
    TYPE emp_list_t IS TABLE OF employee_record INDEX BY PLS_INTEGER;
    
    -- Declare your collection
    v_employees emp_list_t;

BEGIN
    -- TODO 1: Use a qualified expression to initialize skills for employee #1
    -- Initialize first employee with skills: 'SQL', 'PL/SQL', 'Java'
    
    -- TODO 2: Use VALUES OF to print all skills for employee #1
    
    -- TODO 3: Use INDICES OF to print all employee record indices
    
    -- TODO 4: Use PAIRS OF to print both employee IDs and names
    
END;
/