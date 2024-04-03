SET search_path =library_system, "$user",public;

--creating a book search function. the function can take follwoing search parameters.

CREATE OR REPLACE FUNCTION Book_Search(
    search_title TEXT DEFAULT NULL,
    search_author TEXT DEFAULT NULL,
    search_category TEXT DEFAULT NULL,
    search_type TEXT DEFAULT NULL,
    search_year INTEGER DEFAULT NULL,
    search_availability BOOLEAN DEFAULT NULL
)
RETURNS TABLE (
    book_id INTEGER,
    book_copy_id INTEGER,
    book_title VARCHAR(255),
    author_name VARCHAR(255),
    book_type VARCHAR(255),
    category_name VARCHAR(255),
    publication_year INTEGER,
    availability BOOLEAN
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        b.book_id, 
        bc.book_copy_id,
        b.title AS book_title, 
        a.author_name, 
        bct.type_name AS book_type, 
        c.category_name, 
        bc.publication_year, 
        bc.availability
    FROM 
        books b
    JOIN 
        author a ON b.author_id = a.author_id
    JOIN 
        book_type bct ON b.book_type_id = bct.book_type_id
    JOIN 
        category c ON b.category_id = c.category_id
    JOIN 
        book_copies bc ON b.book_id = bc.book_id
    WHERE 
        (search_title IS NULL OR b.title ILIKE '%' || search_title || '%') 
        AND (search_author IS NULL OR a.author_name ILIKE '%' || search_author || '%') 
        AND (search_category IS NULL OR c.category_name ILIKE '%' || search_category || '%') 
        AND (search_type IS NULL OR bct.type_name ILIKE '%' || search_type || '%') 
        AND (search_year IS NULL OR bc.publication_year = search_year) 
        AND (search_availability IS NULL OR bc.availability = search_availability) 
    ;
END;
$$ LANGUAGE plpgsql;

-- ILIKE is a string matching operator which is case-insensitive
--% is the wildcard which indicates any characters can appear before and after the team 'search_title'
-- || is used for concatination
