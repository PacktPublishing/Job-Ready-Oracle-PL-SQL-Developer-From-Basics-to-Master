CREATE OR REPLACE TRIGGER update_job_history
    AFTER UPDATE OF job_id, department_id
    ON employees
    FOR EACH ROW
BEGIN
    IF :OLD.job_id != :NEW.job_id 
    OR :OLD.department_id != :NEW.department_id THEN
        add_job_history(:OLD.employee_id,
                       :OLD.hire_date,
                       SYSDATE,
                       :OLD.job_id,
                       :OLD.department_id);
    END IF;
END;
