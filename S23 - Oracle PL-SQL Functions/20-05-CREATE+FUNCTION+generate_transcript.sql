CREATE OR REPLACE TYPE transcript_row AS OBJECT
   (semester VARCHAR2(20),
    course_name VARCHAR2(100),
    grade CHAR(1),
    credits NUMBER);
/

CREATE OR REPLACE TYPE transcript_table AS TABLE OF transcript_row;
/

CREATE OR REPLACE FUNCTION generate_transcript
   (p_student_id IN NUMBER)
RETURN transcript_table PIPELINED
IS
   CURSOR c_grades IS
      SELECT TO_CHAR(e.enrollment_date, 'YYYY-MM') as semester,
             c.description as course_name,
             e.grade,
             c.credits
      FROM enrollments e
      JOIN course c ON e.course_no = c.course_no
      WHERE e.student_id = p_student_id
      ORDER BY e.enrollment_date;
BEGIN
   FOR r_grade IN c_grades LOOP
      PIPE ROW(transcript_row(r_grade.semester, r_grade.course_name, 
                              r_grade.grade, r_grade.credits));
   END LOOP;
   RETURN;
END generate_transcript;
