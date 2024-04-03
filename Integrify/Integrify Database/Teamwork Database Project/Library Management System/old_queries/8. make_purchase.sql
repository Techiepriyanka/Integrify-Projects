SET search_path = library_system, "$user", public;

-- creating a function named make_purchase (buy books from supplier)
-- when adding books to the system, the book details should be reflected in all the associated tables.
-- also, various checks are to be performed before adding books to the system. 
-- for instance, if the author of the book is already in the system, we don't need to create a new record for the author, rather add this book details to the already exisiting author.
-- similar case for category and book_type
-- for book_copies, the quantity of the book is increased in case of book already exists in the system.
-- if book is not present in the system, new record is created based on quantity purchased.

CREATE OR REPLACE FUNCTION make_purchase(
    p_title TEXT,
    p_author_name TEXT,
    p_category_name TEXT,
    p_type_name TEXT,
    p_publication_year INT,
    p_purchase_quantity INT,
    p_purchase_price NUMERIC
)
RETURNS TABLE (purchase_result TEXT) AS $$
DECLARE
    v_author_id INT;
    v_category_id INT;
    v_book_type_id INT;
    existing_book_id INT;
BEGIN
    -- here, we check if the author is already registered in our system.
    SELECT author_id INTO v_author_id
    FROM author
    WHERE author_name = p_author_name;

    IF NOT FOUND THEN
        -- if the author was not found in the system, a new author record is created.
        INSERT INTO author (author_name)
        VALUES (p_author_name)
        RETURNING author_id INTO v_author_id;
    END IF;

   -- here, we check if the category is already present in our system.
    SELECT category_id INTO v_category_id
    FROM category
    WHERE category_name = p_category_name;

    IF NOT FOUND THEN
	-- if the category was not found in the system, a new category is created.
        INSERT INTO category (category_name)
        VALUES (p_category_name)
        RETURNING category_id INTO v_category_id;
    END IF;

    -- checking if the book type of that book exists
    SELECT book_type_id INTO v_book_type_id
    FROM book_type
    WHERE type_name = p_type_name;

    IF NOT FOUND THEN
        -- if book type does not exist,a new book type entry is created
        INSERT INTO book_type (type_name)
        VALUES (p_type_name)
        RETURNING book_type_id INTO v_book_type_id;
    END IF;

    -- checking if the book already exists in the system
    SELECT book_id INTO existing_book_id
    FROM books
    WHERE title = p_title;

    IF existing_book_id IS NULL THEN
        -- if the book does not exist , a new entry in books table is created.
        INSERT INTO books (title, author_id, category_id, book_type_id)
        VALUES (p_title, v_author_id, v_category_id, v_book_type_id)
        RETURNING book_id INTO existing_book_id;

		-- also, based on the quantity purchased, the book copies record are created in book_copies table. 
        INSERT INTO book_copies (book_id, publication_year, availability)
        SELECT existing_book_id, p_publication_year, true
        FROM generate_series(1, p_purchase_quantity);
    ELSE
        -- if the book is already present in the system, the new book will get new book copies_id based on purchase quantity
        INSERT INTO book_copies (book_id, publication_year, availability)
        SELECT existing_book_id, p_publication_year, true
        FROM generate_series(1, p_purchase_quantity);
    END IF;

    -- here, we record the purchase made to the purchase table.
    INSERT INTO purchase (book_id, supplier_id, purchase_date, purchase_quantity, purchase_price)
    VALUES (existing_book_id, 1, CURRENT_DATE, p_purchase_quantity, p_purchase_price);

    -- if the record entry is successful, will return the message "Purchase is successful"
    RETURN QUERY SELECT 'Purchase is successful'::TEXT AS purchase_result;
END;
$$ LANGUAGE plpgsql;
