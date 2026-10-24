SELECT
    c.customer_state,
    COUNT(*) AS total_orders
FROM olist_orders_dataset AS o

INNER JOIN olist_customers_dataset AS c
    ON o.customer_id = c.customer_id

GROUP BY c.customer_state
ORDER BY total_orders DESC;
