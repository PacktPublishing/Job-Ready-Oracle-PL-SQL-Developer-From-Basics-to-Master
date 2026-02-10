DECLARE
    -- First, let's create the basic information record
    TYPE name_rec_type IS RECORD (
        first_name  VARCHAR2(50),
        last_name   VARCHAR2(50)
    );
    
    -- Create address record structure
    TYPE address_rec_type IS RECORD (
        street      VARCHAR2(100),
        city        VARCHAR2(50),
        state       VARCHAR2(2),
        zip         VARCHAR2(10),
        phone       VARCHAR2(15)
    );
    
    -- Create academic record structure
    TYPE academic_rec_type IS RECORD (
        major       VARCHAR2(50),
        gpa        NUMBER(3,2),
        year       NUMBER(1),        -- 1=Freshman, 2=Sophomore, etc.
        status     VARCHAR2(20)      -- 'Active', 'On Leave', etc.
    );
    
    -- Now let's put it all together in a student record
    TYPE student_rec_type IS RECORD (
        student_id  NUMBER,
        personal    name_rec_type,
        contact     address_rec_type,
        academics   academic_rec_type
    );
    
    -- Create a table of students (we might want multiple students)
    TYPE student_list_type IS TABLE OF student_rec_type;
    
    -- Initialize our student list
    students student_list_type := student_list_type();
    
BEGIN
    -- Let's add a couple of students
    students.EXTEND(2);  -- Make room for 2 students
    
    -- First student
    students(1).student_id := 1001;
    -- Personal info
    students(1).personal.first_name := 'Sarah';
    students(1).personal.last_name := 'Johnson';
    -- Contact info
    students(1).contact.street := '123 College Ave';
    students(1).contact.city := 'University Town';
    students(1).contact.state := 'CA';
    students(1).contact.zip := '90210';
    students(1).contact.phone := '555-0123';
    -- Academic info
    students(1).academics.major := 'Computer Science';
    students(1).academics.gpa := 3.85;
    students(1).academics.year := 2;
    students(1).academics.status := 'Active';
    
    -- Second student
    students(2).student_id := 1002;
    -- Personal info
    students(2).personal.first_name := 'Michael';
    students(2).personal.last_name := 'Smith';
    -- Contact info
    students(2).contact.street := '456 Campus Drive';
    students(2).contact.city := 'College City';
    students(2).contact.state := 'NY';
    students(2).contact.zip := '10001';
    students(2).contact.phone := '555-4567';
    -- Academic info
    students(2).academics.major := 'Business';
    students(2).academics.gpa := 3.92;
    students(2).academics.year := 3;
    students(2).academics.status := 'Active';
    
    -- Now let's display our student information
    FOR i IN 1 .. students.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE('=== Student Information ===');
        DBMS_OUTPUT.PUT_LINE('ID: ' || students(i).student_id);
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '-- Personal Information --');
        DBMS_OUTPUT.PUT_LINE('Name: ' || 
            students(i).personal.first_name || ' ' ||
            students(i).personal.last_name);
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '-- Contact Information --');
        DBMS_OUTPUT.PUT_LINE(students(i).contact.street);
        DBMS_OUTPUT.PUT_LINE(students(i).contact.city || ', ' ||
            students(i).contact.state || ' ' || students(i).contact.zip);
        DBMS_OUTPUT.PUT_LINE('Phone: ' || students(i).contact.phone);
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '-- Academic Information --');
        DBMS_OUTPUT.PUT_LINE('Major: ' || students(i).academics.major);
        DBMS_OUTPUT.PUT_LINE('GPA: ' || TO_CHAR(students(i).academics.gpa, '9.99'));
        DBMS_OUTPUT.PUT_LINE('Year: ' || students(i).academics.year);
        DBMS_OUTPUT.PUT_LINE('Status: ' || students(i).academics.status);
        
        DBMS_OUTPUT.PUT_LINE(CHR(10) || '------------------------' || CHR(10));
    END LOOP;
END;
/
