-- =============================================================================
-- Exercise: Manager and Direct Reports Report (Oracle HR Schema)
-- Description: PL/SQL block with schema-qualified table names
-- =============================================================================

SET SERVEROUTPUT ON;

DECLARE
    -- Outer cursor: Fetches employees who are managers
    CURSOR c_managers IS
        SELECT DISTINCT e.employee_id, e.first_name, e.last_name, j.job_title
        FROM HR.EMPLOYEES e
        JOIN HR.JOBS j ON e.job_id = j.job_id
        WHERE EXISTS (SELECT 1 FROM HR.EMPLOYEES sub WHERE sub.manager_id = e.employee_id);
    
    -- Inner cursor: Fetches direct reports for a specific manager
    CURSOR c_direct_reports(p_manager_id IN NUMBER) IS
        SELECT e.employee_id, e.first_name, e.last_name, j.job_title
        FROM HR.EMPLOYEES e
        JOIN HR.JOBS j ON e.job_id = j.job_id
        WHERE e.manager_id = p_manager_id;
    
BEGIN
    -- Loop through each manager
    FOR mgr IN c_managers LOOP
        -- Display manager information
        DBMS_OUTPUT.PUT_LINE('Manager: ID=' || mgr.employee_id || ', Name=' || mgr.first_name || ' ' || mgr.last_name || ', Job=' || mgr.job_title);
        
        -- Loop through direct reports
        FOR rep IN c_direct_reports(mgr.employee_id) LOOP
            DBMS_OUTPUT.PUT_LINE('    Direct Report: ID=' || rep.employee_id || ', Name=' || rep.first_name || ' ' || rep.last_name || ', Job=' || rep.job_title);
        END LOOP;
        
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/