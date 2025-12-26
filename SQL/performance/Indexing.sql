--------------------------------------------------------------------------
-------------------- Clustered Columnstore Index -------------------------
--------------------------------------------------------------------------

-- Creat Clustered Columnstore Index CCI
CREATE CLUSTERED COLUMNSTORE INDEX CCI_fact_sales
ON dbo.fact_sales;


--------------------------------------------------------------------------
---------------------------- Dim_Indexing --------------------------------
--------------------------------------------------------------------------

-- dim_customer [country, full_name]
Create Nonclustered Index IX_dim_customer_country
On dbo.dim_customer(country);


-- dim_product [product_name]
Create Nonclustered Index IX_dim_product_product_name
On dbo.dim_product(product_name);



-- dim_supplier [country, company_name]
Create Nonclustered Index IX_dim_supplier_country
On dbo.dim_supplier(country);

Create Nonclustered Index IX_dim_supplier_company_name
On dbo.dim_supplier(company_name);






























