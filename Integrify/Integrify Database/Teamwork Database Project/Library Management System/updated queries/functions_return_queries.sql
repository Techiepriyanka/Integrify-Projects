
SET search_path =library_system, "$user",public;

-- function: popular_books
-- returns the most popular book based on book loan

			SELECT * FROM popular_books(10);



-- function: books_borrowed
-- return books that are loaned between two dates

			SELECT * FROM books_borrowed('2023-12-15', '2023-12-25');


-- function: add_supplier			
-- adds new supplier record to the supplier table

			SELECT add_supplier(
			    'Finland Stationary',   -- supplier_name
			    'Helsinki', -- supplier_address
			    '123-456-7890',  -- supplier_ph_number
			    '2023-12-25',  -- contract_start_date
			    '2025-12-25'  -- contract_end_date
			);

-- function: make_purchase
-- adds new purchase record to the purchase table. Also, tables associated with purchase/adding new books are updated.

			SELECT * FROM make_purchase(
			    'Database',  -- title
			    'Rajendra Gautam',  -- author_name
			    'Science', --  category_name (poetry,DIY,Science,Travel, Horror, Non-fiction, etc..)
			    'Journals', -- type_name   (Thesis, Journals, Books, E-books, Magazines)
			    2023, -- Publication Year
			    2,    -- Purchase Quantity
			    40, -- Purchase Price
				2  -- supplier id
			);



-- function: book_search
-- returns the records based on different search functionality 

			SELECT * FROM Book_Search(
			    search_title => 'ML Foundation', -- Settling in Finland, The forbidden stone, The encyclopedia of the music business
			    search_author => NULL, 
			    search_category => NULL,
			    search_type => NULL,
			    search_year => NULL,
			    search_availability => NULL
			);

-- function: register_member
-- adds new members to the members table.

			SELECT Register_Member
					('ABCDE XYZ',  -- member name
					 'abcde@gmail.com',  -- member email
					 'individual',   -- member type
					 '2023-12-28');  -- member join date

-- function: reserve_book
-- reserves book when provided book_id and member_id

			SELECT * FROM Reserve_Book
					(137453,   -- book_id
					 1001); -- member_id


-- function: make_loan_after_reservation
-- makes loan when provided with (reservation_id staff_id)

			SELECT Make_Loan_After_Reservation
					(154, -- reservation_id
			 		4);  -- staff_id

-- function: update_return_status
-- this function takes in loan_id and updates the return status as true and also checks if there are fines
			SELECT Update_Return_Status
				(100002); -- loan_id















