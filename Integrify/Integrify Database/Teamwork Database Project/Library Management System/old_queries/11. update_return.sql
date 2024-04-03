SET search_path =library_system, "$user",public;

--this function tries to updated the book return case and also see if there are fines iccurred

CREATE OR REPLACE FUNCTION Update_Return_Status(
    loan_id_value INTEGER
)
RETURNS VOID
AS $$
DECLARE
    fine_amount DECIMAL;
    due_date_value TIMESTAMP;
    actual_return_date_value TIMESTAMP;
BEGIN
    -- for the specified loan ID when the book is returend, the returned_or_not column is updated as true.
    UPDATE loan
    SET returned_or_not = true
    WHERE loan_id = loan_id_value;

    --  data for due date and current timestamp (actual return date) for fine calculation
    SELECT return_date, current_timestamp INTO due_date_value, actual_return_date_value
    FROM loan
    WHERE loan_id = loan_id_value;

    -- determining the fine amount
	-- for the first 5 days after due date, flat 5 euro is the fine.
	-- after 5 days, fine amount is increased by 1 euro for each day.
    fine_amount := CASE
        WHEN actual_return_date_value <= due_date_value THEN 0
        WHEN actual_return_date_value <= due_date_value + INTERVAL '5 days' THEN 5
        ELSE 5 + EXTRACT(DAY FROM actual_return_date_value - due_date_value - INTERVAL '5 days')::INTEGER
    END;

    -- now we insert fine details into the fine table
    INSERT INTO fine (member_id, book_copy_id, loan_id, due_date, actual_return_date, fine_amount)
    SELECT member_id, book_copy_id, loan_id, due_date_value, actual_return_date_value, fine_amount
    FROM loan
    WHERE loan_id = loan_id_value;
END;
$$ LANGUAGE plpgsql;

