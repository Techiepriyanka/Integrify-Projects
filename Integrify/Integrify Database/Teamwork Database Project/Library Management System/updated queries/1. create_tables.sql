
-- hte database and schema were created from the pgAdmin4, however, following script is used for database and schema creation.

CREATE DATABASE group;
CREATE SCHEMA library_system;


-- The following script was generated after drawing the ERD in pgAdmin 4.

BEGIN;


CREATE TABLE IF NOT EXISTS library_system.book_type
(
    book_type_id serial,
    type_name character varying,
    PRIMARY KEY (book_type_id)
);

CREATE TABLE IF NOT EXISTS library_system.books
(
    book_id serial,
    author_id integer,
    category_id integer,
    book_type_id integer,
    title character varying,
    PRIMARY KEY (book_id)
);

CREATE TABLE IF NOT EXISTS library_system.author
(
    author_id serial,
    author_name character varying,
    PRIMARY KEY (author_id)
);

CREATE TABLE IF NOT EXISTS library_system.category
(
    category_id serial,
    category_name character varying,
    PRIMARY KEY (category_id)
);

CREATE TABLE IF NOT EXISTS library_system.reservation
(
    reservation_id serial,
    book_copy_id integer,
    member_id integer,
    reservation_date date,
    PRIMARY KEY (reservation_id)
);

CREATE TABLE IF NOT EXISTS library_system.purchase
(
    purchase_id serial,
    book_id integer,
    supplier_id integer,
    purchase_date date,
    purchase_quantity integer,
    purchase_price integer,
    PRIMARY KEY (purchase_id)
);

CREATE TABLE IF NOT EXISTS library_system.supplier
(
    supplier_id serial,
    supplier_name character varying,
    supplier_address character varying,
    supplier_ph_number character varying,
    contract_start_date date,
    contract_end_date date,
    PRIMARY KEY (supplier_id)
);

CREATE TABLE IF NOT EXISTS library_system.member
(
    member_id serial,
    name character varying,
    email character varying,
    type character varying,
    member_join_date date,
    borrow_limit integer,
    duration integer,
    PRIMARY KEY (member_id)
);

CREATE TABLE IF NOT EXISTS library_system.loan
(
    loan_id serial,
    member_id integer,
    book_copy_id integer,
    staff_id integer,
    issue_date date,
    return_date date,
    returned_or_not boolean,
    PRIMARY KEY (loan_id)
);

CREATE TABLE IF NOT EXISTS library_system.fine
(
    fine_id serial,
    member_id integer,
    book_copy_id integer,
    loan_id integer,
    due_date date,
    actual_return_date date,
    fine_amount integer,
    PRIMARY KEY (fine_id)
);

CREATE TABLE IF NOT EXISTS library_system.staff
(
    staff_id serial,
    staff_name character varying,
    staff_address character varying,
    staff_role character varying,
    staff_ph_number character varying,
    staff_join_date date,
    PRIMARY KEY (staff_id)
);

CREATE TABLE IF NOT EXISTS library_system.book_copies
(
    book_copy_id serial,
    book_id integer,
    publication_year integer,
    availability boolean,
    PRIMARY KEY (book_copy_id)
);

ALTER TABLE IF EXISTS library_system.books
    ADD FOREIGN KEY (book_type_id)
    REFERENCES library_system.book_type (book_type_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.books
    ADD FOREIGN KEY (author_id)
    REFERENCES library_system.author (author_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.books
    ADD FOREIGN KEY (category_id)
    REFERENCES library_system.category (category_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.reservation
    ADD FOREIGN KEY (member_id)
    REFERENCES library_system.member (member_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.reservation
    ADD FOREIGN KEY (book_copy_id)
    REFERENCES library_system.book_copies (book_copy_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.purchase
    ADD FOREIGN KEY (book_id)
    REFERENCES library_system.books (book_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.purchase
    ADD FOREIGN KEY (supplier_id)
    REFERENCES library_system.supplier (supplier_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.loan
    ADD FOREIGN KEY (member_id)
    REFERENCES library_system.member (member_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.loan
    ADD FOREIGN KEY (staff_id)
    REFERENCES library_system.staff (staff_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.loan
    ADD FOREIGN KEY (book_copy_id)
    REFERENCES library_system.book_copies (book_copy_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.fine
    ADD FOREIGN KEY (member_id)
    REFERENCES library_system.member (member_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.fine
    ADD FOREIGN KEY (loan_id)
    REFERENCES library_system.loan (loan_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;


ALTER TABLE IF EXISTS library_system.book_copies
    ADD FOREIGN KEY (book_id)
    REFERENCES library_system.books (book_id) MATCH SIMPLE
    ON UPDATE NO ACTION
    ON DELETE NO ACTION
    NOT VALID;

END;