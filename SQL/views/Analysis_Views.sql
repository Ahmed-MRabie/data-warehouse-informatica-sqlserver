------------------------------------------------------------------------------
----------------------------- Analysis Views ---------------------------------
------------------------------------------------------------------------------

--------------- Product Performance ---------------
Create OR Alter View dbo.vw_product_sales AS
Select
    p.product_name,
    p.unit_catalog_price,
    SUM(f.total_price) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    AVG(f.unit_price) AS avg_selling_price,
    COUNT(DISTINCT f.customer_id) AS total_customer
From dbo.fact_sales f
Join dbo.dim_product p On f.product_id = p.product_id
Group By p.product_name, p.unit_catalog_price;

Select * From dbo.vw_product_sales;




--------------- Country Performance ---------------
Create OR Alter View dbo.vw_country_sales AS
Select
    c.country As customer_country,
    SUM(f.total_price) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.customer_id) AS unique_customers,
    COUNT(DISTINCT f.product_id) AS unique_products
From dbo.fact_sales f
Join dbo.dim_customer c On f.customer_id = c.customer_id
Group By c.country;

Select * From dbo.vw_country_sales;



--------------- Monthly Sales ---------------
Create OR Alter View dbo.vw_monthly_sales AS
Select 
    d.year,
    d.month,
    FORMAT(d.full_date, 'yyyy-MM') AS year_month,
    SUM(f.total_price) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.customer_id) AS unique_customers,
    COUNT(DISTINCT f.product_id) AS unique_products
From dbo.fact_sales f
Join dbo.dim_date d On f.date_id = d.date_id
Group By d.year, d.month, FORMAT(d.full_date, 'yyyy-MM');

Select * From dbo.vw_monthly_sales;




--------------- Customer Performance ---------------
Create OR Alter View dbo.vw_customer_sales AS
Select
    c.customer_id,
    c.full_name As customer_name,
    c.country,
    c.city,
    SUM(f.total_price) AS total_spent,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.product_id) AS unique_products_bought,
    COUNT(DISTINCT f.supplier_id) AS unique_suppliers_bought_from
From dbo.fact_sales f
Join dbo.dim_customer c On f.customer_id = c.customer_id
Group By c.customer_id, c.full_name, c.country, c.city;

Select * From dbo.vw_customer_sales;




--------------- Yearly Growth ---------------
Create OR Alter View dbo.vw_yearly_growth As
With yearly_sales AS (
    Select
        d.year,
        SUM(f.total_price) AS total_sales
    From dbo.fact_sales f
    Join dbo.dim_date d On f.date_id = d.date_id
    Group By d.year
)
Select
    y1.year,
    y1.total_sales,
    LAG(y1.total_sales) OVER (ORDER BY y1.year) AS prev_year_sales,
    ROUND(
        (CAST(y1.total_sales AS FLOAT) - LAG(y1.total_sales) OVER (ORDER BY y1.year))
        / NULLIF(LAG(y1.total_sales) OVER (ORDER BY y1.year), 0) * 100, 2
    ) As growth_percent
From yearly_sales y1;

Select * From dbo.vw_yearly_growth;
-- transfare null to Zero
 -- null => Zero 


--------------- Top Products Per Country ---------------
Create OR Alter View dbo.vw_top_products_per_country AS
With country_product_sales AS (
    Select
        c.country As customer_country,
        p.product_name,
        SUM(f.total_price) AS total_sales
    From dbo.fact_sales f
    Join dbo.dim_customer c ON f.customer_id = c.customer_id
    Join dbo.dim_product p ON f.product_id = p.product_id
    Group By c.country, p.product_name
)
Select *
From (
    Select
        customer_country,
        product_name,
        total_sales,
        Dense_Rank() OVER (PARTITION BY customer_country ORDER BY total_sales DESC) AS rn
    From country_product_sales
) ranked
Where rn = 1;


Select * From dbo.vw_top_products_per_country;




--------------- Sales Weekend VS Weekday ---------------
Create OR Alter View dbo.vw_sales_weekend_vs_weekday AS
Select
    d.year,
    d.month,
    CASE WHEN d.is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END AS day_type,
    SUM(f.total_price) AS total_sales,
    SUM(f.quantity) AS total_quantity,
    COUNT(DISTINCT f.customer_id) AS unique_customers
FROM dbo.fact_sales f
JOIN dbo.dim_date d ON f.date_id = d.date_id
GROUP BY d.year, d.month, CASE WHEN d.is_weekend = 1 THEN 'Weekend' ELSE 'Weekday' END;

Select * From dbo.vw_sales_weekend_vs_weekday;





