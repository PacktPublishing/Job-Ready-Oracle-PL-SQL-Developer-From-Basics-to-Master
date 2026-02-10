CREATE OR REPLACE FUNCTION show_enrollment
   (p_student_id IN NUMBER, 
    p_course_no IN NUMBER,
    p_found OUT BOOLEAN)
RETURN enrollments%ROWTYPE
AS
   v_rec enrollments%ROWTYPE;
BEGIN
   SELECT *
     INTO v_rec
     FROM enrollments
    WHERE student_id = p_student_id
      AND course_no = p_course_no;
   p_found := TRUE;
   RETURN v_rec;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      p_found := FALSE;
      RETURN v_rec;  -- Returns an empty record if no data found
END;