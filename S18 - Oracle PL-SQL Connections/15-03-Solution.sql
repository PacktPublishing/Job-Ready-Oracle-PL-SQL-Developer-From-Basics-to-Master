DECLARE
    TYPE top_earners_type IS VARRAY(3) OF employees.first_name%TYPE;
    top_earners top_earners_type := top_earners_type();
    v_temp_name employees.first_name%TYPE;
    v_count NUMBER := 0;

BEGIN
    -- Step 1: Populate the varray with top 3 earners
    FOR rec IN (
        SELECT first_name
        FROM (
            SELECT first_name, salary
            FROM employees
            ORDER BY salary DESC
        )
        WHERE ROWNUM <= 3
    ) LOOP
        v_count := v_count + 1;
        top_earners.EXTEND;
        top_earners(v_count) := rec.first_name;
    END LOOP;

    -- Step 2: Display initial list of top earners
    DBMS_OUTPUT.PUT_LINE('Initial Top 3 earners:');
    FOR i IN 1..top_earners.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || top_earners(i));
    END LOOP;

    -- Step 3: Attempt to add a 4th person (this will raise an exception)
    BEGIN
        -- Check if the varray is already at its maximum size
        IF top_earners.COUNT = top_earners.LIMIT THEN
            RAISE_APPLICATION_ERROR(-20001, 'Cannot add a 4th person. Varray is full.');
        ELSE
            top_earners.EXTEND;
            top_earners(top_earners.COUNT) := 'Jane';
            DBMS_OUTPUT.PUT_LINE('Added 4th person successfully');
        END IF;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
    END;

    -- Step 4: Convert the second person's name to uppercase
    IF top_earners.COUNT >= 2 THEN
        v_temp_name := UPPER(top_earners(2));
        top_earners(2) := v_temp_name;
    END IF;

    -- Step 5: Display the updated list
    DBMS_OUTPUT.PUT_LINE('Updated list with second name in uppercase:');
    FOR i IN 1..top_earners.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(i || '. ' || top_earners(i));
    END LOOP;

EXCEPTION
    -- Handle any unexpected errors
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('An unexpected error occurred: ' || SQLERRM);
        DBMS_OUTPUT.PUT_LINE('Error stack: ' || DBMS_UTILITY.FORMAT_ERROR_BACKTRACE);
END;
