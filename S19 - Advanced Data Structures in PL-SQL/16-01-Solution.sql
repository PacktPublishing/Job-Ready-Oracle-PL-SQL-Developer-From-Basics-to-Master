DECLARE
    -- Custom record type for department summary
    TYPE dept_summary_type IS RECORD (
        dept_id         departments.department_id%TYPE,    -- Using %TYPE for exact match
        dept_name       departments.department_name%TYPE,
        manager_name    VARCHAR2(100),
        employee_count  NUMBER,
        avg_salary     NUMBER(10,2)
    );
    
    -- Variable of our custom record type
    dept_summary dept_summary_type;
    
    -- Constants for formatting
    c_department_id CONSTANT NUMBER := 60;  -- Department we want to analyze
    
BEGIN
    -- Header
    DBMS_OUTPUT.PUT_LINE('Department Summary Report');
    DBMS_OUTPUT.PUT_LINE('========================');
    
    -- Get department summary information
    -- Using a single query to get all needed information
    SELECT 
        d.department_id,
        d.department_name,
        NVL(m.first_name || ' ' || m.last_name, 'No Manager'),
        COUNT(e.employee_id),
        NVL(AVG(e.salary), 0)
    INTO 
        dept_summary.dept_id,
        dept_summary.dept_name,
        dept_summary.manager_name,
        dept_summary.employee_count,
        dept_summary.avg_salary
    FROM 
        departments d
        LEFT JOIN employees e ON d.department_id = e.department_id
        LEFT JOIN employees m ON d.manager_id = m.employee_id
    WHERE 
        d.department_id = c_department_id
    GROUP BY 
        d.department_id,
        d.department_name,
        m.first_name,
        m.last_name;
        
    -- Display detailed information
    DBMS_OUTPUT.PUT_LINE('Department Details:');
    DBMS_OUTPUT.PUT_LINE('-----------------');
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || dept_summary.dept_id);
    DBMS_OUTPUT.PUT_LINE('Department Name: ' || dept_summary.dept_name);
    DBMS_OUTPUT.PUT_LINE('Manager: ' || dept_summary.manager_name);
    DBMS_OUTPUT.PUT_LINE('Number of Employees: ' || dept_summary.employee_count);
    DBMS_OUTPUT.PUT_LINE('Average Salary: $' || 
        TO_CHAR(dept_summary.avg_salary, '99,999.00'));
        
    -- Additional statistics
    DBMS_OUTPUT.PUT_LINE(CHR(10) || 'Additional Statistics:');
    DBMS_OUTPUT.PUT_LINE('---------------------');
    
    -- Calculate and display annual payroll
    DBMS_OUTPUT.PUT_LINE('Estimated Annual Payroll: $' || 
        TO_CHAR(dept_summary.avg_salary * dept_summary.employee_count * 12, '999,999.00'));
    
    -- Get and display additional employee statistics
    DECLARE
        v_min_salary NUMBER;
        v_max_salary NUMBER;
    BEGIN
        SELECT 
            MIN(salary),
            MAX(salary)
        INTO 
            v_min_salary,
            v_max_salary
        FROM 
            employees
        WHERE 
            department_id = c_department_id;
            
        DBMS_OUTPUT.PUT_LINE('Salary Range: $' || 
            TO_CHAR(v_min_salary, '99,999.00') || ' - $' || 
            TO_CHAR(v_max_salary, '99,999.00'));
    END;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Department ' || c_department_id || ' not found.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        -- Log error details if needed
        -- ROLLBACK if any DML was performed
END;
/
