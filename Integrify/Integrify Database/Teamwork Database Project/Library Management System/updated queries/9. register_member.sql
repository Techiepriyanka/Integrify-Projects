SET search_path =library_system, "$user",public;

-- when registering, first we check if the member name, email and member-type already exists.
-- for individual member, borrow limit is set as 4.
-- for institutional member, borrow limit is set as 5.

CREATE OR REPLACE FUNCTION Register_Member(
    member_name VARCHAR(100),
    member_email VARCHAR(100),
    member_type VARCHAR(50),
    join_date DATE
)
RETURNS VOID AS $$
DECLARE
    borrow_limit INTEGER;
    calculated_duration INTEGER;
BEGIN
    IF member_type NOT IN ('individual', 'institutional') THEN
        RAISE EXCEPTION 'Invalid member type. Please select either individual or institutional.';
    END IF;

    -- here, we check if the member with the same name, email and meber_type already exists, if exists exception is raised
    IF EXISTS (
        SELECT 1 FROM member 
        WHERE name = member_name AND email = member_email AND type = member_type
    ) THEN
        RAISE EXCEPTION 'Member with the same name, email, and member_type already exists.';
    ELSE
        -- if member does doesn't exist, a new record is created for the new member
        IF member_type = 'individual' THEN
            borrow_limit := 4; 
        ELSIF member_type = 'institutional' THEN
            borrow_limit := 5; 
        END IF;

        -- determining the duration based on join_date and current_date (for the new member and also the existing member)
        calculated_duration := CASE 
                                    WHEN CURRENT_DATE - join_date <= 1 THEN 1 -- for the first day its 1
                                    ELSE CURRENT_DATE - join_date -- for the rest, it determines as current_date - join_date
                               END;

UPDATE member 
        SET duration = CASE 
                            WHEN CURRENT_DATE - member_join_date <= 1 THEN 1 
                            ELSE CURRENT_DATE - member_join_date 
                       END;
        -- now with the calculated duration, the new member recirded in inserted
        INSERT INTO member (name, email, type, member_join_date, borrow_limit, duration)
        VALUES (member_name, member_email, member_type, join_date, borrow_limit, calculated_duration);
    END IF;

END;
$$ LANGUAGE plpgsql;



