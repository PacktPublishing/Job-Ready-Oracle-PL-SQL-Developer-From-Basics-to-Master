DECLARE
  l_department_id NUMBER := 60;
  l_salary_increase NUMBER := 1.15;
  l_affected_rows NUMBER;
  l_sql VARCHAR2(200);
BEGIN
  l_sql := 'UPDATE employees SET salary = salary * :increase WHERE department_id = :dept_id';
  
  EXECUTE IMMEDIATE l_sql
  USING l_salary_increase, l_department_id;
  
  l_affected_rows := SQL%ROWCOUNT;
  
  DBMS_OUTPUT.PUT_LINE('Employees updated: ' || l_affected_rows);
END;
/
