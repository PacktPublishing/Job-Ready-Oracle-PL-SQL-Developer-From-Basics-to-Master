DECLARE
   v_num1   NUMBER := &sv_num1;
   v_num2   NUMBER := &sv_num2;
   v_result NUMBER;
BEGIN
   v_result := v_num1 / v_num2;
   DBMS_OUTPUT.PUT_LINE('Result: ' || v_result);
EXCEPTION
   WHEN ZERO_DIVIDE THEN
      DBMS_OUTPUT.PUT_LINE('Error: Cannot divide by zero.');
   WHEN VALUE_ERROR THEN
      DBMS_OUTPUT.PUT_LINE('Error: Invalid input. Please enter numeric values.');
END;
/

-- Scenario 1: Both are valid numbers (e.g., 10 and 2)
-- Output: Result: 5
-- The program executes successfully and displays the result.

-- Scenario 2: The second number is 0
-- Output: Error: Cannot divide by zero.
-- The ZERO_DIVIDE exception is caught and a user-friendly message is displayed.

-- Scenario 3: Non-numeric value for either input
-- Output: Error: Invalid input. Please enter numeric values.
-- The VALUE_ERROR exception is caught when trying to convert non-numeric input to NUMBER.