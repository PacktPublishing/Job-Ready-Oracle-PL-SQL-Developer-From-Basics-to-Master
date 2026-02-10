DECLARE
  CURSOR c_dept_list IS
    SELECT d.department_id, d.department_name, 
           e.first_name || ' ' || e.last_name AS manager_name
    FROM departments d
    LEFT JOIN employees e ON d.manager_id = e.employee_id;
  
  v_dept_id departments.department_id%TYPE;
  v_dept_name departments.department_name%TYPE;
  v_manager_name VARCHAR2(100);
  v_dept_count NUMBER := 0;
BEGIN
  OPEN c_dept_list;
  
  LOOP
    FETCH c_dept_list INTO v_dept_id, v_dept_name, v_manager_name;
    EXIT WHEN c_dept_list%NOTFOUND;
    
    v_dept_count := v_dept_count + 1;
    
    DBMS_OUTPUT.PUT_LINE('Department ID: ' || v_dept_id || 
                         ', Name: ' || v_dept_name || 
                         ', Manager: ' || NVL(v_manager_name, 'No manager'));
  END LOOP;
  
  DBMS_OUTPUT.PUT_LINE('Total departments: ' || v_dept_count);
  
  CLOSE c_dept_list;
END;