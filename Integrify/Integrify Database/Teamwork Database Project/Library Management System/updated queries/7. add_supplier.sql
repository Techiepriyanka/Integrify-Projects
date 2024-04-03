
SET search_path = library_system, "$user", public;


-- creating a function named add_supplier to add supplier details to our system.
-- columns details are provided when addign the supplier.

CREATE OR REPLACE FUNCTION add_supplier(
    p_supplier_name TEXT,
    p_supplier_address TEXT,
    p_supplier_ph_number TEXT,
    p_contract_start_date DATE,
    p_contract_end_date DATE
)
RETURNS VOID AS $$
BEGIN
    INSERT INTO supplier (
        supplier_name,
        supplier_address,
        supplier_ph_number,
        contract_start_date,
        contract_end_date
    ) VALUES (
        p_supplier_name,
        p_supplier_address,
        p_supplier_ph_number,
        p_contract_start_date,
        p_contract_end_date
    );

END;
$$ LANGUAGE plpgsql;
