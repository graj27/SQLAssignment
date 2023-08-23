
set serveroutput on;

CREATE SEQUENCE SupplierID_Seq START WITH 1 INCREMENT BY 1;

-- Create Supplier Table
CREATE TABLE Supplier (
    SupplierID NUMBER DEFAULT SupplierID_Seq.NEXTVAL PRIMARY KEY,
    SupplierName VARCHAR2(50),
    SupplierContactName VARCHAR2(50),
    SupplierAddress VARCHAR2(500),
    SupplierContactNumber1 VARCHAR2(20),
    SupplierContactNumber2 VARCHAR2(20),
    SupplierEmail VARCHAR2(50)
);

-- Create Order Table
CREATE TABLE OrderTable (
    OrderReference VARCHAR2(100) PRIMARY KEY,
    SupplierID NUMBER,
    OrderDate DATE,
    OrderTotalAmount NUMBER(18, 2),
    OrderDescription VARCHAR2(500),
    OrderStatus VARCHAR2(50),
    FOREIGN KEY (SupplierID) REFERENCES Supplier(SupplierID)
);

-- Create OrderLine Table
CREATE TABLE OrderLine (
    InvoiceReference VARCHAR2(100),
    OrderReference VARCHAR2(100),
    OrderLineAmount NUMBER(18, 2),
    InvoiceDate DATE,
    InvoiceDescription VARCHAR2(500),
    InvoiceAmount NUMBER(18, 2),
    InvoiceHoldReason VARCHAR2(500),
    InvoiceStatus VARCHAR2(50),
    PRIMARY KEY (InvoiceReference,OrderReference,OrderLineAmount,InvoiceDate),
    FOREIGN KEY (OrderReference) REFERENCES OrderTable(OrderReference)
);



DROP TABLE OrderLine;

DROP TABLE OrderTable;

DROP TABLE Supplier;

DROP SEQUENCE SupplierID_Seq;




















-- Create InvoiceHoldReasons Table
CREATE TABLE InvoiceHoldReasons (
    InvoiceReference VARCHAR2(100) PRIMARY KEY,
    InvoiceHoldReason VARCHAR2(500),
    FOREIGN KEY (InvoiceReference) REFERENCES OrderLine(InvoiceReference)
);








-- Create InvoiceHoldReasons Table
CREATE TABLE InvoiceHoldReasons (
    InvoiceReference VARCHAR2(100),
    InvoiceHoldReason VARCHAR2(500),
    PRIMARY KEY(InvoiceReference),
    FOREIGN KEY (InvoiceReference) REFERENCES OrderLine(InvoiceReference)
);

CREATE TABLE InvoiceHoldReason (
    InvoiceReference  VARCHAR2(100) PRIMARY KEY,
    InvoiceHoldReasons VARCHAR2(100),
    CONSTRAINT fk_InvoiceHoldReason_Invoice
        FOREIGN KEY (InvoiceReference)
        REFERENCES OrderLine (InvoiceReference)
);



--DROP TABLE InvoiceHoldReasons;

CREATE TABLE Employee(
p_employee_id NUMBER(18, 2),
p_employee_name VARCHAR2(100));
