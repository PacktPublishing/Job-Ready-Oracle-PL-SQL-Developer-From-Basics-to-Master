DECLARE
   v_student_name VARCHAR2(50);
   v_student_id   NUMBER := &sv_student_id;
BEGIN
   SELECT first_name || ' ' || last_name
   INTO v_student_name
   FROM student
   WHERE student_id = v_student_id;
   
   DBMS_OUTPUT.PUT_LINE('Student name: ' || v_student_name);
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      DBMS_OUTPUT.PUT_LINE('No student found with ID ' || v_student_id);
   WHEN TOO_MANY_ROWS THEN
      DBMS_OUTPUT.PUT_LINE('Multiple students found with ID ' || v_student_id);
   WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('Invalid data type for student ID');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

-- Now, let's write a PL/SQL block to insert a new student record:
DECLARE
   v_student_id   NUMBER := &sv_student_id;
   v_first_name   VARCHAR2(50) := '&sv_first_name';
   v_last_name    VARCHAR2(50) := '&sv_last_name';
BEGIN
   INSERT INTO student (student_id, first_name, last_name)
   VALUES (v_student_id, v_first_name, v_last_name);
   
   DBMS_OUTPUT.PUT_LINE('Student record inserted successfully.');
EXCEPTION
   WHEN DUP_VAL_ON_INDEX THEN
      DBMS_OUTPUT.PUT_LINE('Error: A student with ID ' || v_student_id || ' already exists.');
   WHEN OTHERS THEN
      DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
END;
/

/*
A real-world scenario that might cause the DUP_VAL_ON_INDEX exception to be raised is when a school's registration system attempts to assign an already existing student ID to a new student. This could happen if:

A student is being re-enrolled and the system doesn't check for existing records first.
There's a clerical error where an administrator accidentally enters a pre-existing ID for a new student.
Two administrators are simultaneously entering new student data and happen to use the same ID.
By handling this exception, the system can prevent data integrity issues and provide clear feedback to the user about why the operation failed, allowing them to correct the error and try again with a unique student ID.
*/