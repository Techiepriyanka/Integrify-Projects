SET search_path =library_system, "$user",public;

CREATE OR REPLACE FUNCTION Make_Loan_After_Reservation(
    book_copy_id_value INTEGER,
    member_id_value INTEGER,
    staff_id_value INTEGER
)
RETURNS VOID
AS $$
DECLARE
    issue_date_value TIMESTAMP;
    return_date_value TIMESTAMP;
BEGIN
    issue_date_value := current_timestamp; -- issue date is the curent day date
    
    -- return date is the date after adding 15 days to the issue date
    return_date_value := issue_date_value + INTERVAL '15 days';

    -- a loan is made for the reserved copy for the member
    INSERT INTO loan (member_id, book_copy_id, staff_id, issue_date, return_date, returned_or_not)
    VALUES (
        member_id_value,
        book_copy_id_value,
        staff_id_value,
        issue_date_value,
        return_date_value,
        false
    );
END;
$$ LANGUAGE plpgsql;

