-- Test the packages
BEGIN
  -- Regular package
  regular_pkg.increment;
  DBMS_OUTPUT.PUT_LINE('Regular package count: ' || regular_pkg.v_count);
  
  -- SERIALLY_REUSABLE package
  sr_pkg.increment;
  DBMS_OUTPUT.PUT_LINE('SERIALLY_REUSABLE package count: ' || sr_pkg.v_count);
END;

