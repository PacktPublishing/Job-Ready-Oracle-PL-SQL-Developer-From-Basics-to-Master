1 DECLARE
2   -- Our varray
3   TYPE dept_names_varray IS VARRAY(5) OF departments.department_name%TYPE;
4   v_dept_names dept_names_varray := dept_names_varray();
5
6   -- A nested table
7   TYPE dept_names_nested IS TABLE OF departments.department_name%TYPE;
8   n_dept_names dept_names_nested := dept_names_nested();
9
10   -- An associative array
11   TYPE dept_names_assoc IS TABLE OF departments.department_name%TYPE
12      INDEX BY PLS_INTEGER;
13   a_dept_names dept_names_assoc;
14
15 BEGIN
16   -- Let's fill 'em up (but only with 4 for the varray)
17   FOR rec IN (SELECT department_name FROM departments WHERE ROWNUM <= 4) LOOP
18      v_dept_names.EXTEND;
19      v_dept_names(v_dept_names.LAST) := rec.department_name;
20      n_dept_names.EXTEND;
21      n_dept_names(n_dept_names.LAST) := rec.department_name;
22      a_dept_names(a_dept_names.COUNT + 1) := rec.department_name;
23 END LOOP;
24
25 -- Try to add up to the VARRAY limit
26 IF v_dept_names.COUNT <= v_dept_names.LIMIT THEN
27    v_dept_names.EXTEND;
28    v_dept_names(v_dept_names.LAST) := 'New Department 1';
29 END IF;
30 
31 IF v_dept_names.COUNT < v_dept_names.LIMIT THEN
32    v_dept_names.EXTEND;
33    v_dept_names(v_dept_names.LAST) := 'New Department 2';
34 END IF;
35
36 -- Extend others without issue
37 n_dept_names.EXTEND(2);
38 n_dept_names(n_dept_names.LAST - 1) := 'New Department 1';
39 n_dept_names(n_dept_names.LAST) := 'New Department 2';
40 a_dept_names(a_dept_names.COUNT + 1) := 'New Department 1';
41 a_dept_names(a_dept_names.COUNT + 1) := 'New Department 2';
42
43 -- Let's delete the middle ones and see what happens
44 n_dept_names.DELETE(3);
45 a_dept_names.DELETE(3);
46
47 -- Time to check our results
48 DBMS_OUTPUT.PUT_LINE('Varray has: ' || v_dept_names.COUNT);
49 DBMS_OUTPUT.PUT_LINE('Nested table has: ' || n_dept_names.COUNT);
50 DBMS_OUTPUT.PUT_LINE('Associative array has: ' || a_dept_names.COUNT);
51 DBMS_OUTPUT.PUT_LINE('Nested table still has index 3? ' || CASE WHEN n_dept_names.EXISTS(3) THEN 'Yep' ELSE 'Nope' END);
52 DBMS_OUTPUT.PUT_LINE('Associative array still has index 3? ' || CASE WHEN a_dept_names.EXISTS(3) THEN 'Yep' ELSE 'Nope' END);
53 END;

/*
When you run this code, here are the key points to look at:

Size Limit (Lines 25-34):

The varray is initially filled with 4 elements (lines 17-23).
We attempt to add up to 2 more elements to the varray (lines 25-34).
This demonstrates the varray's fixed-size nature (maximum of 5 elements).


Flexibility (Lines 36-41):

We add 2 more elements to the nested table and associative array without any size restrictions.
This shows how nested tables and associative arrays can grow dynamically.


Element Deletion (Lines 44-45):

We delete the middle element (index 3) from the nested table and associative array.
The varray is not affected by this deletion.


Count of Elements (Lines 48-50):

We print the final count of elements in each collection type.
This shows how deletion affects the count in nested tables and associative arrays, but not in varrays.


Existence of Elements (Lines 51-52):

We check if index 3 still exists in the nested table and associative array after deletion.
This demonstrates how deletion affects the structure of these collections.



When you run this code, pay attention to the output. You should see:

The varray will have 5 elements (or possibly 4 if the second addition exceeds the limit).
The nested table and associative array will have 6 elements before deletion and 5 after deletion.
Index 3 will not exist in the nested table and associative array after deletion.

This code effectively demonstrates:



- The fixed-size nature of varrays (they can't exceed their declared limit).




The dynamic sizing of nested tables and associative arrays.
How deletion affects nested tables and associative arrays (creating "gaps" in their structure) but not varrays.

These points highlight the key differences in behavior between varrays, nested tables, and associative arrays, showcasing their unique characteristics and use cases.
