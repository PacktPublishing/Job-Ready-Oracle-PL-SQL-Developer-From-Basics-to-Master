CREATE OR REPLACE PACKAGE regular_pkg AS
  v_count NUMBER := 0;
  PROCEDURE increment;
END regular_pkg;
/

CREATE OR REPLACE PACKAGE BODY regular_pkg AS
  PROCEDURE increment IS
  BEGIN
    v_count := v_count + 1;
  END increment;
END regular_pkg;
/

CREATE OR REPLACE PACKAGE sr_pkg AS
  PRAGMA SERIALLY_REUSABLE;
  v_count NUMBER := 0;
  PROCEDURE increment;
END sr_pkg;
/

CREATE OR REPLACE PACKAGE BODY sr_pkg AS
  PRAGMA SERIALLY_REUSABLE;
  PROCEDURE increment IS
  BEGIN
    v_count := v_count + 1;
  END increment;
END sr_pkg;
/