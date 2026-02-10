CREATE OR REPLACE FUNCTION get_employee_count
   (p_department_id IN NUMBER)
RETURN NUMBER
RESULT_CACHE
IS
   v_count NUMBER;
BEGIN
   SELECT COUNT(*)
   INTO v_count
   FROM employees
   WHERE department_id = p_department_id;
   RETURN v_count;
END get_employee_count;
