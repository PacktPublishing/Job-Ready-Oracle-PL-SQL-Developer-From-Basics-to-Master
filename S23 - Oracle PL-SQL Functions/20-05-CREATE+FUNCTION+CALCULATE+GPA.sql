CREATE OR REPLACE FUNCTION calculate_gpa
   (p_student_id IN NUMBER)
RETURN NUMBER
RESULT_CACHE
IS
   v_total_points NUMBER := 0;
   v_total_credits NUMBER := 0;
   v_gpa NUMBER;
BEGIN
   SELECT SUM(c.credits * CASE e.grade
                           WHEN 'A' THEN 4
                           WHEN 'B' THEN 3
                           WHEN 'C' THEN 2
                           WHEN 'D' THEN 1
                           ELSE 0
                          END),
          SUM(c.credits)
   INTO v_total_points, v_total_credits
   FROM enrollments e
   JOIN course c ON e.course_no = c.course_no
   WHERE e.student_id = p_student_id;

   IF v_total_credits > 0 THEN
      v_gpa := v_total_points / v_total_credits;
   ELSE
      v_gpa := 0;
   END IF;

   RETURN ROUND(v_gpa, 2);
EXCEPTION
   WHEN OTHERS THEN
      -- Log error and return null
      DBMS_OUTPUT.PUT_LINE('Error calculating GPA: ' || SQLERRM);
      RETURN NULL;
END calculate_gpa;