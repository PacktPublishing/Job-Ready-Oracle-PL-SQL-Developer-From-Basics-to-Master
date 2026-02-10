CREATE OR REPLACE FUNCTION calculate_bonus(p_salary IN NUMBER)
RETURN NUMBER
IS
    v_bonus NUMBER;
BEGIN
    v_bonus := p_salary * 0.1;  -- 10% bonus
    RETURN v_bonus;
END calculate_bonus;
