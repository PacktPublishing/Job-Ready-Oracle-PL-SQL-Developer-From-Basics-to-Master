DECLARE
  -- Our specialized library tools
  TYPE book_cur_type IS REF CURSOR;
  l_book_cursor book_cur_type;
  
  -- Variables to store what we find
  l_title    VARCHAR2(100);
  l_author   VARCHAR2(100);
  l_rating   NUMBER;
  
  -- What we're looking for today
  l_genre    VARCHAR2(20) := 'MYSTERY';  -- We'll start with mysteries
  l_min_rating NUMBER := 4.0;            -- Top-rated books only
  
  -- Counter for found books
  l_books_found NUMBER := 0;
BEGIN
  -- First, let's get access to our mystery section
  OPEN l_book_cursor FOR
    SELECT title, author, rating
    FROM library_books
    WHERE genre = l_genre
    AND rating >= l_min_rating
    ORDER BY rating DESC;
    
  -- Start our book search
  LOOP
    FETCH l_book_cursor 
    INTO  l_title, l_author, l_rating;
    
    EXIT WHEN l_book_cursor%NOTFOUND;
    
    -- Count books found
    l_books_found := l_books_found + 1;
    
    -- Share what we found
    DBMS_OUTPUT.PUT_LINE(
      l_books_found || '. Found: "' || l_title || '"' ||
      ' by ' || l_author ||
      ' (Rating: ' || l_rating || ' stars)'
    );
  END LOOP;
  
  -- Show total books found
  DBMS_OUTPUT.PUT_LINE('------------------------');
  DBMS_OUTPUT.PUT_LINE('Total books found: ' || l_books_found);
  
  -- Clean up (always close your cursor!)
  CLOSE l_book_cursor;
  
EXCEPTION
  WHEN OTHERS THEN
    -- Error handling
    DBMS_OUTPUT.PUT_LINE('An error occurred: ' || SQLERRM);
    -- Always close cursor, even if there's an error
    IF l_book_cursor%ISOPEN THEN
      CLOSE l_book_cursor;
    END IF;
    -- Re-raise the error
    RAISE;
END;
