CREATE OR REPLACE FUNCTION show_description
   (p_course_no course.course_no%TYPE) 
RETURN VARCHAR2
AS
   v_description course.description%TYPE;
BEGIN
   SELECT description
     INTO v_description
     FROM course
    WHERE course_no = p_course_no;
   RETURN v_description;
EXCEPTION
   WHEN NO_DATA_FOUND THEN
      RETURN ('Invalid course no');
END;
