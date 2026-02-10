DECLARE
    -- Record type for employee role assignment
    TYPE emp_role_rec IS RECORD (
        emp_id    employees.employee_id%TYPE,
        emp_name  VARCHAR2(100),
        role      VARCHAR2(50)
    );
    
    -- Nested table type for employee assignments
    TYPE emp_list_type IS TABLE OF emp_role_rec;
    
    -- Main collection: Project ID -> List of employees with roles
    TYPE project_assignments_type IS TABLE OF emp_list_type
        INDEX BY PLS_INTEGER;
    
    -- Main collection variable
    project_assignments project_assignments_type;
    
    -- Constants for project IDs
    c_proj_1 CONSTANT PLS_INTEGER := 1001;
    c_proj_2 CONSTANT PLS_INTEGER := 1002;
    
    -- Helper procedure to print project details
    PROCEDURE print_project_details(
        p_project_id IN NUMBER,
        p_project_name IN VARCHAR2
    ) IS
    BEGIN
        DBMS_OUTPUT.PUT_LINE(CHR(10) || 
            'Project: ' || p_project_name || ' (ID: ' || p_project_id || ')');
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        
        IF project_assignments.EXISTS(p_project_id) THEN
            FOR i IN 1..project_assignments(p_project_id).COUNT LOOP
                DBMS_OUTPUT.PUT_LINE(
                    RPAD('Employee ID: ' || project_assignments(p_project_id)(i).emp_id, 15) ||
                    RPAD('Name: ' || project_assignments(p_project_id)(i).emp_name, 35) ||
                    'Role: ' || project_assignments(p_project_id)(i).role
                );
            END LOOP;
            DBMS_OUTPUT.PUT_LINE('Total team members: ' || 
                project_assignments(p_project_id).COUNT);
        ELSE
            DBMS_OUTPUT.PUT_LINE('No employees assigned to this project.');
        END IF;
    END print_project_details;
    
    -- Helper procedure to add employee to project
    PROCEDURE add_employee_to_project(
        p_project_id IN NUMBER,
        p_emp_id IN NUMBER,
        p_role IN VARCHAR2
    ) IS
        v_emp_name VARCHAR2(100);
        v_emp_rec emp_role_rec;
    BEGIN
        -- Get employee name
        SELECT first_name || ' ' || last_name
        INTO v_emp_name
        FROM employees
        WHERE employee_id = p_emp_id;
        
        -- Initialize project if it doesn't exist
        IF NOT project_assignments.EXISTS(p_project_id) THEN
            project_assignments(p_project_id) := emp_list_type();
        END IF;
        
        -- Create employee record
        v_emp_rec.emp_id := p_emp_id;
        v_emp_rec.emp_name := v_emp_name;
        v_emp_rec.role := p_role;
        
        -- Add to project
        project_assignments(p_project_id).EXTEND;
        project_assignments(p_project_id)(project_assignments(p_project_id).LAST) := v_emp_rec;
    END add_employee_to_project;
    
BEGIN
    -- Initialize projects with employees
    -- Project 1: Web Application Development
    add_employee_to_project(c_proj_1, 103, 'Project Manager');    -- Alexander
    add_employee_to_project(c_proj_1, 104, 'Lead Developer');     -- Bruce
    add_employee_to_project(c_proj_1, 105, 'Developer');          -- David
    add_employee_to_project(c_proj_1, 106, 'Tester');            -- Valli
    
    -- Project 2: Mobile App Development
    add_employee_to_project(c_proj_2, 107, 'Project Manager');    -- Diana
    add_employee_to_project(c_proj_2, 108, 'Developer');          -- Nancy
    add_employee_to_project(c_proj_2, 109, 'Tester');            -- Daniel
    
    -- Print initial project assignments
    DBMS_OUTPUT.PUT_LINE('Initial Project Assignments:');
    DBMS_OUTPUT.PUT_LINE('============================');
    print_project_details(c_proj_1, 'Web Application Development');
    print_project_details(c_proj_2, 'Mobile App Development');
    
    -- Remove an employee from Project 1 (remove the tester)
    FOR i IN 1..project_assignments(c_proj_1).COUNT LOOP
        IF project_assignments(c_proj_1)(i).role = 'Tester' THEN
            -- Remove this employee by moving last element to this position
            project_assignments(c_proj_1)(i) := 
                project_assignments(c_proj_1)(project_assignments(c_proj_1).LAST);
            project_assignments(c_proj_1).TRIM;
            EXIT;
        END IF;
    END LOOP;
    
    -- Print updated project assignments
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 
        'Project Assignments After Removing Tester from Project 1:');
    DBMS_OUTPUT.PUT_LINE('================================================');
    print_project_details(c_proj_1, 'Web Application Development');
    print_project_details(c_proj_2, 'Mobile App Development');

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Employee not found in employees table.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
END;
