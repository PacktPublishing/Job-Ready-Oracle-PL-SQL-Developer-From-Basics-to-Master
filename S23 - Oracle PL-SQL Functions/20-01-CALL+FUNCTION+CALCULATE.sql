DECLARE
    v_employee_salary NUMBER := 50000;
    v_bonus NUMBER;
BEGIN
    v_bonus := calculate_bonus(v_employee_salary);
    DBMS_OUTPUT.PUT_LINE('Employee bonus: $' || v_bonus);
END;
