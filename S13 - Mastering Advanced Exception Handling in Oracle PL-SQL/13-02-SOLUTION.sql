DECLARE
    v_employee_id NUMBER := &sv_employee_id;
    v_salary NUMBER;
BEGIN
    SELECT salary INTO v_salary
    FROM employees
    WHERE employee_id = v_employee_id;
    
    IF v_salary < 2000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Employee salary below minimum wage: ' || TO_CHAR(v_salary));
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('Employee salary is above minimum wage.');
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE_APPLICATION_ERROR(-20002, 'No employee found with ID: ' || TO_CHAR(v_employee_id));
END;