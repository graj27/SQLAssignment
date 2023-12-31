-- This stored procedure generates a report displaying a summary of Orders 
-- with the corresponding list of distinct invoices and their total amount ordered by Order Date in Descending order.


CREATE OR REPLACE PROCEDURE GetReport AS
BEGIN
    DBMS_OUTPUT.PUT_LINE('Order Reference' || CHR(9) || 'Order Period' || CHR(9) || 'Order Total Amount' || CHR(9) || 'Order Status' || CHR(9) || 'Invoice Reference' || CHR(9) || 'Invoice Total Amount' || CHR(9) || 'Supplier Name' || CHR(9) || 'Action');

    FOR order_rec IN (
        SELECT
            o.OrderReference,
            o.OrderDate,
            s.SupplierName,
            o.OrderTotalAmount,
            o.OrderStatus,
            LISTAGG(DISTINCT ol.InvoiceReference, '| ') WITHIN GROUP (ORDER BY ol.InvoiceReference) AS InvoiceReferences,
            SUM(NVL(ol.InvoiceAmount, 0)) AS TotalInvoiceAmount,
            CASE 
                WHEN COUNT(CASE WHEN ol.InvoiceStatus = 'Pending' THEN 1 END) > 0 THEN 'To follow up'
                WHEN COUNT(CASE WHEN ol.InvoiceStatus IS NULL OR ol.InvoiceStatus = '' THEN 1 END) > 0 THEN 'To verify'
                ELSE 'OK'
            END AS FollowUpStatus
        FROM
            OrderTbl o
            JOIN SupplierTbl s ON o.SupplierID = s.SupplierID
            JOIN OrderLineTbl ol ON o.OrderReference = ol.OrderReference
        GROUP BY
            o.OrderReference,
            o.OrderDate,
            s.SupplierName,
            o.OrderTotalAmount,
            o.OrderStatus
        ORDER BY o.OrderDate DESC
    ) LOOP
        DECLARE
            orderRef CLOB;
        BEGIN
            orderRef := REPLACE(order_rec.OrderReference, 'PO00', '');
            orderRef := REPLACE(orderRef, 'PO0', ''); -- Use the modified orderRef
            DBMS_OUTPUT.PUT_LINE(
                orderRef || CHR(9) || CHR(9) || TO_CHAR(order_rec.OrderDate, 'MON-YYYY') || CHR(9) || CHR(9) || TO_CHAR(order_rec.OrderTotalAmount,'FM999,999,990.00') || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                order_rec.OrderStatus || CHR(9) || CHR(9) || order_rec.InvoiceReferences || CHR(9) || CHR(9) || CHR(9) || CHR(9) ||
                TO_CHAR(order_rec.TotalInvoiceAmount,'FM999,999,990.00') || CHR(9) || CHR(9) || INITCAP(order_rec.SupplierName) || CHR(9) || CHR(9) || CHR(9) || order_rec.FollowUpStatus
            );
        END;
    END LOOP;
EXCEPTION
    WHEN OTHERS THEN
        -- Handle exceptions here, such as logging errors
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END GetReport;
/

----------------------------------------------------------------------------------------------

BEGIN
   GetReport;
END;


----------------------------------------------------------------------------------------

-- Order Reference	Order Period	Order Total Amount	Order Status	Invoice Reference	                                                            Invoice Total Amount	Supplier Name	        Action
-- 14		        SEP-0022		400,120.00				Open		INV_PO014.1| INV_PO014.2| INV_PO014.3| INV_PO014.4				                295,520.00		        Digisay Co. Ltd.		To follow up
-- 13		        AUG-0022		5,819,625.00			Closed		INV_PO013.1				                                                        5,819,625.00		    Mottoway Corp.			OK
-- 12		        AUG-0022		265,000.00				Open		INV_PO012.1| INV_PO012.2| INV_PO012.3				                            241,220.00		        Pegasus Ltd			    OK
-- 11		        JUL-0022		43,200.00				Closed		INV_PO011.1				                                                        43,200.00		        Lamboni Stat Inc.		OK
-- 10		        JUL-0022		182,700.00				Closed		INV_PO010.1				                                                        182,700.00		        Foxy Electronics		OK
-- 9		        JUN-0022		36,800.00				Open		INV_PO009.1				                                                        22,500.00		        Fireland Bros.			OK
-- 8		        JUN-0022		85,200.00				Open		INV_PO008.1| INV_PO008.2				                                        85,200.00		        Jinfix Computers		OK
-- 7		        JUN-0022		26,700.00				Closed		INV_PO007.1				                                                        17,200.00		        Safedest Taxi Services	OK
-- 5		        APR-0022		21,000.00				Closed		INV_PO005.1| INV_PO005.2				                                        21,000.00		        Emtello Ltd			    To follow up
-- 6		        FEB-0022		250,000.00				Open		INV_PO006.1| INV_PO006.2| INV_PO006.3| INV_PO006.4| INV_PO006.5| INV_PO006.6	235,000.00		        Stuffie Stationery		OK
-- 4		        FEB-0022		6,800.00				Closed		INV_PO004| INV_PO004.1				                                            6,200.00		        Lamboni Stat Inc.		OK
-- 3		        JAN-0022		57,300.00				Closed		INV_PO003.1| INV_PO003.2				                                        57,300.00		        Digisay Co. Ltd.		OK
-- 2		        JAN-0022		750,000.00				Open		INV_PO002.1| INV_PO002.2| INV_PO002.3            				                649,000.00		        Mottoway Corp.			To follow up
-- 1		        JAN-0022		10,000.00				Closed		INV_PO001| INV_PO001.1				                                            10,000.00		        Pegasus Ltd			    OK
-- --
