# Retail Sales Performance Analysis | MySQL

## Project Overview

This project uses MySQL to analyze retail sales transaction data, evaluate product performance, and identify sales trends across product categories and geographic regions.

The analysis focuses on preparing and validating data, calculating key sales metrics, classifying product performance, and creating a reusable SQL view for reporting.

The goal is to demonstrate how SQL can transform transactional data into structured information that supports business analysis and decision-making.

## Tools & Technologies

**Database:** MySQL

**Skills demonstrated:**
- Data cleaning and standardization
- Data quality validation
- SQL aggregation (`SUM`, `COUNT`)
- Filtering and grouping (`WHERE`, `GROUP BY`, `HAVING`)
- Conditional logic (`CASE WHEN`)
- Window functions (`OVER`, `PARTITION BY`)
- SQL views (`CREATE VIEW`)
- Revenue and sales performance analysis

## Dataset Overview

The analysis uses a retail sales dataset containing transaction-level information.

Key fields include:

| Column | Description |
|---|---|
| `Transaction_id` | Unique transaction identifier |
| `date` | Transaction date |
| `category` | Product category |
| `product_name` | Product purchased |
| `units_sold` | Number of units sold |
| `unit_price` | Price per unit |
| `total_revenue` | Revenue recorded for the transaction |
| `region` | Geographic sales region |
| `payment_method` | Customer payment method |

The SQL script also inserts additional Home Appliances transactions, including refrigerators, ranges, dishwashers, and other appliances.

## SQL Analysis Workflow

### 1. Data Preparation and Cleaning

The project begins by preparing transaction records for analysis.

The `TRIM()` function removes unnecessary leading and trailing spaces from product names, helping maintain consistent product identifiers.

```sql
UPDATE sales_data
SET product_name = TRIM(product_name);
```

### 2. Data Quality Validation

Two checks are used to identify potential data quality issues.

**Duplicate transaction detection**

```sql
SELECT
    Transaction_id,
    COUNT(*) AS times_appearing
FROM sales_data
GROUP BY Transaction_id
HAVING COUNT(*) > 1;
```

This identifies transaction IDs that appear more than once.

**Missing value detection**

The script checks key transaction fields for `NULL` values, including transaction IDs, dates, categories, product names, revenue, and regions.

These checks help identify records that may require further review before reporting.

### 3. Product Performance Classification

A `CASE WHEN` statement assigns performance tiers based on recorded transaction revenue.

| Performance Tier | Revenue Criteria |
|---|---|
| High Performer | $40,000 or more |
| Good Performer | $500 to $39,999.99 |
| Standard | Below $500 |

```sql
CASE
    WHEN SUM(total_revenue) >= 40000
        THEN 'High Performer'
    WHEN SUM(total_revenue) >= 500
        THEN 'Good Performer'
    ELSE 'Standard'
END AS performance_tier
```

This provides a way to categorize sales performance and identify higher-revenue transactions.

### 4. Category Sales Analysis

The project calculates total units sold across product categories.

```sql
SELECT
    category,
    SUM(units_sold) AS total_sold
FROM sales_data
GROUP BY category
ORDER BY total_sold DESC;
```

This analysis helps compare sales volume and identify categories with stronger unit sales.

### 5. Regional Revenue Analysis

Regional sales performance is evaluated using aggregated revenue and units sold.

```sql
SELECT
    region,
    SUM(total_revenue) AS total_revenue,
    SUM(units_sold) AS units_sold
FROM sales_data
GROUP BY region
ORDER BY total_revenue DESC;
```

This query supports comparisons of revenue generation and sales volume across geographic markets.

### 6. Window Functions

The project uses SQL window functions to calculate additional metrics while preserving individual transaction records.

These include:

- **Category units sold:** Total units sold within each product category.
- **Transaction frequency:** Number of records associated with each transaction ID.
- **Regional revenue:** Total recorded revenue within each region.
- **Regional units sold:** Total units sold within each region.

For example:

```sql
SUM(total_revenue) OVER (
    PARTITION BY region
) AS regional_total_revenue
```

Window functions make it possible to compare transaction-level records with broader category and regional totals.

### 7. Creating a Reusable SQL View

The analysis concludes by creating a SQL view named `view_sales`.

This view combines the original transaction fields with calculated metrics, including:

- Performance tier
- Total category units sold
- Transaction ID frequency
- Regional total revenue
- Regional total units sold

```sql
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
        WHEN total_revenue >= 40000
            THEN 'High Performer'
        WHEN total_revenue >= 500
            THEN 'Good Performer'
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
```

The view provides a reusable reporting structure without requiring the underlying analytical calculations to be rewritten for every query.

## Business Questions Explored

This analysis is designed to address questions such as:

1. Which product categories generate the highest sales volume?
2. How does revenue performance compare across geographic regions?
3. Which transactions qualify as high-performing based on revenue?
4. Are there duplicate transaction IDs or missing values in the dataset?
5. How can SQL views and window functions improve the efficiency of sales reporting?

## Key Takeaways

This project demonstrates how MySQL can be used to prepare, validate, and analyze retail transaction data.

Key technical outcomes include:

- Standardizing product names to improve data consistency.
- Identifying potential duplicate transactions and missing values.
- Aggregating sales performance across product categories and regions.
- Applying conditional logic to classify revenue performance.
- Using window functions to combine transaction-level and regional metrics.
- Creating a reusable SQL view to support further analysis and reporting.

## Repository Contents

```text
Retail-Sales-Performance-Analysis-MySQL/
├── README.md
└── salesPerformance.sql
```

## How to Explore the Project

1. Download or clone this repository.
2. Open `salesPerformance.sql` in MySQL Workbench.
3. Connect to a MySQL database containing a compatible `sales_data` table.
4. Review the data preparation and validation queries.
5. Explore the category, product, and regional analysis.
6. Create and query the `view_sales` view to inspect the calculated metrics.

**Note:** The SQL script includes additional transaction inserts and analysis queries. It assumes the underlying `sales_data` table already exists.

## About This Project

This project is part of my data analytics portfolio and demonstrates practical experience using MySQL to clean data, validate records, calculate business metrics, and prepare structured reporting datasets.

It reflects my interest in applying SQL to real-world analytical problems and developing efficient, reusable approaches to business data analysis.
