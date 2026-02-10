DECLARE
    -- First, let's create our book record structure
    TYPE book_rec_type IS RECORD (
        book_id     NUMBER,
        title       VARCHAR2(100),
        author      VARCHAR2(50),
        price       NUMBER(6,2),
        publish_date DATE
    );
    
    -- Let's use a nested table (since we don't know how many books we might have)
    TYPE book_list_type IS TABLE OF book_rec_type;
    
    -- Create and initialize our book list
    my_books book_list_type := book_list_type();
BEGIN
    -- Let's add some books to our collection
    -- First, extend the list to make room for a new book
    my_books.EXTEND;
    -- Add first book
    my_books(1).book_id := 1;
    my_books(1).title := 'The Great Gatsby';
    my_books(1).author := 'F. Scott Fitzgerald';
    my_books(1).price := 15.99;
    my_books(1).publish_date := DATE '1925-04-10';
    
    -- Add second book
    my_books.EXTEND;
    my_books(2).book_id := 2;
    my_books(2).title := '1984';
    my_books(2).author := 'George Orwell';
    my_books(2).price := 12.99;
    my_books(2).publish_date := DATE '1949-06-08';
    
    -- Add third book
    my_books.EXTEND;
    my_books(3).book_id := 3;
    my_books(3).title := 'To Kill a Mockingbird';
    my_books(3).author := 'Harper Lee';
    my_books(3).price := 14.99;
    my_books(3).publish_date := DATE '1960-07-11';
    
    -- Now let's display our book collection
    DBMS_OUTPUT.PUT_LINE('My Book Collection:');
    DBMS_OUTPUT.PUT_LINE('------------------');
    
    FOR i IN 1 .. my_books.COUNT LOOP
        DBMS_OUTPUT.PUT_LINE(
            'Book #' || my_books(i).book_id || CHR(10) ||
            'Title: ' || my_books(i).title || CHR(10) ||
            'Author: ' || my_books(i).author || CHR(10) ||
            'Price: $' || TO_CHAR(my_books(i).price, '99.99') || CHR(10) ||
            'Published: ' || TO_CHAR(my_books(i).publish_date, 'Month DD, YYYY') || 
            CHR(10) || '------------------'
        );
    END LOOP;
END;
/
