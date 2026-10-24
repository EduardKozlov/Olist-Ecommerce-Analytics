WITH delivery_data AS (
    SELECT
        o.order_id,
        c.customer_state,
        substr(o.order_purchase_timestamp, 1, 7)
            AS order_month,

        CASE
            WHEN o.order_status <> 'delivered'
                THEN 'Not delivered'

            WHEN date(o.order_delivered_customer_date) IS NULL
              OR date(o.order_estimated_delivery_date) IS NULL
                THEN 'Missing date'

            WHEN date(o.order_delivered_customer_date)
                 <= date(o.order_estimated_delivery_date)
                THEN 'On time'

            ELSE 'Late'
        END AS delivery_status

    FROM olist_orders_dataset AS o

    INNER JOIN olist_customers_dataset AS c
        ON o.customer_id = c.customer_id
)

SELECT
    order_month,

    SUM(CASE
        WHEN delivery_status IN ('On time', 'Late')
        THEN 1 ELSE 0
    END) AS delivered_orders,

    SUM(CASE
        WHEN delivery_status = 'Late'
        THEN 1 ELSE 0
    END) AS late_orders,

    ROUND(
        100.0 *
        SUM(CASE
            WHEN delivery_status = 'On time'
            THEN 1 ELSE 0
        END) /
        NULLIF(
            SUM(CASE
                WHEN delivery_status IN ('On time', 'Late')
                THEN 1 ELSE 0
            END),
            0
        ),
        2
    ) AS on_time_rate

FROM delivery_data

WHERE customer_state = 'MG'
  AND order_month IN ('2018-02', '2018-03')

GROUP BY order_month
ORDER BY order_month;
