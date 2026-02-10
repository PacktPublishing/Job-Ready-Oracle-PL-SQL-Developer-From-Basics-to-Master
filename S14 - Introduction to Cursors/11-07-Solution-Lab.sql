BEGIN
  DBMS_OUTPUT.PUT_LINE(RPAD('Job Title', 35) || 
                       RPAD('Number of Employees', 25) || 
                       'Average Salary');
  DBMS_OUTPUT.PUT_LINE(RPAD('-', 80, '-'));
  
  FOR job_rec IN (SELECT j.job_title,
                         COUNT(e.employee_id) AS emp_count,
                         AVG(e.salary) AS avg_salary
                  FROM jobs j
                  LEFT JOIN employees e ON j.job_id = e.job_id
                  GROUP BY j.job_title)
  LOOP
    DBMS_OUTPUT.PUT_LINE(RPAD(job_rec.job_title, 35) || 
                         RPAD(job_rec.emp_count, 25) || 
                         TO_CHAR(job_rec.avg_salary, '$999,999.00'));
  END LOOP;
END;