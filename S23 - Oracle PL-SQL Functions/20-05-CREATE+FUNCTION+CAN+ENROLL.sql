CREATE OR REPLACE FUNCTION can_enroll
   (p_student_id IN NUMBER,
    p_course_no IN NUMBER)
RETURN VARCHAR2
IS
   v_prereq_count NUMBER;
   v_completed_count NUMBER;
BEGIN
   -- Check if student has completed all prerequisites
   SELECT COUNT(*)
   INTO v_prereq_count
   FROM course_prerequisites
   WHERE course_id = p_course_no;

   SELECT COUNT(*)
   INTO v_completed_count
   FROM enrollments e
   JOIN course_prerequisites cp ON e.course_no = cp.prerequisite_id
   WHERE e.student_id = p_student_id
     AND cp.course_id = p_course_no
     AND e.grade IN ('A', 'B', 'C', 'D');

   IF v_completed_count = v_prereq_count THEN
      RETURN 'YES';
   ELSE
      RETURN 'NO - Missing prerequisites';
   END IF;
EXCEPTION
   WHEN OTHERS THEN
      RETURN 'ERROR: ' || SQLERRM;
END can_enroll;
