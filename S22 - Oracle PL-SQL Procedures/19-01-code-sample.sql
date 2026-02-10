DECLARE
    -- Variables for the main block
    v_emp_count    NUMBER;
    v_dept_name    VARCHAR2(30);
    
    -- Nested procedure definition
    PROCEDURE count_dept_employees(
        p_dept_id    IN  NUMBER,
        p_dept_name  OUT VARCHAR2,
        p_emp_count  OUT NUMBER)
    IS
    BEGIN
        -- Get department name and employee count
        SELECT d.department_name, COUNT(e.employee_id)
          INTO p_dept_name, p_emp_count
          FROM departments d
          LEFT JOIN employees e ON (d.department_id = e.department_id)
         WHERE d.department_id = p_dept_id
         GROUP BY d.department_name;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            p_dept_name := 'Department not found';
            p_emp_count := 0;
    END count_dept_employees;

BEGIN
    -- Main block execution
    count_dept_employees(60, v_dept_name, v_emp_count);
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
    DBMS_OUTPUT.PUT_LINE('Number of Employees: ' || v_emp_count);
END;