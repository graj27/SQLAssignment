
--The stored procedure InsertSupplier checks if supplier already exists in SupplierTbl and then adds the supplier in the table

CREATE OR REPLACE PROCEDURE InsertSupplier(
    p_SupplierName VARCHAR2,
    p_SupplierContactName VARCHAR2,
    p_SupplierAddress VARCHAR2,
    p_SupplierContactNumber1 VARCHAR2,
    p_SupplierContactNumber2 VARCHAR2,
    p_SupplierEmail VARCHAR2
) AS
BEGIN
    -- Check if the values match the existing data
    FOR existing_supplier IN (
        SELECT * FROM SupplierTbl
        WHERE SupplierName = p_SupplierName
          AND SupplierContactName = p_SupplierContactName
          AND SupplierAddress = p_SupplierAddress
          AND SupplierContactNumber1 = p_SupplierContactNumber1
          OR SupplierContactNumber2 = p_SupplierContactNumber2
           OR SupplierContactNumber2 is null
          AND SupplierEmail = p_SupplierEmail
    ) LOOP
        -- Values match, do not insert
        DBMS_OUTPUT.PUT_LINE('Supplier already exists with the same details.'  || p_SupplierName);
        RETURN;
    END LOOP;

    -- Values don't match, proceed with the insert
    INSERT INTO SupplierTbl (
        SupplierName,
        SupplierContactName,
        SupplierAddress,
        SupplierContactNumber1,
        SupplierContactNumber2,
        SupplierEmail
    ) VALUES (
        p_SupplierName,
        p_SupplierContactName,
        p_SupplierAddress,
        p_SupplierContactNumber1,
        p_SupplierContactNumber2,
        p_SupplierEmail
    );
    COMMIT;

EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Supplier insertion failed: ' || SQLERRM);
END InsertSupplier;
/

-----------------------------------------------------------------------------------

--The stored procedure MigrateSupplierData is used by InsertSupplier to add supplier in table SupplierTbl


CREATE OR REPLACE PROCEDURE MigrateSupplierData AS
BEGIN
    -- Step 1: Extract data from XXBCM_ORDER_MGT
    FOR order_rec IN (SELECT * FROM XXBCM_ORDER_MGT) LOOP
        
    InsertSupplier(order_rec.SUPPLIER_NAME,order_rec.SUPP_CONTACT_NAME,order_rec.SUPP_ADDRESS,SUBSTR(order_rec.SUPP_CONTACT_NUMBER,INSTR(order_rec.SUPP_CONTACT_NUMBER, ',') + 1)
    ,SUBSTR(order_rec.SUPP_CONTACT_NUMBER, 1, INSTR(order_rec.SUPP_CONTACT_NUMBER, ',') - 1),order_rec.SUPP_EMAIL);
      
    END LOOP;

END MigrateSupplierData;
/


----------------------------------------------------------------------------------

--The stored procedure MigrateOrderTableData migrates orders in the table OrderTbl

CREATE OR REPLACE PROCEDURE MigrateOrderTableData AS
    suppId NUMBER; -- Declare suppId variable
    orderid CLOB;
BEGIN
    -- Step 1: Extract data from XXBCM_ORDER_MGT
    FOR order_rec IN (SELECT * FROM XXBCM_ORDER_MGT) LOOP
    
        -- Step 4: Insert data into Invoices table (if applicable)
        IF (order_rec.ORDER_LINE_AMOUNT IS NULL) 
            THEN
            
            -- Retrieve SupplierID using SupplierName
            SELECT SupplierID INTO suppId
            FROM SupplierTbl
            WHERE SupplierName = order_rec.SUPPLIER_NAME;
            
            orderid:=order_rec.ORDER_REF;
            
             
            -- Insert data into OrderTable
            INSERT INTO OrderTbl(OrderReference, SupplierID, OrderDate, OrderTotalAmount, OrderDescription, OrderStatus) 
            VALUES (order_rec.ORDER_REF, suppId, TO_DATE(order_rec.ORDER_DATE, 'DD-MM-YYYY'), TO_NUMBER(order_rec.ORDER_TOTAL_AMOUNT), order_rec.ORDER_DESCRIPTION, order_rec.ORDER_STATUS);
        END IF;
    END LOOP;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Data migration completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data migration failed: ' || SQLERRM);
END MigrateOrderTableData;
/

------------------------------------------------------------------------------------

--The stored procedure MigrateOrderTableData migrates the invoices details in the table OrderLineTbl



CREATE OR REPLACE PROCEDURE MigrateOrderLineTableData AS
    invoiceid CLOB;
BEGIN
    -- Step 1: Extract data from XXBCM_ORDER_MGT
    FOR order_rec IN (SELECT * FROM XXBCM_ORDER_MGT) LOOP
    
        -- Step 4: Insert data into Invoices table (if applicable)
        IF (order_rec.ORDER_LINE_AMOUNT IS NOT NULL AND order_rec.INVOICE_REFERENCE IS NOT NULL ) 
            THEN
            
            invoiceid:=order_rec.INVOICE_REFERENCE;
            
            -- Insert data into OrderLineTbl
            INSERT INTO OrderLineTbl(InvoiceReference,OrderReference, OrderLineAmount,InvoiceDate,InvoiceDescription,InvoiceAmount,InvoiceHoldReason,InvoiceStatus) 
            VALUES (order_rec.INVOICE_REFERENCE,order_rec.ORDER_REF, order_rec.ORDER_LINE_AMOUNT,TO_DATE(order_rec.INVOICE_DATE, 'DD-MM-YYYY'),order_rec.INVOICE_DESCRIPTION, TO_NUMBER(order_rec.INVOICE_AMOUNT), order_rec.INVOICE_HOLD_REASON, order_rec.INVOICE_STATUS);
      
        END IF;
    END LOOP;

    -- Commit the transaction
    COMMIT;

    DBMS_OUTPUT.PUT_LINE('Data migration completed successfully.');
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors or rolling back changes
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Data migration failed: ' || SQLERRM);
END MigrateOrderLineTableData;
/

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
CREATE OR REPLACE PROCEDURE ExecuteDataMigration
AS
BEGIN
    MigrateSupplierData;
    MigrateOrderTableData;
    MigrateOrderLineTableData;
END ExecuteDataMigration;

----------------------------------------------------------------

BEGIN
    ExecuteDataMigration;
END;
/

------------------------------------------------------------------

--Procedure INSERTSUPPLIER compiled


--Procedure MIGRATESUPPLIERDATA compiled
--
--
--Procedure MIGRATEORDERTABLEDATA compiled
--
--
--Procedure MIGRATEORDERLINETABLEDATA compiled
--
--
--Procedure EXECUTEDATAMIGRATION compiled


--
--Procedure EXECUTEDATAMIGRATION compiled
--
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.EMTELLO LTD
--Supplier already exists with the same details.EMTELLO LTD
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.EMTELLO LTD
--Supplier already exists with the same details.EMTELLO LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.STUFFIE STATIONERY
--Supplier already exists with the same details.JINFIX COMPUTERS
--Supplier already exists with the same details.JINFIX COMPUTERS
--Supplier already exists with the same details.FIRELAND BROS.
--Supplier already exists with the same details.FOXY ELECTRONICS
--Supplier already exists with the same details.FOXY ELECTRONICS
--Supplier already exists with the same details.FOXY ELECTRONICS
--Supplier already exists with the same details.FOXY ELECTRONICS
--Supplier already exists with the same details.FOXY ELECTRONICS
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.JINFIX COMPUTERS
--Supplier already exists with the same details.JINFIX COMPUTERS
--Supplier already exists with the same details.STUFFIE STATIONERY
--Supplier already exists with the same details.LAMBONI STAT INC.
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.STUFFIE STATIONERY
--Supplier already exists with the same details.JINFIX COMPUTERS
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.PEGASUS LTD
--Supplier already exists with the same details.STUFFIE STATIONERY
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.MOTTOWAY CORP.
--Supplier already exists with the same details.STUFFIE STATIONERY
--Supplier already exists with the same details.SAFEDEST TAXI SERVICES
--Supplier already exists with the same details.SAFEDEST TAXI SERVICES
--Supplier already exists with the same details.SAFEDEST TAXI SERVICES
--Supplier already exists with the same details.SAFEDEST TAXI SERVICES
--Supplier already exists with the same details.SAFEDEST TAXI SERVICES
--Supplier already exists with the same details.STUFFIE STATIONERY
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Supplier already exists with the same details.DIGISAY CO. LTD.
--Data migration completed successfully.
--Data migration completed successfully.
--
--
--PL/SQL procedure successfully completed.


