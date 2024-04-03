SET search_path =library_system, "$user",public;

CREATE OR REPLACE FUNCTION Reserve_Book(
    book_id_value INTEGER,
    member_id_value INTEGER
)
RETURNS VOID
AS $$
DECLARE
    selected_book_copy_id INTEGER;
    borrow_limit INTEGER;
    reservation_date TIMESTAMP;
BEGIN
    -- first, we check if the member has crossed the borrow limit
    SELECT CASE WHEN m.type = 'individual' THEN 4 ELSE 5 END
    INTO borrow_limit
    FROM member m
    WHERE m.member_id = member_id_value;

    IF borrow_limit IS NULL THEN
        RAISE EXCEPTION 'Member details not found';
    END IF;

    -- Check if the member has crossed the borrow limit
	IF EXISTS (
		SELECT 1
		FROM loan l
		WHERE l.member_id = member_id_value
		AND l.returned = false -- here, we only consider not-returned books i.e. returned_or_not column with values false
		GROUP BY l.member_id
		HAVING COUNT(*) >= borrow_limit
	) THEN
		RAISE EXCEPTION 'Borrow limit crossed for the member';
	END IF;

    -- Check if there are books not returned with the due date crossed
    IF EXISTS (
        SELECT 1
        FROM loan l
        JOIN fine f ON l.loan_id = f.loan_id
        WHERE l.member_id = member_id_value AND f.fine_amount > 0 AND f.due_date < CURRENT_DATE
    ) THEN
        RAISE EXCEPTION 'Member has overdue books';
    END IF;

    -- Check if the member has any pending fine payment
    IF EXISTS (
        SELECT 1
        FROM fine f
        WHERE f.member_id = member_id_value AND f.fine_amount > 0
    ) THEN
        RAISE EXCEPTION 'Member has pending fine payment';
    END IF;

    -- Find an available copy of the specified book
    SELECT bc.book_copy_id
    INTO selected_book_copy_id
    FROM book_copies bc
    WHERE bc.book_id = book_id_value AND bc.availability = true
    LIMIT 1;

    IF selected_book_copy_id IS NOT NULL THEN
        -- Reserve an available copy for the member
        INSERT INTO reservation (book_copy_id, member_id, reservation_date)
        VALUES (selected_book_copy_id, member_id_value, current_timestamp);
    ELSE
        -- Book copy not available, reserve book_id and wait for any available copy
        reservation_date := (SELECT MIN(due_date) FROM fine WHERE book_id = book_id_value);

        INSERT INTO reservation (book_copy_id, member_id, reservation_date)
        VALUES (book_id_value, member_id_value, reservation_date);
    END IF;
END;
$$ LANGUAGE plpgsql;
