DECLARE
    -- Forward declarations
    PROCEDURE manage_employee(p_emp_id IN NUMBER);
    PROCEDURE update_department(p_dept_id IN NUMBER);
    PROCEDURE assign_project(p_project_id IN NUMBER);

    -- Procedure 1: Manage Employee
    PROCEDURE manage_employee(p_emp_id IN NUMBER) IS
        v_dept_id NUMBER;
        v_project_id NUMBER;
    BEGIN
        -- Get employee's department
        SELECT department_id INTO v_dept_id
        FROM employees
        WHERE employee_id = p_emp_id;

        DBMS_OUTPUT.PUT_LINE('Managing employee: ' || p_emp_id);
        
        -- Update department
        update_department(v_dept_id);

        -- Assign a project (let's assume project ID is employee ID + 1000)
        v_project_id := p_emp_id + 1000;
        assign_project(v_project_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee not found');
    END manage_employee;

    -- Procedure 2: Update Department
    PROCEDURE update_department(p_dept_id IN NUMBER) IS
        v_emp_count NUMBER;
        v_manager_id NUMBER;
    BEGIN
        -- Get employee count
        SELECT COUNT(*) INTO v_emp_count
        FROM employees
        WHERE department_id = p_dept_id;

        DBMS_OUTPUT.PUT_LINE('Updating department: ' || p_dept_id);
        DBMS_OUTPUT.PUT_LINE('Employee count: ' || v_emp_count);

        -- If department has more than 10 employees, manage the manager
        IF v_emp_count > 10 THEN
            SELECT manager_id INTO v_manager_id
            FROM departments
            WHERE department_id = p_dept_id;

            manage_employee(v_manager_id);
        END IF;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Department not found');
    END update_department;

    -- Procedure 3: Assign Project
    PROCEDURE assign_project(p_project_id IN NUMBER) IS
        v_emp_id NUMBER;
        v_dept_id NUMBER;
    BEGIN
        -- Assume project ID is employee ID + 1000
        v_emp_id := p_project_id - 1000;

        -- Get employee's department
        SELECT department_id INTO v_dept_id
        FROM employees
        WHERE employee_id = v_emp_id;

        DBMS_OUTPUT.PUT_LINE('Assigning project: ' || p_project_id);
        DBMS_OUTPUT.PUT_LINE('To employee: ' || v_emp_id);

        -- Update the department after assigning the project
        update_department(v_dept_id);
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            DBMS_OUTPUT.PUT_LINE('Employee for project not found');
    END assign_project;

BEGIN
    -- Main execution block
    manage_employee(103);  -- Start with managing an employee
END;
