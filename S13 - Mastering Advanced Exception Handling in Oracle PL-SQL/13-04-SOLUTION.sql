DECLARE
    v_employee_id    NUMBER := employees_seq.NEXTVAL;
    v_first_name     VARCHAR2(20) := 'John';
    v_last_name      VARCHAR2(25) := 'Doe';
    v_email          VARCHAR2(25) := 'JDOE';
    v_hire_date      DATE := SYSDATE;
    v_job_id         VARCHAR2(10) := 'SA_REP';
    v_department_id  NUMBER := 9999;  -- This is an invalid department ID

BEGIN
    INSERT INTO employees (
        employee_id, first_name, last_name, email, hire_date, job_id, department_id
    ) VALUES (
        v_employee_id, v_first_name, v_last_name, v_email, v_hire_date, v_job_id, v_department_id
    );
    
    DBMS_OUTPUT.PUT_LINE('Employee added successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred while inserting the new employee.');
        DBMS_OUTPUT.PUT_LINE('Error Code: ' || SQLCODE);
        DBMS_OUTPUT.PUT_LINE('Error Message: ' || SUBSTR(SQLERRM, 1, 200));
        
        -- Display the error message for this specific Oracle error number
        DBMS_OUTPUT.PUT_LINE('Specific error message: ' || SQLERRM(SQLCODE));
END;

/*
This solution does the following:

1. We attempt to insert a new employee with an invalid department_id (9999).

2. This will trigger a foreign key constraint violation (typically ORA-02291).

3. In the EXCEPTION block:

 - We use SQLCODE to display the Oracle error number.
 - We use SQLERRM to display the error message (limited to 200 characters to avoid potential buffer overflow issues).
 - We then use SQLERRM again, passing in SQLCODE, to display the specific error message for this Oracle error number.

When you run this code, you should see output similar to this:

An error occurred while inserting the new employee.
Error Code: -2291
Error Message: ORA-02291: integrity constraint (HR.EMP_DEPT_FK) violated - parent key not found
Specific error message: ORA-02291: integrity constraint (HR.EMP_DEPT_FK) violated - parent key not found
This exercise demonstrates how SQLCODE and SQLERRM can be used to provide detailed information about errors in your PL/SQL code. It shows:
*/