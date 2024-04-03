

SET search_path =library_system, "$user",public;

-- function: popular_books
-- returns the most popular book based on book loan

-- 			SELECT * FROM Popular_Items_Report(10);

-- function: books_borrowed
-- return books that are loaned between two dates

-- 			SELECT * FROM books_borrowed('2023-12-15', '2023-12-25');


-- function: book_search
-- returns the records based on different search functionality 

			-- SELECT * FROM Book_Search(
			--     search_title => 'Rain forest', 
			--     search_author => NULL, 
			--     search_category => 'Meditation',
			--     search_type => NULL,
			--     search_year => NULL,
			--     search_availability => NULL
			-- );
			
-- function: add_supplier			
-- adds new supplier record to the supplier table

			-- SELECT add_supplier(
			--     'Integrify',
			--     'Helsinki Street',
			--     '123-456-7890',
			--     '2023-12-24',
			--     '2024-12-24'
			-- );

-- function: make_purchase
-- adds new purchase record to the purchase table. Also, tables associated with purchase/adding new books are updated.

			-- SELECT * FROM make_purchase(
			--     'My Stories',
			--     'Rajesh Hamal',
			--     'Music',
			--     'Journals',
			--     2023, -- Publication Year
			--     3,    -- Purchase Quantity
			--     50 -- Purchase Price
			-- );


-- function: register_member
-- adds new members to the members table.

			-- SELECT Register_Member
					('Bibek Kadel', 
					 'bibekkadel@gmail.com',
					 'institutional', 
					 '2023-12-23');

-- function: reserve_book
-- reserves book when provided book_id and member_id

			-- SELECT * FROM Reserve_Book
			(123,   -- book_id
			 1001); -- member_id


-- function: make_loan_after_reservation
-- makes loan when provided with (book_copy_id, member_id, staff_id)

			-- SELECT Make_Loan_After_Reservation
			(123, -- book_copy_id
			 456, -- member_id
			 4);  -- staff_id

-- function: update_return_status
-- this function takes in loan_id and updates the return status as true and also checks if there are fines
			-- SELECT Update_Return_Status
			(100002); -- loan_id
















