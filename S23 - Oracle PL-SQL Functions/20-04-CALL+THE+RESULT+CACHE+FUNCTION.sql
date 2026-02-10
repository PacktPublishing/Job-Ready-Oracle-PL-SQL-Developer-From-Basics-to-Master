DECLARE
   department_id NUMBER := 10; -- Replace with your desired department ID
   employee_count NUMBER;
BEGIN
   employee_count := get_employee_count(department_id);
   DBMS_OUTPUT.PUT_LINE('Employee Count: ' || employee_count);
END;