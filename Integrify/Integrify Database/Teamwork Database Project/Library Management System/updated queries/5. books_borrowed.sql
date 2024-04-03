
SET search_path =library_system, "$user",public;

-- details of the books borrowed between specified duration.
-- book_title and total_borrowed is returned

CREATE FUNCTION books_borrowed(start_date DATE, end_date DATE)
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
WHERE l.issue_date BETWEEN start_date AND end_date
GROUP BY b.title;
END;
$$ LANGUAGE plpgsql;