-- First, let's create the view:
CREATE OR REPLACE VIEW emp_dept_loc_view AS
SELECT e.employee_id, e.first_name, e.last_name, e.salary,
       d.department_id, d.department_name,
       l.location_id, l.city, l.state_province
FROM employees e
JOIN departments d ON e.department_id = d.department_id
JOIN locations l ON d.location_id = l.location_id;


-- Now, let's create the INSTEAD OF trigger on this view:

CREATE OR REPLACE TRIGGER trg_manage_emp_dept_loc_view
INSTEAD OF INSERT OR UPDATE OR DELETE ON emp_dept_loc_view
FOR EACH ROW
DECLARE
  v_dept_exists NUMBER;
  v_loc_exists NUMBER;
BEGIN
  IF INSERTING THEN
    -- Check if department and location exist before inserting
    SELECT COUNT(*) INTO v_dept_exists FROM departments WHERE department_id = :NEW.department_id;
    SELECT COUNT(*) INTO v_loc_exists FROM locations WHERE location_id = :NEW.location_id;

    -- Ensure referenced department and location exist
    IF v_dept_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20002, 'Department does not exist.');
    END IF;
    IF v_loc_exists = 0 THEN
      RAISE_APPLICATION_ERROR(-20003, 'Location does not exist.');
    END IF;

    -- Insert into employees table
    INSERT INTO employees (employee_id, first_name, last_name, salary, department_id)
    VALUES (:NEW.employee_id, :NEW.first_name, :NEW.last_name, :NEW.salary, :NEW.department_id);

  ELSIF UPDATING THEN
    -- Update employees table
    UPDATE employees
    SET first_name = :NEW.first_name,
        last_name = :NEW.last_name,
        salary = :NEW.salary,
        department_id = :NEW.department_id
    WHERE employee_id = :OLD.employee_id;

    -- Optionally, handle department and location updates if required

  ELSIF DELETING THEN
    -- Delete from employees table
    DELETE FROM employees WHERE employee_id = :OLD.employee_id;

    -- Optionally, handle cascading deletes if required
  END IF;
END;
/