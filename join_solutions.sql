select * from customer_feedback;
select * from employees;
select * from loyalty_members;
select * from online_orders;
select * from order_items;
select * from products;
select * from promotions;
select * from sales;
select * from store_inventory;
select * from stores;
select * from suppliers;


-- Write a query to list all stores with their manager's full name.
SELECT 
   s.store_id AS id, 
   s.store_name AS store, 
   s.city, 
   s.province, 
   e.first_name || ' ' || e.last_name AS manager
FROM 
   stores s
LEFT JOIN 
   employees e ON s.manager_id = e.employee_id;

-- Write a query to show all products with their supplier information.
SELECT 
   p.product_id AS id, 
   p.product_name AS product, 
   p.category, 
   p.unit_price AS price, 
   s.supplier_name AS supplier, 
   s.province
FROM 
   products p 
JOIN 
   suppliers s ON p.supplier_id = s.supplier_id;

-- List all customer feedback with store and sale information.
SELECT 
   cf.feedback_id, 
   cf.rating, 
   cf.comment, 
   so.store_name, 
   e.first_name 
FROM 
   customer_feedback cf
LEFT JOIN 
   stores so ON so.store_id = cf.store_id
LEFT JOIN 
   sales sa ON sa.sale_id = cf.sale_id
LEFT JOIN 
   employees e ON sa.employee_id = e.employee_id;

-- Find all employees who earn more than their direct supervisors.
SELECT 
    e.first_name || ' ' || e.last_name AS employee, 
    e.salary AS employee_salary, 
    s.first_name || ' ' || s.last_name AS supervisor, 
    s.salary, 
    e.salary - s.salary AS salary_difference
FROM 
    employees e 
JOIN 
    employees s ON e.supervisor_id = s.employee_id
WHERE 
    e.salary > s.salary;

-- Identify products sold in Ontario that have never been sold in Quebec.
SELECT DISTINCT p.product_name, p.category
FROM products p
JOIN sales sa ON p.product_id = sa.product_id
JOIN stores s ON sa.store_id = s.store_id
WHERE s.province = 'ON'
AND NOT EXISTS (
    SELECT 1
    FROM sales sa2
    JOIN stores s2 ON sa2.store_id = s2.store_id
    WHERE sa2.product_id = p.product_id
    AND s2.province = 'QC'
);

-- Find loyalty members who have purchased the same product both in-store and online.
SELECT
    CONCAT(lm.first_name, ' ', lm.last_name) AS customer_name,
    lm.membership_tier,
    p.product_name,
    s.sale_date AS store_purchase_date,
    o.order_date AS online_purchase_date
FROM 
    loyalty_members lm
JOIN 
    sales s ON lm.member_id = s.loyalty_member_id
JOIN 
    products p ON s.product_id = p.product_id
JOIN 
    online_orders o ON lm.member_id = o.customer_id
JOIN 
    order_items oi ON o.order_id = oi.order_id AND p.product_id = oi.product_id
ORDER BY
    customer_name, product_name;

-- Identify stores where inventory levels for products are below restock level but no restock has occurred in the past 60 days.
SELECT 
    s.store_name,
    p.product_name,
    si.stock_quantity AS current_quantity,
    si.restock_level,
    CURRENT_DATE - si.last_restock_date AS days_since_restock
FROM 
    store_inventory si
JOIN 
    stores s ON si.store_id = s.store_id
JOIN 
    products p ON si.product_id = p.product_id
WHERE 
    si.stock_quantity < si.restock_level
AND 
    (CURRENT_DATE - si.last_restock_date) > 60
ORDER BY 
    days_since_restock DESC;

-- Find stores with higher average customer feedback ratings than other stores in the same province.
WITH store_ratings AS (
    SELECT 
        s.store_id,
        s.store_name,
        s.province,
        AVG(cf.rating) AS store_avg_rating
    FROM 
        stores s
    JOIN 
        customer_feedback cf ON s.store_id = cf.store_id
    GROUP BY 
        s.store_id, s.store_name, s.province
),
province_ratings AS (
    SELECT 
        province,
        AVG(store_avg_rating) AS province_avg_rating
    FROM 
        store_ratings
    GROUP BY 
        province
)
SELECT 
    sr.store_name,
    sr.province,
    sr.store_avg_rating,
    pr.province_avg_rating,
    (sr.store_avg_rating - pr.province_avg_rating) AS rating_difference
FROM 
    store_ratings sr
JOIN 
    province_ratings pr ON sr.province = pr.province
WHERE 
    sr.store_avg_rating > pr.province_avg_rating
ORDER BY 
    rating_difference DESC;

-- Find all pairs of employees who share the same supervisor.
SELECT 
    e1.first_name || ' ' || e1.last_name AS employee1_name,
    e2.first_name || ' ' || e2.last_name AS employee2_name,
    s.first_name || ' ' || s.last_name AS supervisor_name
FROM 
    employees e1
JOIN 
    employees e2 ON e1.supervisor_id = e2.supervisor_id AND e1.employee_id < e2.employee_id
JOIN 
    employees s ON e1.supervisor_id = s.employee_id
ORDER BY 
    supervisor_name, employee1_name, employee2_name;

-- Find product pairs that are frequently purchased together in the same transaction.
SELECT 
    p1.product_name AS product1_name,
    p2.product_name AS product2_name,
    COUNT(*) AS purchase_count
FROM 
    sales s1
JOIN 
    sales s2 ON s1.loyalty_member_id = s2.loyalty_member_id 
             AND s1.sale_date = s2.sale_date 
             AND s1.product_id < s2.product_id
JOIN 
    products p1 ON s1.product_id = p1.product_id
JOIN 
    products p2 ON s2.product_id = p2.product_id
WHERE 
    s1.loyalty_member_id IS NOT NULL
GROUP BY 
    p1.product_name, p2.product_name
ORDER BY 
    purchase_count DESC;

-- For each supplier, compare the performance of their products in Eastern versus Western Canadian regions.
WITH eastern_sales AS (
    SELECT 
        p.supplier_id,
        SUM(s.total_price) AS eastern_total
    FROM 
        sales s
    JOIN 
        stores st ON s.store_id = st.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    WHERE 
        st.region = 'Eastern'
    GROUP BY 
        p.supplier_id
),
western_sales AS (
    SELECT 
        p.supplier_id,
        SUM(s.total_price) AS western_total
    FROM 
        sales s
    JOIN 
        stores st ON s.store_id = st.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    WHERE 
        st.region = 'Western'
    GROUP BY 
        p.supplier_id
)
SELECT 
    su.supplier_name,
    COUNT(DISTINCT p.product_id) AS product_count,
    COALESCE(es.eastern_total, 0) AS eastern_sales,
    COALESCE(ws.western_total, 0) AS western_sales,
    CASE 
        WHEN es.eastern_total = 0 OR ws.western_total = 0 THEN NULL
        ELSE ROUND(((ws.western_total - es.eastern_total) / es.eastern_total * 100), 2)
    END AS percentage_difference
FROM 
    suppliers su
JOIN 
    products p ON su.supplier_id = p.supplier_id
LEFT JOIN 
    eastern_sales es ON su.supplier_id = es.supplier_id
LEFT JOIN 
    western_sales ws ON su.supplier_id = ws.supplier_id
GROUP BY 
    su.supplier_name, es.eastern_total, ws.western_total
ORDER BY 
    ABS(COALESCE(CASE 
        WHEN es.eastern_total = 0 OR ws.western_total = 0 THEN NULL
        ELSE ROUND(((ws.western_total - es.eastern_total) / es.eastern_total * 100), 2)
    END, 0)) DESC;

-- Track the purchase history and point accumulation timeline for Gold tier customers.
WITH gold_member_purchases AS (
    SELECT 
        lm.member_id,
        CONCAT(lm.first_name, ' ', lm.last_name) AS customer_name,
        lm.points AS total_points,
        COUNT(s.sale_id) AS total_purchases,
        SUM(s.total_price) AS total_spent,
        ROUND(SUM(s.total_price) / COUNT(s.sale_id), 2) AS average_spend
    FROM 
        loyalty_members lm
    LEFT JOIN 
        sales s ON lm.member_id = s.loyalty_member_id
    WHERE 
        lm.membership_tier = 'Gold'
    GROUP BY 
        lm.member_id, lm.first_name, lm.last_name, lm.points
)
SELECT 
    gmp.customer_name,
    gmp.total_purchases,
    gmp.total_points,
    gmp.average_spend
FROM 
    gold_member_purchases gmp
ORDER BY 
    gmp.total_points DESC;

-- Find employees who have worked at more than one store and compare their sales performance between locations.
WITH employee_store_sales AS (
    SELECT 
        e.employee_id,
        CONCAT(e.first_name, ' ', e.last_name) AS employee_name,
        e.store_id,
        s.store_name,
        SUM(sa.total_price) AS store_sales
    FROM 
        employees e
    JOIN 
        sales sa ON e.employee_id = sa.employee_id
    JOIN 
        stores s ON e.store_id = s.store_id
    GROUP BY 
        e.employee_id, e.first_name, e.last_name, e.store_id, s.store_name
),
employees_multiple_stores AS (
    SELECT 
        employee_id,
        COUNT(DISTINCT store_id) AS store_count
    FROM 
        employee_store_sales
    GROUP BY 
        employee_id
    HAVING 
        COUNT(DISTINCT store_id) > 1
)
SELECT 
    ess1.employee_name,
    ess1.store_name AS store1_name,
    ess2.store_name AS store2_name,
    ess1.store_sales AS store1_sales,
    ess2.store_sales AS store2_sales,
    (ess2.store_sales - ess1.store_sales) AS sales_difference
FROM 
    employee_store_sales ess1
JOIN 
    employee_store_sales ess2 ON ess1.employee_id = ess2.employee_id AND ess1.store_id < ess2.store_id
JOIN 
    employees_multiple_stores ems ON ess1.employee_id = ems.employee_id
ORDER BY 
    ABS(ess2.store_sales - ess1.store_sales) DESC;

-- Analyze price differences between online and in-store purchases for the same products.
WITH in_store_pricing AS (
    SELECT 
        p.product_id,
        p.product_name,
        AVG(s.total_price / s.quantity) AS avg_in_store_price
    FROM 
        sales s
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        p.product_id, p.product_name
),
online_pricing AS (
    SELECT 
        p.product_id,
        p.product_name,
        AVG(oi.unit_price - oi.discount) AS avg_online_price
    FROM 
        order_items oi
    JOIN 
        products p ON oi.product_id = p.product_id
    GROUP BY 
        p.product_id, p.product_name
)
SELECT 
    isp.product_name,
    ROUND(isp.avg_in_store_price, 2) AS in_store_price,
    ROUND(op.avg_online_price, 2) AS online_price,
    ROUND((op.avg_online_price - isp.avg_in_store_price), 2) AS price_difference,
    CASE 
        WHEN isp.avg_in_store_price = 0 THEN NULL
        ELSE ROUND(((op.avg_online_price - isp.avg_in_store_price) / isp.avg_in_store_price * 100), 2)
    END AS percentage_difference
FROM 
    in_store_pricing isp
JOIN 
    online_pricing op ON isp.product_id = op.product_id
ORDER BY 
    ABS(op.avg_online_price - isp.avg_in_store_price) DESC;

-- Create a provincial performance dashboard showing aggregate metrics for each Canadian province.
WITH provincial_stores AS (
    SELECT 
        province,
        COUNT(store_id) AS store_count
    FROM 
        stores
    GROUP BY 
        province
),
provincial_sales AS (
    SELECT 
        st.province,
        SUM(s.total_price) AS total_sales
    FROM 
        sales s
    JOIN 
        stores st ON s.store_id = st.store_id
    GROUP BY 
        st.province
),
provincial_ratings AS (
    SELECT 
        st.province,
        ROUND(AVG(cf.rating), 2) AS avg_rating
    FROM 
        customer_feedback cf
    JOIN 
        stores st ON cf.store_id = st.store_id
    GROUP BY 
        st.province
),
top_products AS (
    SELECT 
        st.province,
        p.product_name AS top_product,
        SUM(s.quantity) AS product_quantity,
        ROW_NUMBER() OVER (PARTITION BY st.province ORDER BY SUM(s.quantity) DESC) AS rank
    FROM 
        sales s
    JOIN 
        stores st ON s.store_id = st.store_id
    JOIN 
        products p ON s.product_id = p.product_id
    GROUP BY 
        st.province, p.product_name
),
best_stores AS (
    SELECT 
        st.province,
        st.store_name AS best_store,
        SUM(s.total_price) / COUNT(DISTINCT s.sale_id) AS avg_transaction_value,
        ROW_NUMBER() OVER (PARTITION BY st.province ORDER BY SUM(s.total_price) / COUNT(DISTINCT s.sale_id) DESC) AS rank
    FROM 
        sales s
    JOIN 
        stores st ON s.store_id = st.store_id
    GROUP BY 
        st.province, st.store_name
)
SELECT 
    ps.province,
    ps.store_count,
    COALESCE(psa.total_sales, 0) AS total_sales,
    COALESCE(pr.avg_rating, 0) AS avg_rating,
    tp.top_product,
    bs.best_store
FROM 
    provincial_stores ps
LEFT JOIN 
    provincial_sales psa ON ps.province = psa.province
LEFT JOIN 
    provincial_ratings pr ON ps.province = pr.province
LEFT JOIN 
    top_products tp ON ps.province = tp.province AND tp.rank = 1
LEFT JOIN 
    best_stores bs ON ps.province = bs.province AND bs.rank = 1
ORDER BY 
    psa.total_sales DESC;
