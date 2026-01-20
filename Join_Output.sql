SELECT
    p.product_name,
    SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM order_items oi
INNER JOIN products p
    ON oi.product_id = p.product_id
GROUP BY p.product_name;
