--Step 1: Adding Credits to Courses
ALTER TABLE course ADD credits NUMBER(2,1);

UPDATE course SET credits = 
  CASE 
    WHEN course_no BETWEEN 101 AND 105 THEN 3
    WHEN course_no BETWEEN 106 AND 110 THEN 4
    ELSE 3.5
  END;
COMMIT;


--Step 2: Creating a Course Prerequisites Table
CREATE TABLE course_prerequisites (
    course_id NUMBER,
    prerequisite_id NUMBER,
    FOREIGN KEY (course_id) REFERENCES course(course_no),
    FOREIGN KEY (prerequisite_id) REFERENCES course(course_no)
);

-- Insert sample prerequisites
INSERT INTO course_prerequisites VALUES (102, 101);
INSERT INTO course_prerequisites VALUES (103, 101);
INSERT INTO course_prerequisites VALUES (104, 102);
COMMIT;

--Step 3: Adding Enrollment Dates
ALTER TABLE enrollments ADD enrollment_date DATE;

UPDATE enrollments SET enrollment_date = 
  CASE 
    WHEN course_no BETWEEN 101 AND 105 THEN TO_DATE('2023-01-15', 'YYYY-MM-DD')
    WHEN course_no BETWEEN 106 AND 110 THEN TO_DATE('2023-06-15', 'YYYY-MM-DD')
    ELSE TO_DATE('2023-09-15', 'YYYY-MM-DD')
  END;
COMMIT;