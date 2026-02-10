DECLARE
    v_enrollment enrollments%ROWTYPE;
    v_found BOOLEAN;
BEGIN
    v_enrollment := show_enrollment(1001, 101, v_found);
    
    IF v_found THEN
        DBMS_OUTPUT.PUT_LINE('Enrollment found:');
        DBMS_OUTPUT.PUT_LINE('Student ID: ' || v_enrollment.student_id);
        DBMS_OUTPUT.PUT_LINE('Course No: ' || v_enrollment.course_no);
        DBMS_OUTPUT.PUT_LINE('Grade: ' || v_enrollment.grade);
    ELSE
        DBMS_OUTPUT.PUT_LINE('No enrollment found for this student and course.');
    END IF;
END;