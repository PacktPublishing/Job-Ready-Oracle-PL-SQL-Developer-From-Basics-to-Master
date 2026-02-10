DECLARE
  l_updated_count NUMBER;
  l_sql VARCHAR2(500);
  l_increase NUMBER := 1.02;  -- 2% increase
  l_dept_id NUMBER := 60;    -- IT department
BEGIN
  DBMS_OUTPUT.PUT_LINE('Preparing SQL statement.');
  
  l_sql := 'UPDATE employees 
            SET salary = salary * :increase
            WHERE department_id = :dept_id 
            AND hire_date < TO_DATE(''01-JAN-2018'', ''DD-MON-YYYY'')
            RETURNING COUNT(*) INTO :1';

  DBMS_OUTPUT.PUT_LINE('Executing SQL: ' || l_sql);
  
  EXECUTE IMMEDIATE l_sql
    USING l_increase, l_dept_id
    RETURN INTO l_updated_count;

  DBMS_OUTPUT.PUT_LINE('Update successful.');
  DBMS_OUTPUT.PUT_LINE('Number of employees updated: ' || l_updated_count);
  
  COMMIT;
  
  DBMS_OUTPUT.PUT_LINE('Transaction committed.');
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    ROLLBACK;
END;
/