--------------------------------------------------------------------------
---------------------------- dim_product ---------------------------------
--------------------------------------------------------------------------

CREATE TABLE Dim_Product
(
    Product_ID      int NOT NULL,
    Product_Name    nvarchar(50),
    Product_Price   decimal(12,2),
    Package_Type    nvarchar(30),
    Is_Discontinued bit,
    START_DATE      datetime,
    END_DATE        datetime
);

--------------------------------------------------------------------------
-------------------------------- dim_supplier ----------------------------
--------------------------------------------------------------------------

CREATE TABLE Dim_Supplier
(
    Supplier_ID      int NOT NULL,
    Supplier_Name    nvarchar(40),
    Contact_Name     nvarchar(50),
    Supplier_City    nvarchar(40),
    Supplier_Country nvarchar(40),
    Supplier_Phone   nvarchar(30),
    Supplier_Fax     nvarchar(30),
    START_DATE       datetime,
    END_DATE         datetime
);


--------------------------------------------------------------------------
-------------------------------- dim_customer ----------------------------
--------------------------------------------------------------------------

CREATE TABLE Dim_Cust
(
    Cust_ID       int NOT NULL,
    Cust_FullName nvarchar(40),
    Cust_City     nvarchar(40),
    Cust_Country  nvarchar(40),
    Cust_Phone    nvarchar(20),
    START_DATE    datetime,
    END_DATE      datetime
);

--------------------------------------------------------------------------
-------------------------------- fact_sales ------------------------------
--------------------------------------------------------------------------

CREATE TABLE Fact_Sales
(
    Order_Item_ID     int,
    Order_ID          int,
    Cust_ID           int,
    Product_ID        int,
    Supplier_ID       int,
    Date_ID           int,
    Order_Quantity    int,
    Order_Unit_Price  decimal(10,2),
    Order_Total_Price decimal(12,2)
);
