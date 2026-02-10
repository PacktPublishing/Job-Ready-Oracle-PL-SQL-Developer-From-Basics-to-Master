DECLARE
   v_student_id NUMBER := 1001;
   v_course_no NUMBER := 101;
BEGIN
   DBMS_OUTPUT.PUT_LINE('Student GPA: ' || calculate_gpa(v_student_id));
   DBMS_OUTPUT.PUT_LINE('Can enroll in course: ' || can_enroll(v_student_id, v_course_no));
END;