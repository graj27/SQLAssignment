--Before migrating the data into their respective tables, it is important to do data cleaning on table XXBCM_ORDER_MGT as the data contained errors

--The stored procedure CleanOrderLineAmount removes spaces, commas and converts 'o' to '0', 'I' to '1' and 'S' to '5' for the column ORDER_LINE_AMOUNT

CREATE OR REPLACE PROCEDURE CleanOrderLineAmount AS
    v_amt CLOB;
    CURSOR cur IS SELECT * FROM XXBCM_ORDER_MGT FOR UPDATE;
BEGIN
    -- Loop through each row in the table
    FOR rec IN cur LOOP
        -- Clean ORDER_LINE_AMOUNT column: remove spaces, commas and converting 'o' to '0', 'I' to '1' and 'S' to '5'
        v_amt := rec.ORDER_LINE_AMOUNT;
        v_amt := REGEXP_REPLACE(v_amt, '[ ,]', '', 1, 0);
        v_amt := REGEXP_REPLACE(v_amt, '[I]', '1', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[S]', '5', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[o]', '0', 1, 0, 'i');

        -- Update the row with the cleaned value
        UPDATE XXBCM_ORDER_MGT
        SET ORDER_LINE_AMOUNT = v_amt
        WHERE CURRENT OF cur;
    END LOOP;

    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Data cleaning completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data cleaning failed: ' || SQLERRM);
END CleanOrderLineAmount;
/

---------------------------------------------------------------------------------------------------------


--The stored procedure CleanTotalAmount removes spaces, commas and converts 'o' to '0', 'I' to '1' and 'S' to '5' for the column ORDER_TOTAL_AMOUNT


CREATE OR REPLACE PROCEDURE CleanTotalAmount AS
    v_amt CLOB;
    CURSOR cur IS SELECT * FROM XXBCM_ORDER_MGT FOR UPDATE;
BEGIN
    -- Loop through each row in the table
    FOR rec IN cur LOOP
        -- Clean ORDER_LINE_AMOUNT column: remove spaces, commas and converting 'o' to '0', 'I' to '1' and 'S' to '5'
        v_amt := rec.ORDER_TOTAL_AMOUNT;
        v_amt := REGEXP_REPLACE(v_amt, '[ ,]', '', 1, 0);
        v_amt := REGEXP_REPLACE(v_amt, '[I]', '1', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[S]', '5', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[o]', '0', 1, 0, 'i');

        -- Update the row with the cleaned value
        UPDATE XXBCM_ORDER_MGT
        SET ORDER_TOTAL_AMOUNT = v_amt
        WHERE CURRENT OF cur;
    END LOOP;

    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Data cleaning completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data cleaning failed: ' || SQLERRM);
END CleanTotalAmount;
/

------------------------------------------------------------------------------------------------------

--The stored procedure CleanInvoiceAmount removes spaces, commas and converts 'o' to '0', 'I' to '1' and 'S' to '5' for the column INVOICE_AMOUNT

CREATE OR REPLACE PROCEDURE CleanInvoiceAmount AS
    v_amt CLOB;
    CURSOR cur IS SELECT * FROM XXBCM_ORDER_MGT FOR UPDATE;
BEGIN
    -- Loop through each row in the table
    FOR rec IN cur LOOP
        -- Clean ORDER_LINE_AMOUNT column: remove spaces, commas and converting 'o' to '0', 'I' to '1' and 'S' to '5'
        v_amt := rec.INVOICE_AMOUNT;
        v_amt := REGEXP_REPLACE(v_amt, '[ ,]', '', 1, 0);
        v_amt := REGEXP_REPLACE(v_amt, '[I]', '1', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[S]', '5', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[o]', '0', 1, 0, 'i');

        -- Update the row with the cleaned value
        UPDATE XXBCM_ORDER_MGT
        SET INVOICE_AMOUNT = v_amt
        WHERE CURRENT OF cur;
    END LOOP;

    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Data cleaning completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data cleaning failed: ' || SQLERRM);
END CleanInvoiceAmount;
/


----------------------------------------------------------------------------------------------

--The stored procedure CleanSupContactNum removes spaces, dots and converts 'o' to '0' and 'I' to '1'  for the column SUPP_CONTACT_NUMBER

CREATE OR REPLACE PROCEDURE CleanSupContactNum AS
    v_amt CLOB;
    CURSOR cur IS SELECT * FROM XXBCM_ORDER_MGT FOR UPDATE;
BEGIN
    -- Loop through each row in the table
    FOR rec IN cur LOOP
        -- Clean ORDER_LINE_AMOUNT column: remove spaces, commas and converting 'o' to '0', 'I' to '1'
        v_amt := rec.SUPP_CONTACT_NUMBER;
        
        v_amt := REGEXP_REPLACE(v_amt, '[ ]', '', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[o]', '0', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[I]', '1', 1, 0, 'i');
        v_amt := REGEXP_REPLACE(v_amt, '[.]', '', 1, 0, 'i');
        -- Update the row with the cleaned value
        UPDATE XXBCM_ORDER_MGT
        SET SUPP_CONTACT_NUMBER = v_amt
        WHERE CURRENT OF cur;
    END LOOP;

    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Data cleaning completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data cleaning failed: ' || SQLERRM);
END CleanSupContactNum;
/

-------------------------------------------------------------------------------------------

--The stored procedure CleanDate converts the date in the format 'DD-MM-YYYY for the columns INVOICE_DATE and ORDER_DATE

CREATE OR REPLACE PROCEDURE CleanDate AS
    o_date DATE;
     i_date DATE;
    CURSOR cur IS SELECT * FROM XXBCM_ORDER_MGT FOR UPDATE;
BEGIN
    -- Loop through each row in the table
    FOR rec IN cur LOOP
        -- Clean ORDER_DATE column: convert ORDER_DATE and INVOICE_DATE to the desired format DD-MM-YYYY
         o_date := TO_DATE(rec.ORDER_DATE, 'DD-MM-YYYY');
         i_date := TO_DATE(rec.INVOICE_DATE, 'DD-MM-YYYY');
         DBMS_OUTPUT.PUT_LINE('Data cleaning date: ' || rec.ORDER_DATE|| ' ' || o_date || rec.INVOICE_DATE|| ' ' || i_date);
        -- Update the row with the cleaned value
        UPDATE XXBCM_ORDER_MGT
        SET ORDER_DATE = o_date, INVOICE_DATE = i_date
        WHERE CURRENT OF cur;
    END LOOP;

    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Data cleaning completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data cleaning failed: ' || SQLERRM || ' ' || o_date || ' ' || i_date);
END CleanDate;
/

-------------------------------------------------------------------------------------------

--The stored procedure CleanOrderRef removes '-1','-2','-3','-4','-5' and '-6' for the column ORDER_REF

CREATE OR REPLACE PROCEDURE CleanOrderRef AS
    v_amt CLOB;
    CURSOR cur IS SELECT * FROM XXBCM_ORDER_MGT FOR UPDATE;
BEGIN
    -- Loop through each row in the table
    FOR rec IN cur LOOP
        -- Clean ORDER_LINE_AMOUNT column: remove spaces and commas
        v_amt := rec.ORDER_REF;
        v_amt := REPLACE(v_amt, '-1', '');
        v_amt := REPLACE(v_amt, '-2', '');
        v_amt := REPLACE(v_amt, '-3', '');
        v_amt := REPLACE(v_amt, '-4', '');
         v_amt := REPLACE(v_amt, '-5', '');
        v_amt := REPLACE(v_amt, '-6', '');

        -- Update the row with the cleaned value
        UPDATE XXBCM_ORDER_MGT
        SET ORDER_REF = v_amt
        WHERE CURRENT OF cur;
    END LOOP;

    -- Commit the transaction
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Data cleaning completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data cleaning failed: ' || SQLERRM);
END CleanOrderRef;
/

BEGIN
    CleanOrderLineAmount;
    CleanTotalAmount;
    CleanInvoiceAmount;
    CleanSupContactNum;
    CleanDate;
    CleanOrderRef;
END;

-------------------------------------------------------------------------------------
--
--Procedure CLEANORDERLINEAMOUNT compiled
--
--
--Procedure CLEANTOTALAMOUNT compiled
--
--
--Procedure CLEANINVOICEAMOUNT compiled
--
--
--Procedure CLEANSUPCONTACTNUM compiled
--
--
--Procedure CLEANDATE compiled
--
--
--Procedure CLEANORDERREF compiled
--
--Data cleaning completed successfully.
--Data cleaning completed successfully.
--Data cleaning completed successfully.
--Data cleaning completed successfully.
--Data cleaning date: 03-JAN-22 03-JAN-22 
--Data cleaning date: 03-JAN-22 03-JAN-2228-FEB-22 28-FEB-22
--Data cleaning date: 03-JAN-22 03-JAN-2228-FEB-22 28-FEB-22
--Data cleaning date: 10-JAN-22 10-JAN-22 
--Data cleaning date: 10-JAN-22 10-JAN-2201-MAR-22 01-MAR-22
--Data cleaning date: 24-JAN-22 24-JAN-22 
--Data cleaning date: 24-JAN-22 24-JAN-2222-MAR-22 22-MAR-22
--Data cleaning date: 24-JAN-22 24-JAN-2222-MAR-22 22-MAR-22
--Data cleaning date: 24-JAN-22 24-JAN-2222-MAR-22 22-MAR-22
--Data cleaning date: 03-JAN-22 03-JAN-2228-FEB-22 28-FEB-22
--Data cleaning date: 07-FEB-22 07-FEB-22 
--Data cleaning date: 07-FEB-22 07-FEB-2215-FEB-22 15-FEB-22
--Data cleaning date: 07-FEB-22 07-FEB-2215-FEB-22 15-FEB-22
--Data cleaning date: 03-JAN-22 03-JAN-2228-FEB-22 28-FEB-22
--Data cleaning date: 10-JAN-22 10-JAN-2202-MAY-22 02-MAY-22
--Data cleaning date: 07-APR-22 07-APR-22 
--Data cleaning date: 07-APR-22 07-APR-2218-MAY-22 18-MAY-22
--Data cleaning date: 07-APR-22 07-APR-2218-MAY-22 18-MAY-22
--Data cleaning date: 24-JAN-22 24-JAN-2215-MAY-22 15-MAY-22
--Data cleaning date: 10-JAN-22 10-JAN-2205-AUG-22 05-AUG-22
--Data cleaning date: 07-FEB-22 07-FEB-2220-MAR-22 20-MAR-22
--Data cleaning date: 07-FEB-22 07-FEB-22 
--Data cleaning date: 07-APR-22 07-APR-2222-JUN-22 22-JUN-22
--Data cleaning date: 07-APR-22 07-APR-2222-JUN-22 22-JUN-22
--Data cleaning date: 03-JAN-22 03-JAN-2204-APR-22 04-APR-22
--Data cleaning date: 03-JAN-22 03-JAN-2204-APR-22 04-APR-22
--Data cleaning date: 16-FEB-22 16-FEB-22 
--Data cleaning date: 16-FEB-22 16-FEB-2222-MAR-22 22-MAR-22
--Data cleaning date: 03-JUN-22 03-JUN-22 
--Data cleaning date: 05-JUN-22 05-JUN-22 
--Data cleaning date: 05-JUN-22 05-JUN-2202-AUG-22 02-AUG-22
--Data cleaning date: 05-JUN-22 05-JUN-2202-AUG-22 02-AUG-22
--Data cleaning date: 18-JUN-22 18-JUN-22 
--Data cleaning date: 18-JUN-22 18-JUN-2224-AUG-22 24-AUG-22
--Data cleaning date: 03-JUL-22 03-JUL-22 
--Data cleaning date: 03-JUL-22 03-JUL-2215-AUG-22 15-AUG-22
--Data cleaning date: 03-JUL-22 03-JUL-2215-AUG-22 15-AUG-22
--Data cleaning date: 03-JUL-22 03-JUL-2202-SEP-22 02-SEP-22
--Data cleaning date: 03-JUL-22 03-JUL-2202-SEP-22 02-SEP-22
--Data cleaning date: 03-JUL-22 03-JUL-2215-AUG-22 15-AUG-22
--Data cleaning date: 06-JUL-22 06-JUL-22 
--Data cleaning date: 06-JUL-22 06-JUL-2218-SEP-22 18-SEP-22
--Data cleaning date: 05-JUN-22 05-JUN-2228-AUG-22 28-AUG-22
--Data cleaning date: 05-JUN-22 05-JUN-2228-AUG-22 28-AUG-22
--Data cleaning date: 16-FEB-22 16-FEB-2221-MAY-22 21-MAY-22
--Data cleaning date: 06-JUL-22 06-JUL-2218-SEP-22 18-SEP-22
--Data cleaning date: 16-AUG-22 16-AUG-22 
--Data cleaning date: 16-AUG-22 16-AUG-2207-AUG-22 07-AUG-22
--Data cleaning date: 16-FEB-22 16-FEB-2217-JUN-22 17-JUN-22
--Data cleaning date: 05-JUN-22 05-JUN-2228-AUG-22 28-AUG-22
--Data cleaning date: 16-AUG-22 16-AUG-2204-SEP-22 04-SEP-22
--Data cleaning date: 16-AUG-22 16-AUG-2207-AUG-22 07-AUG-22
--Data cleaning date: 16-AUG-22 16-AUG-2204-SEP-22 04-SEP-22
--Data cleaning date: 16-AUG-22 16-AUG-2229-SEP-22 29-SEP-22
--Data cleaning date: 16-AUG-22 16-AUG-2207-AUG-22 07-AUG-22
--Data cleaning date: 16-AUG-22 16-AUG-2204-SEP-22 04-SEP-22
--Data cleaning date: 16-AUG-22 16-AUG-2229-SEP-22 29-SEP-22
--Data cleaning date: 16-AUG-22 16-AUG-2229-SEP-22 29-SEP-22
--Data cleaning date: 16-FEB-22 16-FEB-2227-JUL-22 27-JUL-22
--Data cleaning date: 20-AUG-22 20-AUG-22 
--Data cleaning date: 20-AUG-22 20-AUG-2228-SEP-22 28-SEP-22
--Data cleaning date: 20-AUG-22 20-AUG-2228-SEP-22 28-SEP-22
--Data cleaning date: 20-AUG-22 20-AUG-2228-SEP-22 28-SEP-22
--Data cleaning date: 20-AUG-22 20-AUG-2228-SEP-22 28-SEP-22
--Data cleaning date: 16-FEB-22 16-FEB-2216-AUG-22 16-AUG-22
--Data cleaning date: 03-JUN-22 03-JUN-2230-JUL-22 30-JUL-22
--Data cleaning date: 03-JUN-22 03-JUN-2230-JUL-22 30-JUL-22
--Data cleaning date: 03-JUN-22 03-JUN-22 
--Data cleaning date: 03-JUN-22 03-JUN-2230-JUL-22 30-JUL-22
--Data cleaning date: 03-JUN-22 03-JUN-2230-JUL-22 30-JUL-22
--Data cleaning date: 16-FEB-22 16-FEB-2218-APR-22 18-APR-22
--Data cleaning date: 15-SEP-22 15-SEP-22 
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2215-OCT-22 15-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2215-OCT-22 15-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2227-OCT-22 27-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2205-NOV-22 05-NOV-22
--Data cleaning date: 15-SEP-22 15-SEP-22 
--Data cleaning date: 15-SEP-22 15-SEP-2227-OCT-22 27-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2227-OCT-22 27-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2205-NOV-22 05-NOV-22
--Data cleaning date: 15-SEP-22 15-SEP-2205-NOV-22 05-NOV-22
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2215-OCT-22 15-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2227-OCT-22 27-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2227-OCT-22 27-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-2203-OCT-22 03-OCT-22
--Data cleaning date: 15-SEP-22 15-SEP-22 
--Data cleaning completed successfully.
--Data cleaning completed successfully.
--
--
--PL/SQL procedure successfully completed.
--
--
