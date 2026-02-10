DECLARE
   l_job_id VARCHAR2(10) := 'SA_REP';   -- Changed from 'IT_PROG' to 'SA_REP'
   l_count NUMBER;
   l_sql VARCHAR2(200);
BEGIN
   l_sql := 'SELECT COUNT(*) FROM employees WHERE job_id = :job_id';
   
   EXECUTE IMMEDIATE l_sql
   INTO l_count
   USING l_job_id;
   
   DBMS_OUTPUT.PUT_LINE('Number of ' || l_job_id || ' employees: ' || l_count);
END;
/
