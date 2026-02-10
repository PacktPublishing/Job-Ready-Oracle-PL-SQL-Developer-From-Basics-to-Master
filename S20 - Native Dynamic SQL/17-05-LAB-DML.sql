-- First, let's populate LIBRARY_BOOKS with a good mix of data
BEGIN
  -- Mystery Books
  INSERT INTO library_books (book_id, title, author, isbn, genre, section, rating, available_copies, total_copies, published_date)
  VALUES (seq_book_id.NEXTVAL, 'The Silent Patient', 'Alex Michaelides', '9781250301697', 'MYSTERY', 'FICTION', 4.6, 3, 5, TO_DATE('2019-02-05', 'YYYY-MM-DD'));

  INSERT INTO library_books (book_id, title, author, isbn, genre, section, rating, available_copies, total_copies, published_date)
  VALUES (seq_book_id.NEXTVAL, 'The Thursday Murder Club', 'Richard Osman', '9780241425442', 'MYSTERY', 'FICTION', 4.2, 2, 4, TO_DATE('2020-09-03', 'YYYY-MM-DD'));

  -- Fiction Books
  INSERT INTO library_books (book_id, title, author, isbn, genre, section, rating, available_copies, total_copies, published_date)
  VALUES (seq_book_id.NEXTVAL, 'The Midnight Library', 'Matt Haig', '9780525559474', 'FICTION', 'FICTION', 4.8, 0, 6, TO_DATE('2020-08-13', 'YYYY-MM-DD'));

  INSERT INTO library_books (book_id, title, author, isbn, genre, section, rating, available_copies, total_copies, published_date)
  VALUES (seq_book_id.NEXTVAL, 'Project Hail Mary', 'Andy Weir', '9780593135204', 'SCIFI', 'FICTION', 4.9, 1, 4, TO_DATE('2021-05-04', 'YYYY-MM-DD'));

  -- Let's add some non-fiction too
  INSERT INTO library_books (book_id, title, author, isbn, genre, section, rating, available_copies, total_copies, published_date)
  VALUES (seq_book_id.NEXTVAL, 'Atomic Habits', 'James Clear', '9781847941831', 'SELFHELP', 'NON-FICTION', 4.7, 2, 8, TO_DATE('2018-10-16', 'YYYY-MM-DD'));
END;
/

-- Now let's add more books in bulk using a loop
BEGIN
  -- Generate Mystery Books
  FOR i IN 1..20 LOOP
    INSERT INTO library_books (
      book_id, title, author, isbn, genre, section, rating, 
      available_copies, total_copies, published_date
    )
    VALUES (
      seq_book_id.NEXTVAL,
      'Mystery Book ' || i,
      'Author ' || DBMS_RANDOM.STRING('U', 10),
      '978' || LPAD(i, 10, '0'),
      'MYSTERY',
      'FICTION',
      ROUND(DBMS_RANDOM.VALUE(3.5, 5.0), 2),
      ROUND(DBMS_RANDOM.VALUE(0, 5)),
      5,
      TO_DATE('2020-01-01', 'YYYY-MM-DD') + i
    );
  END LOOP;

  -- Generate Fiction Books
  FOR i IN 1..30 LOOP
    INSERT INTO library_books (
      book_id, title, author, isbn, genre, section, rating, 
      available_copies, total_copies, published_date
    )
    VALUES (
      seq_book_id.NEXTVAL,
      'Fiction Novel ' || i,
      'Author ' || DBMS_RANDOM.STRING('U', 10),
      '977' || LPAD(i, 10, '0'),
      'FICTION',
      'FICTION',
      ROUND(DBMS_RANDOM.VALUE(3.0, 5.0), 2),
      ROUND(DBMS_RANDOM.VALUE(0, 5)),
      5,
      TO_DATE('2021-01-01', 'YYYY-MM-DD') + i
    );
  END LOOP;

  -- Add some recommendations
  INSERT INTO book_recommendations (
    recommendation_id, book_id, title, author, rating, 
    recommended_date, recommendation_source
  )
  SELECT 
    seq_recommendation_id.NEXTVAL,
    book_id,
    title,
    author,
    rating,
    SYSDATE - ROUND(DBMS_RANDOM.VALUE(1, 30)),
    'SYSTEM'
  FROM library_books
  WHERE rating >= 4.5;

  -- Add some book loans
  FOR i IN 1..50 LOOP
    INSERT INTO book_loans (
      loan_id, book_id, borrower_id, loan_date, due_date, 
      status
    )
    SELECT 
      seq_loan_id.NEXTVAL,
      book_id,
      ROUND(DBMS_RANDOM.VALUE(1000, 9999)),
      SYSDATE - ROUND(DBMS_RANDOM.VALUE(1, 30)),
      SYSDATE + 14,
      'ACTIVE'
    FROM library_books
    WHERE ROWNUM = 1;
  END LOOP;

  -- Commit all our changes
  COMMIT;
END;
/

-- Let's add some completed loans too
BEGIN
  FOR i IN 1..20 LOOP
    INSERT INTO book_loans (
      loan_id, book_id, borrower_id, loan_date, due_date, 
      return_date, status
    )
    SELECT 
      seq_loan_id.NEXTVAL,
      book_id,
      ROUND(DBMS_RANDOM.VALUE(1000, 9999)),
      SYSDATE - 60,
      SYSDATE - 46,
      SYSDATE - 50,
      'RETURNED'
    FROM library_books
    WHERE ROWNUM = 1;
  END LOOP;
  COMMIT;
END;
/