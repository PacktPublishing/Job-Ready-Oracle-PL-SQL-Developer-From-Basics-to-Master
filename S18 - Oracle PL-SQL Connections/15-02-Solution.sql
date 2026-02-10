DECLARE
    -- Define a nested table type for job IDs
    TYPE job_id_table IS TABLE OF employees.job_id%TYPE;
    
    -- Declare and initialize the nested table
    job_ids job_id_table := job_id_table();

BEGIN
    -- Step 1: Populate the nested table with job IDs of first 10 employees
    FOR rec IN (
        SELECT job_id
        FROM employees
        WHERE ROWNUM <= 10
        ORDER BY employee_id
    ) LOOP
        job_ids.EXTEND;
        job_ids(job_ids.COUNT) := rec.job_id;
    END LOOP;

    -- Step 2: Print how many job IDs we've got
    DBMS_OUTPUT.PUT_LINE('Number of job IDs: ' || job_ids.COUNT);

    -- Step 3: Show the first and last job IDs
    IF job_ids.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('First job ID: ' || job_ids(job_ids.FIRST));
        DBMS_OUTPUT.PUT_LINE('Last job ID: ' || job_ids(job_ids.LAST));
    ELSE
        DBMS_OUTPUT.PUT_LINE('The nested table is empty.');
    END IF;

    -- Step 4: Remove the last two IDs
    IF job_ids.COUNT >= 2 THEN
        job_ids.TRIM(2);
        DBMS_OUTPUT.PUT_LINE('Removed last two job IDs.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not enough elements to remove last two.');
    END IF;

    -- Step 5: Print the new count of job IDs
    DBMS_OUTPUT.PUT_LINE('New number of job IDs: ' || job_ids.COUNT);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;

/*
This PL/SQL block demonstrates the use of a nested table to store and manipulate job IDs from the employees table. It showcases various operations on the nested table, including population, counting, accessing elements, and trimming.

Declaration Section

DECLARE
    -- Define a nested table type for job IDs
    TYPE job_id_table IS TABLE OF employees.job_id%TYPE;
    
    -- Declare and initialize the nested table
    job_ids job_id_table := job_id_table();






A custom nested table type job_id_table is defined, which can hold elements of the same data type as the job_id column in the employees table.



An empty nested table job_ids is declared and initialized using this type.

Execution Section

Step 1: Populating the Nested Table

BEGIN
    -- Step 1: Populate the nested table with job IDs of first 10 employees
    FOR rec IN (
        SELECT job_id
        FROM employees
        WHERE ROWNUM <= 10
        ORDER BY employee_id
    ) LOOP
        job_ids.EXTEND;
        job_ids(job_ids.COUNT) := rec.job_id;
    END LOOP;






A cursor FOR loop is used to select the job_id of the first 10 employees (based on ROWNUM).



For each record:





job_ids.EXTEND increases the size of the nested table by one element.



The job_id is assigned to the last position of the nested table (job_ids.COUNT).

Step 2: Counting Job IDs

    -- Step 2: Print how many job IDs we've got
    DBMS_OUTPUT.PUT_LINE('Number of job IDs: ' || job_ids.COUNT);






job_ids.COUNT returns the number of elements in the nested table.



This count is printed using DBMS_OUTPUT.PUT_LINE.

Step 3: Accessing First and Last Elements

    -- Step 3: Show the first and last job IDs
    IF job_ids.COUNT > 0 THEN
        DBMS_OUTPUT.PUT_LINE('First job ID: ' || job_ids(job_ids.FIRST));
        DBMS_OUTPUT.PUT_LINE('Last job ID: ' || job_ids(job_ids.LAST));
    ELSE
        DBMS_OUTPUT.PUT_LINE('The nested table is empty.');
    END IF;






Checks if the nested table is not empty.



If it contains elements:





job_ids.FIRST returns the index of the first element.



job_ids.LAST returns the index of the last element.



Prints the first and last job IDs or a message if the table is empty.

Step 4: Removing Elements

    -- Step 4: Remove the last two IDs
    IF job_ids.COUNT >= 2 THEN
        job_ids.TRIM(2);
        DBMS_OUTPUT.PUT_LINE('Removed last two job IDs.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Not enough elements to remove last two.');
    END IF;






Checks if there are at least 2 elements in the nested table.



If true, job_ids.TRIM(2) removes the last two elements.



Prints a message indicating the result of the operation.

Step 5: Final Count

    -- Step 5: Print the new count of job IDs
    DBMS_OUTPUT.PUT_LINE('New number of job IDs: ' || job_ids.COUNT);






Prints the updated count of job IDs after the trimming operation.

Exception Handling

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
END;






Catches any unhandled exceptions that might occur during the execution.



Prints an error message using the SQLERRM function, which returns the error message of the current exception.

Key Takeaways





Nested Tables: The code demonstrates the use of nested tables, a PL/SQL collection type that allows for dynamic sizing and efficient element access.



Collection Methods: Various collection methods are used, such as EXTEND, COUNT, FIRST, LAST, and TRIM.



Cursor FOR Loop: Shows how to populate a nested table using a cursor FOR loop, which is an efficient way to process query results.



Conditional Logic: The code uses IF statements to handle different scenarios based on the nested table's content.



Exception Handling: Demonstrates basic exception handling to catch and report any errors that might occur during execution.

This PL/SQL block serves as an excellent example of working with nested tables and showcases common operations and best practices when dealing with collections in PL/SQL.
*/