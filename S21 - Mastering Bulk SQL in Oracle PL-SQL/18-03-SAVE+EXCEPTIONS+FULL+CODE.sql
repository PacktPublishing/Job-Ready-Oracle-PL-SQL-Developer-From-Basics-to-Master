-- Enable DBMS_OUTPUT in your client
-- Example command for SQL*Plus:
-- SET SERVEROUTPUT ON;

DECLARE
  -- Define collection types for employee data
  TYPE emp_id_type IS TABLE OF employees.employee_id%TYPE INDEX BY PLS_INTEGER;
  TYPE salary_type IS TABLE OF employees.salary%TYPE INDEX BY PLS_INTEGER;

  l_emp_ids    emp_id_type;   -- Collection for employee IDs
  l_salaries   salary_type;   -- Collection for salaries

  -- Define exception for bulk errors
  l_bulk_errors EXCEPTION;
  PRAGMA EXCEPTION_INIT(l_bulk_errors, -24381);

BEGIN
  -- Populate collections with some invalid data
  FOR i IN 1..5 LOOP
    l_emp_ids(i) := i + 100; -- Employee IDs (e.g., 101, 102, etc.)
    l_salaries(i) := CASE
                       WHEN i = 2 THEN -1000  -- Invalid salary
                       WHEN i = 4 THEN -2000  -- Invalid salary
                       ELSE 5000              -- Valid salary for others
                     END;
  END LOOP;

  -- Attempt bulk update with SAVE EXCEPTIONS
  BEGIN
    FORALL i IN 1..5 SAVE EXCEPTIONS
      UPDATE employees_copy
      SET salary = l_salaries(i)
      WHERE employee_id = l_emp_ids(i);

    COMMIT;  -- Commit valid updates
EXCEPTION
    WHEN l_bulk_errors THEN
        DBMS_OUTPUT.PUT_LINE('Exception block entered.');
        DBMS_OUTPUT.PUT_LINE('Number of failures: ' || SQL%BULK_EXCEPTIONS.COUNT);
        
        FOR i IN 1..SQL%BULK_EXCEPTIONS.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(
                'Error ' || i || ' occurred during iteration ' ||
                SQL%BULK_EXCEPTIONS(i).ERROR_INDEX
            );
            DBMS_OUTPUT.PUT_LINE(
                'Error message: ' ||
                SQLERRM(-SQL%BULK_EXCEPTIONS(i).ERROR_CODE)
            );
        END LOOP;
        
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM); -- Catch any other unforeseen errors
END;
END;