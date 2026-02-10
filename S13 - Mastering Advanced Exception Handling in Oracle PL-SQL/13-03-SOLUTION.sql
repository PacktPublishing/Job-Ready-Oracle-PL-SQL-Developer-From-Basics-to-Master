DECLARE
    v_employee_id    NUMBER := 1000;  -- Example employee ID
    v_department_id  NUMBER := 9999;  -- This is our invalid department ID
    
    e_invalid_department EXCEPTION;
    PRAGMA EXCEPTION_INIT(e_invalid_department, -2291);
BEGIN
    INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, department_id)
    VALUES (v_employee_id, 'John', 'Doe', 'JDOE', SYSDATE, 'SA_REP', v_department_id);
    
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');
EXCEPTION
    WHEN e_invalid_department THEN
        DBMS_OUTPUT.PUT_LINE('Error: Cannot add employee. The specified department ID does not exist.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;

/*
We're trying to insert an employee with an invalid department ID.
We've used EXCEPTION_INIT to associate our custom exception with the Oracle error -2291.
When the exception is caught, we display the user-friendly message: "Error: Cannot add employee. The specified department ID does not exist."
*/