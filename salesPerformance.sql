INSERT INTO sales_data  
VALUES  
 (10182, '2026-11-01', 'Home Appliances', 'Viking Range', 2, 12000, 24000, 'North America', 'Credit Card'),     
 (10183, '2026-11-01', 'Home Appliances', 'Thermador Range', 2, 8000, 16000, 'North America', 'Credit Card'),     
 (10184, '2026-11-04', 'Home Appliances', 'Frigidaire Range', 5, 3000, 1500, 'North America', 'Credit Card'),     
 (10185, '2026-11-08', 'Home Appliances', 'Viking Fridge', 3, 9000, 27000, 'North America', 'Credit Card'),     
 (10186, '2026-11-08', 'Home Appliances', 'Thermador Fridge', 4, 12000, 48000, 'North America', 'Credit Card'),     
 (10187, '2026-11-08', 'Home Appliances', 'LG Fridge', 7, 5000, 35000, 'North America', 'Credit Card'),     
 (10188, '2026-11-09', 'Home Appliances', 'Electrolux Washtower', 5, 6000, 30000, 'North America', 'Credit Card'),     
 (10189, '2026-11-10', 'Home Appliances', 'Miele Dishwasher', 10, 2000, 20000, 'North America', 'Credit Card'),     
 (10190, '2026-11-11', 'Home Appliances', 'XO Undercounter', 3, 8000, 24000, 'North America', 'Credit Card'),     
 (10191, '2026-11-11', 'Home Appliances', 'Subzero Undercounter', 7, 8000, 56000, 'North America', 'Credit Card'),     
 (10192, '2026-11-11', 'Home Appliances', 'Subzero Fridge', 4, 15000, 60000,  'North America', 'Credit Card'),    
 (10193, '2026-11-11', 'Home Appliances', 'Subzero Range', 4, 18000, 52000, 'North America', 'Credit Card');

UPDATE sales_data 
SET product_name = TRIM(product_name);

SELECT * FROM sales_data;

SELECT product_name, Category, units_sold
FROM sales_data 
WHERE Category = 'Home Appliances';

SELECT Transaction_id, product_name, SUM(total_revenue) AS total_revenue_per_item, 
CASE          
WHEN SUM(total_revenue) >= 40000 THEN 'High Performer'         
WHEN SUM(total_revenue) >= 500 THEN 'Good Performer'         
ELSE 'Standard'     
END AS performance_tier 
FROM sales_data 
GROUP BY product_name, Transaction_id 
ORDER BY total_revenue_per_item desc;

SELECT Category, SUM(units_sold) as total_sold 
FROM sales_data 
GROUP BY category 
ORDER BY total_sold desc;

SELECT
    Transaction_id,
    COUNT(*) AS times_appearing
FROM sales_data
GROUP BY Transaction_id
HAVING COUNT(*) > 1;

SELECT *
FROM sales_data
WHERE Transaction_id IS NULL
   OR date IS NULL
   OR category IS NULL
   OR Product_name IS NULL
   OR units_sold IS NULL
   OR unit_price IS NULL
   OR total_revenue IS NULL
   OR region IS NULL
   OR payment_method IS NULL;
   
SELECT
    region,
    SUM(total_revenue) AS total_revenue,
    SUM(units_sold) AS units_sold
FROM sales_data
GROUP BY region
ORDER BY total_revenue DESC;

CREATE VIEW view_sales AS
SELECT
    Transaction_id,
    date,
    category,
    product_name,
    units_sold,
    unit_price,
    total_revenue,
    region,
    payment_method,
    CASE
        WHEN total_revenue >= 40000 THEN 'High Performer'
        WHEN total_revenue >= 500 THEN 'Good Performer'
        ELSE 'Standard'
    END AS performance_tier,
    SUM(units_sold) OVER (
        PARTITION BY category
    ) AS total_sold,
    COUNT(*) OVER (
        PARTITION BY Transaction_id
    ) AS times_appearing,
    SUM(total_revenue) OVER (
        PARTITION BY region
    ) AS regional_total_revenue,

    SUM(units_sold) OVER (
        PARTITION BY region
    ) AS regional_total_units

FROM sales_data;

SELECT *
FROM view_sales;