CREATE OR REPLACE PROCEDURE GetSupplierOrderSummary
IS
BEGIN
  -- Print headers
  DBMS_OUTPUT.PUT_LINE('Supplier Name' ||CHR(9) || 'Supplier Contact Name' || CHR(9) ||'Supplier Contact No. 1'||CHR(9)  ||'Supplier Contact No. 2'||CHR(9) || 'Total Orders' || CHR(9) || 'Order Total Amount');
  
  FOR result IN (
    SELECT
      s.SupplierName,
      s.SupplierContactName,
      s.SupplierContactNumber1,
      s.SupplierContactNumber2,
      COUNT(o.OrderReference) AS TotalOrders,
      SUM(o.OrderTotalAmount) AS OrderTotalAmount
    FROM SupplierTbl s
    JOIN OrderTbl o ON s.SupplierID = o.SupplierID
    WHERE TO_DATE(OrderDate, 'DD-MON-YY') >= TO_DATE('03-JAN-22', 'DD-MON-YY') 
      AND TO_DATE(OrderDate, 'DD-MON-YY') <= TO_DATE('30-Aug-22', 'DD-MON-YY')
    GROUP BY
      s.SupplierName,
      s.SupplierContactName,
      s.SupplierContactNumber1,
      s.SupplierContactNumber2
  ) LOOP
    -- Output each row's data
    DBMS_OUTPUT.PUT_LINE( result.SupplierName ||CHR(9) || CHR(9) ||result.SupplierContactName||CHR(9) ||CHR(9) || CHR(9)||result.SupplierContactNumber1 ||CHR(9) || CHR(9)||result.SupplierContactNumber2 ||CHR(9) || CHR(9) || result.TotalOrders || CHR(9) || CHR(9) ||   result.OrderTotalAmount
    );
  END LOOP;
END GetSupplierOrderSummary;
/


BEGIN
    GetSupplierOrderSummary;
END;
/


--set serveroutput on;

--------------------------------------------------------------------------------------------------
--Supplier Name	Supplier Contact Name	Supplier Contact No. 1	Supplier Contact No. 2	Total Orders	Order Total Amount
--PEGASUS LTD		Georges Neeroo			5741254S		4615841		2		275000
--MOTTOWAY CORP.		Stevens Seernah			57942513				2		6569625
--DIGISAY CO. LTD.		Berry Parker			6028010		57841266		1		57300
--LAMBONI STAT INC.		Frederic Pey			52557435				2		50000
--EMTELLO LTD		Megan Hembly			57841698		2420641		1		21000
--STUFFIE STATIONERY		Zenhir Belall			6547416				1		250000
--SAFEDEST TAXI SERVICES		Steeve Narsimullu			2174512		58741002		1		26700
--JINFIX COMPUTERS		Jordan Liu Min			2195412		58412556		1		85200
--FIRELAND BROS.		Amelia Bridney			59480015				1		36800
--FOXY ELECTRONICS		Reddy Floyd			52845412				1		182700

