
-- the following script copies the data from the csv files to each of the following tables.
-- tables (author, category, book_type, books, book_copies, member, reservation, supplier, purchase, staff, loan, fine )

SET search_path =library_system, "$user",public;

COPY author(author_name)
FROM '/Library/library file/author.csv'
DELIMITER ';' CSV HEADER;

COPY category(category_name)
FROM '/Library/library file/category.csv'
DELIMITER ';' CSV HEADER;

COPY book_type(type_name)
FROM '/Library/library file/book_type.csv'
DELIMITER ';' CSV HEADER;

COPY books(author_id,category_id,book_type_id,title)
FROM '/Library/library file/books.csv'
DELIMITER ';' CSV HEADER;

COPY book_copies(book_id,publication_year,availability)
FROM '/Library/library file/book_copies.csv'
DELIMITER ';' CSV HEADER;


COPY member(name,email,type,member_join_date,borrow_limit,duration)
FROM '/Library/library file/member.csv'
DELIMITER ';' CSV HEADER;


COPY reservation(book_copy_id,member_id,reservation_date)
FROM '/Library/library file/reservation.csv'
DELIMITER ';' CSV HEADER;

COPY supplier(supplier_name,supplier_address,supplier_ph_number,contract_start_date,contract_end_date)
FROM '/Library/library file/supplier.csv'
DELIMITER ';' CSV HEADER;

COPY purchase(book_id,supplier_id,purchase_date,purchase_quantity,purchase_price)
FROM '/Library/library file/purchase.csv'
DELIMITER ';' CSV HEADER;


COPY staff(staff_name,staff_address,staff_role,staff_ph_number,staff_join_date)
FROM '/Library/library file/staff.csv'
DELIMITER ';' CSV HEADER;


COPY loan(member_id,book_copy_id,staff_id,issue_date,return_date,returned_or_not)
FROM '/Library/library file/loan.csv'
DELIMITER ';' CSV HEADER;


COPY fine(member_id,book_copy_id,loan_id,due_date,fine_amount,payment_status,actual_return_date)
FROM '/Library/library file/fine.csv'
DELIMITER ';' CSV HEADER;
