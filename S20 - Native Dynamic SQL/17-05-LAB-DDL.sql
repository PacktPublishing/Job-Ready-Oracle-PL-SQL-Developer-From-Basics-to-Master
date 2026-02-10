-- First, let's create our main LIBRARY_BOOKS table
CREATE TABLE library_books (
    book_id         NUMBER PRIMARY KEY,
    title           VARCHAR2(100) NOT NULL,
    author          VARCHAR2(100) NOT NULL,
    isbn            VARCHAR2(13),
    genre           VARCHAR2(20),
    section         VARCHAR2(50),
    rating          NUMBER(3,2),  -- Allows ratings from 0.00 to 5.00
    available_copies NUMBER DEFAULT 1,
    total_copies     NUMBER DEFAULT 1,
    published_date   DATE,
    added_date      DATE DEFAULT SYSDATE,
    last_borrowed   DATE,
    CONSTRAINT chk_rating CHECK (rating >= 0 AND rating <= 5)
);

-- Create a sequence for book_id
CREATE SEQUENCE seq_book_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Let's create our BOOK_RECOMMENDATIONS table
CREATE TABLE book_recommendations (
    recommendation_id NUMBER PRIMARY KEY,
    book_id          NUMBER REFERENCES library_books(book_id),
    title            VARCHAR2(100),
    author           VARCHAR2(100),
    rating           NUMBER(3,2),
    recommended_date DATE DEFAULT SYSDATE,
    recommendation_source VARCHAR2(50)
);

-- Sequence for recommendation_id
CREATE SEQUENCE seq_recommendation_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Create a table for tracking borrowed books
CREATE TABLE book_loans (
    loan_id     NUMBER PRIMARY KEY,
    book_id     NUMBER REFERENCES library_books(book_id),
    borrower_id NUMBER,
    loan_date   DATE DEFAULT SYSDATE,
    due_date    DATE,
    return_date DATE,
    status      VARCHAR2(20) CHECK (status IN ('ACTIVE', 'RETURNED', 'OVERDUE')),
    CONSTRAINT chk_dates CHECK (return_date >= loan_date AND due_date >= loan_date)
);

-- Sequence for loan_id
CREATE SEQUENCE seq_loan_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;

-- Create an audit table for tracking cursor usage (for our monitoring example)
CREATE TABLE cursor_usage_log (
    log_id          NUMBER PRIMARY KEY,
    cursor_name     VARCHAR2(100),
    operation_type  VARCHAR2(20),
    operation_date  TIMESTAMP DEFAULT SYSTIMESTAMP,
    records_processed NUMBER,
    execution_time   NUMBER,
    user_id         VARCHAR2(30)
);

-- Sequence for log_id
CREATE SEQUENCE seq_log_id
    START WITH 1
    INCREMENT BY 1
    NOCACHE
    NOCYCLE;
