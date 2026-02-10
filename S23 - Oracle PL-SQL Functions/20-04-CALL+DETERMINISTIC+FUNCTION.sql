DECLARE
   birthdate DATE := TO_DATE('1990-01-15', 'YYYY-MM-DD');
   age NUMBER;
BEGIN
   age := calculate_age(birthdate);
   DBMS_OUTPUT.PUT_LINE('Age: ' || age);
END;