
-- Here below are some of the simple queries that can be run to extract reports. (Functions created are in another files)
-- These reports can provide valuable insights to the library admininstration (management).

-- Following queries can be found below.
		--    queries to see the table names and number of records in each table.
		
		-- 1. the number of books by category (descending order) that is present in the library.
		-- 2. books written by an author
		-- 3. the fine records of a particular member
		-- 4. the top 10 books loaned with category_name and book_type
		-- 5. the top 10 members along with their member type with highest number of book loans 
		-- 6. number of books loaned each month in a year
		-- 7. the number of books that hasn't been returned even after the due date
		-- 8. the number of new members who joined the library in the year
		-- 9. the number of loaned books per each book_type in descending order	
		-- 10. the number of copies present and also the number of avaialble copies for a specific book_id


---------------queries below ----------------------------------


-- setting the path to library_system schema
SET search_path =library_system, "$user",public;

-- first, lets see the table names that we have in our database and the number of records in each table.

			DO $$
			DECLARE
				table_name_text TEXT; 
				record_count INTEGER;
			BEGIN
				FOR table_name_text IN
					SELECT table_name
					FROM information_schema.tables 
					WHERE table_schema = 'library_system' AND table_type = 'BASE TABLE'
				LOOP
					EXECUTE format('SELECT COUNT(*) FROM library_system.%I', table_name_text)
					INTO record_count;

					RAISE NOTICE 'Table % has % records.', table_name_text, record_count;
				END LOOP;
			END;
			$$;


-- 1. calculating the number of books by category (descending order) that is present in the library

			SELECT category_name, COUNT(*) AS total_books
			FROM books b
			JOIN category c ON b.category_id = c.category_id
			GROUP BY category_name
			ORDER BY total_books DESC;

-- 2. returning books written by the author (Dean, James)

			SELECT b.title AS book_title, a.author_name AS author
			FROM books b
			JOIN author a ON b.author_id = a.author_id
			WHERE a.author_name = 'bibek kadel';

-- 3. returing the fine records of a particular member

			SELECT f.*
			FROM fine f
			JOIN member m ON f.member_id = m.member_id
			WHERE f.fine_amount > 0
			  AND m.name = 'Wiegand-Dach';
			
-- 4. returning the top 10 books loaned with category_name and book_type

			SELECT 
			    b.title AS book_title, 
			    c.category_name, 
			    bt.type_name AS book_type, 
			    COUNT(l.loan_id) AS loan_count
			FROM 
			    books b
			JOIN 
			    book_copies bc ON b.book_id = bc.book_id
			JOIN 
			    loan l ON bc.book_copy_id = l.book_copy_id
			JOIN 
			    category c ON b.category_id = c.category_id
			JOIN 
			    book_type bt ON b.book_type_id = bt.book_type_id
			GROUP BY 
			    b.title, c.category_name, bt.type_name
			ORDER BY 
			    loan_count DESC
			LIMIT 10;
			
-- 5. returning the top 10 members along with their member type with highest number of book loans 

			SELECT 
			    m.member_id, 
			    m.name AS member_name, 
			    m.type AS member_type, 
			    COUNT(l.loan_id) AS loan_count
			FROM 
			    member m
			JOIN 
			    loan l ON m.member_id = l.member_id
			GROUP BY 
			    m.member_id, m.name, m.type
			ORDER BY 
			    loan_count DESC
			LIMIT 10;

-- 6. returning number of books loaned each month in the year 2023

			SELECT 
			    EXTRACT(MONTH FROM l.issue_date) AS loan_month,
			    COUNT(*) AS books_borrowed
			FROM 
			    loan l
			WHERE 
			    EXTRACT(YEAR FROM l.issue_date) = 2023
			GROUP BY 
			    loan_month
			ORDER BY 
			    loan_month;


-- 7. returning the number of books that haven't been returned even after the due date

			SELECT COUNT(*) AS overdue_books_count
			FROM loan
			WHERE return_date < CURRENT_DATE
			  AND returned_or_not = false;
			
			
-- 8. returning the number of new members who joined the library
			SELECT
			    EXTRACT(MONTH FROM member_join_date) AS join_month,
			    COUNT(*) AS new_member_count
			FROM
			    member
			WHERE
			    EXTRACT(YEAR FROM member_join_date) = 2023
			GROUP BY
			    join_month
			ORDER BY
			    join_month;


-- 8 returning the number of loaned books per each category in descending order
			SELECT 
			    c.category_name,
			    COUNT(*) AS books_loaned
			FROM 
			    loan l
			JOIN 
			    book_copies bc ON l.book_copy_id = bc.book_copy_id
			JOIN 
			    books b ON bc.book_id = b.book_id
			JOIN 
			    category c ON b.category_id = c.category_id
			GROUP BY 
			    c.category_name
			ORDER BY 
			    books_loaned DESC;
			
-- 9 returning the number of loaned books per each book_type in descending order			

			SELECT 
			    bt.type_name AS book_type,
			    COUNT(*) AS books_loaned
			FROM 
			    loan l
			JOIN 
			    book_copies bc ON l.book_copy_id = bc.book_copy_id
			JOIN 
			    books b ON bc.book_id = b.book_id
			JOIN 
			    book_type bt ON b.book_type_id = bt.book_type_id
			GROUP BY 
			    bt.type_name
			ORDER BY 
			    books_loaned DESC;

-- 10. returning the number of copies present and also the number of avaialble copies for a specific book_id
			SELECT 
			    b.book_id,
			    b.title,
			    COUNT(bc.book_copy_id) AS total_copies,
			    SUM(CASE WHEN bc.availability = true THEN 1 ELSE 0 END) AS available_copies
			FROM 
			    books b
			JOIN 
			    book_copies bc ON b.book_id = bc.book_id
			WHERE 
			    b.book_id =119781
			GROUP BY 
			    b.book_id, b.title;








