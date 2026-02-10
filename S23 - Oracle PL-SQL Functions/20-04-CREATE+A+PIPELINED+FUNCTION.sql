CREATE OR REPLACE TYPE number_list AS TABLE OF NUMBER;
/

CREATE OR REPLACE FUNCTION generate_fibonacci(p_count IN NUMBER)
RETURN number_list PIPELINED
IS
   v_first NUMBER := 0;
   v_second NUMBER := 1;
   v_next NUMBER;
BEGIN
   FOR i IN 1..p_count LOOP
      PIPE ROW(v_first);
      v_next := v_first + v_second;
      v_first := v_second;
      v_second := v_next;
   END LOOP;
   RETURN;
END generate_fibonacci;
