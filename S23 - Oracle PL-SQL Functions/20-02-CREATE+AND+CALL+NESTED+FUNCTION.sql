DECLARE
   v_result NUMBER;
   
   FUNCTION calc (p_num1 NUMBER, p_num2 NUMBER)
   RETURN NUMBER
   IS
   BEGIN
      IF p_num1 > p_num2 THEN
         RETURN (p_num1 - p_num2);
      ELSIF p_num1 < p_num2 THEN
         RETURN (p_num1 + p_num2);
      ELSE
         RETURN (p_num1);
      END IF;
   END calc;
   
BEGIN
   DBMS_OUTPUT.PUT_LINE ('p_num1 > p_num2');
   v_result := calc (10, 9);
   DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
   
   DBMS_OUTPUT.PUT_LINE ('p_num1 < p_num2');
   v_result := calc (5, 8);
   DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
   
   DBMS_OUTPUT.PUT_LINE ('p_num1 = p_num2');
   v_result := calc (7, 7);
   DBMS_OUTPUT.PUT_LINE ('v_result: '||v_result);
END;
