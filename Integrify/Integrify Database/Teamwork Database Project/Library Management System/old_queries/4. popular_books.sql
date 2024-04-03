
SET search_path =library_system, "$user",public;

-- finding out the most popular books in the library (book that is loaned most)

CREATE FUNCTION Popular_books(limit_count INT)
RETURNS TABLE (
    book_title VARCHAR(255),
    total_borrowed INT
) AS $$
BEGIN
    RETURN QUERY
    SELECT b.title AS book_title, COUNT(l.loan_id)::INT AS total_borrowed
FROM books b
INNER JOIN book_copies bc ON b.book_id = bc.book_id
INNER JOIN loan l ON bc.book_copy_id = l.book_copy_id
GROUP BY b.title
ORDER BY total_borrowed DESC
LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;










