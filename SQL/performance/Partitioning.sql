--------------------------------------------------------------------------
---------------------------- Partitioning --------------------------------
--------------------------------------------------------------------------


-- 1- Create File Groups in DWH when Create DB


-- 2- Create Patition function specify in it (col_data_type, range)
Create Partition Function pf_fact_sales_by_year (DATE)
As Range left 
For Values('2012-12-31', '2013-12-31', '2014-12-31');



-- 3- Create Partition scheme to Link partitions to filegroups
Create Partition Scheme ps_fact_sales_year
AS Partition pf_fact_sales_by_year
To (fg_2012, fg_2013, fg_2014, fg_others);



-- 4- Create Fact_Sales Partitioned Table 
CREATE TABLE dbo.fact_sales_part (
    order_id INT,
    order_item_id INT,
    customer_id INT,
    product_id INT,
    supplier_id INT,
    full_date DATE,
    date_id INT,
    quantity INT,
    unit_price DECIMAL(10,2),
    total_price DECIMAL(12,2)
) ON ps_fact_sales_year(full_date);



-- 5- data transfer from old fact_sales to new fact_sales_part
INSERT INTO dbo.fact_sales_part (order_id, order_item_id, customer_id, product_id, supplier_id, full_date, date_id, quantity, unit_price, total_price)
SELECT order_id, order_item_id, customer_id, product_id, supplier_id, CAST(CONVERT(CHAR(8), date_id) AS DATE) AS full_date, date_id, quantity, unit_price, total_price
FROM [FP_INT_DWH].[dbo].[fact_sales] f;


-- Check Partitioning
Select *, $partition.pf_fact_sales_by_year(full_date) AS Partition
From fact_sales;



