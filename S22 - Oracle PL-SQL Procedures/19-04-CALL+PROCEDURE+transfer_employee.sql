DECLARE
    v_status VARCHAR2(200);
BEGIN
    transfer_employee(
        p_emp_id => 193,
        p_new_dept_id => 60,
        p_new_job_id => 'IT_PROG',
        p_new_salary => 6000,
        p_status => v_status
    );
    DBMS_OUTPUT.PUT_LINE(v_status);
END;
