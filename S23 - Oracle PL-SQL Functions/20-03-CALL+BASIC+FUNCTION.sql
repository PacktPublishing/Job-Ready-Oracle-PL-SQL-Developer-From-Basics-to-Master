DECLARE
   v_description course.description%TYPE;
BEGIN
   -- Existing course no
   v_description := show_description(101);
   DBMS_OUTPUT.PUT_LINE('Course description: '||v_description);
   
   -- Non-existing course no
   v_description := show_description(1000);
   DBMS_OUTPUT.PUT_LINE('Course description: '||v_description);
END;
