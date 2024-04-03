SET search_path =library_system, "$user",public;

CREATE OR REPLACE FUNCTION Make_Loan_After_Reservation(
    reservation_id_value INTEGER,
    staff_id_value INTEGER
)
RETURNS VOID
AS $$
DECLARE
    issue_date_value TIMESTAMP;
    return_date_value TIMESTAMP;
BEGIN
    issue_date_value := current_timestamp; -- issue date is defined as the current day date
    
    -- return date is the date after adding 15 days to the issue date
    return_date_value := issue_date_value + INTERVAL '15 days';

    -- first, we check if the reservation exists
    IF EXISTS (
        SELECT 1
        FROM reservation r
        WHERE r.reservation_id = reservation_id_value
    ) THEN
        -- here, we get the book copy and member ID associated with the reservation
        INSERT INTO loan (member_id, book_copy_id, staff_id, issue_date, return_date, returned_or_not)
        SELECT r.member_id, r.book_copy_id, staff_id_value, issue_date_value, return_date_value, false
        FROM reservation r
        WHERE r.reservation_id = reservation_id_value;
    ELSE
        -- If the reservation doesn't exist, an exception is raised
        RAISE EXCEPTION 'Reservation does not exists';
    END IF;
END;
$$ LANGUAGE plpgsql;
