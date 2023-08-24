-- This stored procedure will return details for the second highest Order Total Amount using data from the tables SupplierTbl, OrderTbl and OrderlineTbl.


CREATE OR REPLACE PROCEDURE GetReportSecondHighestTotalAmt AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Order Reference ' || 'Order Date ' || 'Order Total Amount ' || 'Order Status ' || 'Invoice References '|| 'Supplier Name ');

    FOR order_rec IN (
        SELECT o.OrderReference, o.OrderDate, s.SupplierName, o.OrderTotalAmount, o.OrderStatus
        FROM OrderTbl o
        JOIN SupplierTbl s ON o.SupplierID = s.SupplierID
        WHERE o.OrderTotalAmount = (
            SELECT MAX(OrderTotalAmount)
            FROM OrderTbl
            WHERE OrderTotalAmount < (
                SELECT MAX(OrderTotalAmount)
                FROM OrderTbl
            )
        )
    )
    LOOP
        DECLARE
            orderRef CLOB;
            InvoiceReferences CLOB;
        BEGIN
            orderRef := REPLACE(order_rec.OrderReference, 'PO00', '');
            orderRef := REPLACE(orderRef, 'PO0', ''); -- Use the modified orderRef

            -- Fetch the invoice references separately
            SELECT LISTAGG(InvoiceReference, '| ') WITHIN GROUP (ORDER BY InvoiceReference)
            INTO InvoiceReferences
            FROM OrderLineTbl
            WHERE OrderReference = order_rec.OrderReference;

            -- Process the retrieved data as needed
            DBMS_OUTPUT.PUT_LINE(
                orderRef || CHR(9) || CHR(9) || CHR(9) ||TO_CHAR(TO_DATE(order_rec.OrderDate, 'DD-MON-RR'), 'Month DD, YYYY')  || CHR(9) || CHR(9) || TO_CHAR(order_rec.OrderTotalAmount) || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                order_rec.OrderStatus || CHR(9) || CHR(9) || InvoiceReferences || CHR(9) || CHR(9)||UPPER(order_rec.SupplierName));
        EXCEPTION
            WHEN OTHERS THEN
                -- Handle exceptions here, such as logging errors
                DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
        END;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END GetReportSecondHighestTotalAmt;
/


-------------------------------------------------------


BEGIN
   GetReportSecondHighestTotalAmt;
END;

---------------------------------------------------------------------------------

--
--Order Reference Order Date Order Total Amount Order Status Invoice References Supplier Name 
--2			January   10, 2022		750000				Open		INV_PO002.1| INV_PO002.2| INV_PO002.3		MOTTOWAY CORP.

