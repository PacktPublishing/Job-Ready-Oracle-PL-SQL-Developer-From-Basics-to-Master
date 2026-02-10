DECLARE
  CURSOR c_dept_info IS
    SELECT d.department_name, 
           e.first_name || ' ' || e.last_name AS manager_name,
           COUNT(emp.employee_id) AS emp_count,
           SUM(emp.salary) AS total_salary
    FROM departments d
    LEFT JOIN employees e ON d.manager_id = e.employee_id
    LEFT JOIN employees emp ON d.department_id = emp.department_id
    GROUP BY d.department_name, e.first_name, e.last_name;
  
  v_dept_record c_dept_info%ROWTYPE;
BEGIN
  FOR v_dept_record IN c_dept_info
  LOOP
    DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_record.department_name);
    DBMS_OUTPUT.PUT_LINE('Manager: ' || NVL(v_dept_record.manager_name, 'No manager'));
    DBMS_OUTPUT.PUT_LINE('Number of employees: ' || v_dept_record.emp_count);
    DBMS_OUTPUT.PUT_LINE('Total salary: $' || TO_CHAR(v_dept_record.total_salary, '999,999.00'));
    DBMS_OUTPUT.PUT_LINE('--------------------');
  END LOOP;
END;