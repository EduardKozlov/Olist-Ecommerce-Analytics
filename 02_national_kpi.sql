
WITH delivery_status AS (
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
        END AS status
    FROM olist_orders_dataset
)

SELECT
    SUM(CASE WHEN status = 'On time'
        THEN 1 ELSE 0 END) AS on_time_orders,

    SUM(CASE WHEN status IN ('On time', 'Late')
        THEN 1 ELSE 0 END) AS delivered_orders,

    ROUND(
        100.0 *
        SUM(CASE WHEN status = 'On time'
            THEN 1 ELSE 0 END) /
        NULLIF(SUM(CASE WHEN status IN ('On time', 'Late')
            THEN 1 ELSE 0 END), 0),
        2
    ) AS on_time_rate_pct

FROM delivery_status;
