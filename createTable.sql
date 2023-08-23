-- This file contains the create table statements for the table SupplierTbl, OrderTbl and OrderLineTbl
-- SupplierTbl contains details for the suppliers
-- OrderTbl contains details for the orders
-- OrderLineTbl contains details for each invoice

--set serveroutput on;

CREATE SEQUENCE SupplierID_Seq START WITH 1 INCREMENT BY 1;

-- Create Supplier Table
CREATE TABLE SupplierTbl (
    SupplierID NUMBER DEFAULT SupplierID_Seq.NEXTVAL PRIMARY KEY,
    SupplierName VARCHAR2(50),
    SupplierContactName VARCHAR2(50),
    SupplierAddress VARCHAR2(500),
    SupplierContactNumber1 VARCHAR2(20),
    SupplierContactNumber2 VARCHAR2(20),
    SupplierEmail VARCHAR2(50)
);

-- Create Order Table
CREATE TABLE OrderTbl(
    OrderReference VARCHAR2(100) PRIMARY KEY,
    SupplierID NUMBER,
    OrderDate DATE,
    OrderTotalAmount NUMBER(18, 2),
    OrderDescription VARCHAR2(500),
    OrderStatus VARCHAR2(50),
    FOREIGN KEY (SupplierID) REFERENCES SupplierTbl(SupplierID)
);

-- Create OrderLine Table
CREATE TABLE OrderLineTbl (
    InvoiceReference VARCHAR2(100),
    OrderReference VARCHAR2(100),
    OrderLineAmount NUMBER(18, 2),
    InvoiceDate DATE,
    InvoiceDescription VARCHAR2(500),
    InvoiceAmount NUMBER(18, 2),
    InvoiceHoldReason VARCHAR2(500),
    InvoiceStatus VARCHAR2(50),
    PRIMARY KEY (InvoiceReference,OrderReference,OrderLineAmount,InvoiceDate),
    FOREIGN KEY (OrderReference) REFERENCES OrderTbl(OrderReference)
);



-----------------------------------------------------------------------------------


--Sequence SUPPLIERID_SEQ created.
--
--
--Table SUPPLIERTBL created.
--
--
--Table ORDERTBL created.
--
--
--Table ORDERLINETBL created.

