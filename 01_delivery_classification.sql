WITH classified_orders AS (
    SELECT
        order_id,
        CASE
            WHEN order_status <> 'delivered'
                THEN 'Not delivered'

            WHEN date(order_delivered_customer_date) IS NULL
              OR date(order_estimated_delivery_date) IS NULL
                THEN 'Missing date'

            WHEN date(order_delivered_customer_date)
                 <= date(order_estimated_delivery_date)
                THEN 'On time'

            ELSE 'Late'
        END AS delivery_status
    FROM olist_orders_dataset
)

SELECT
    delivery_status,
    COUNT(*) AS total_orders
FROM classified_orders
GROUP BY delivery_status
ORDER BY total_orders DESC;