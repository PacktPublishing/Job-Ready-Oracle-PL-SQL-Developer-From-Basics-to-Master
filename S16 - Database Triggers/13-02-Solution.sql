-- BEFORE Trigger on DEPARTMENTS Table
-- Objective: Automatically set the MANAGER_ID to NULL if the specified MANAGER_ID does not exist in the EMPLOYEES table.


CREATE OR REPLACE TRIGGER trg_check_manager_id
BEFORE INSERT OR UPDATE OF manager_id ON departments
FOR EACH ROW
DECLARE
  v_count NUMBER;
BEGIN
  -- Check if the manager_id exists in the employees table
  SELECT COUNT(*) INTO v_count FROM employees WHERE employee_id = :NEW.manager_id;

  -- If manager_id does not exist, set it to NULL
  IF v_count = 0 THEN
    :NEW.manager_id := NULL;
  END IF;
END;
/


-- AFTER Trigger to Log Changes to DEPARTMENTS Table
-- Objective: Log all changes (INSERT, UPDATE, DELETE) to the DEPARTMENTS table in an audit log.

CREATE TABLE departments_audit_log (
  log_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,  -- Automatically generates a unique ID for each log entry
  action_date DATE DEFAULT SYSDATE,                       -- Records the date and time of each action
  action VARCHAR2(10),                                    -- Specifies the type of action: INSERT, UPDATE, or DELETE
  department_id NUMBER,                                   -- Stores the ID of the department affected by the action
  manager_id NUMBER,                                      -- Stores the manager ID associated with the department
  performed_by VARCHAR2(30)                               -- Records the username of the person who performed the action
);


CREATE OR REPLACE TRIGGER trg_log_department_changes
AFTER INSERT OR UPDATE OR DELETE ON departments
FOR EACH ROW
DECLARE
  v_action VARCHAR2(10);
  v_department_id NUMBER;
  v_manager_id NUMBER;
BEGIN
  -- Determine the action type
  IF INSERTING THEN
    v_action := 'INSERT';
    v_department_id := :NEW.department_id;
    v_manager_id := :NEW.manager_id;
  ELSIF UPDATING THEN
    v_action := 'UPDATE';
    v_department_id := :NEW.department_id;
    v_manager_id := :NEW.manager_id;
  ELSIF DELETING THEN
    v_action := 'DELETE';
    v_department_id := :OLD.department_id;
    v_manager_id := :OLD.manager_id;
  END IF;

  -- Insert the audit log
  INSERT INTO departments_audit_log (action_date, action, department_id, manager_id, performed_by)
  VALUES (SYSDATE, v_action, v_department_id, v_manager_id, USER);
END;
/