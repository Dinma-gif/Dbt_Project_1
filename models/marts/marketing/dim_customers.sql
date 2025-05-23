with
    customers as (
        select distinct customer_id, first_name, last_name
        from {{ ref("stg_jaffle_shop__customers") }}

),

orders as (
        select *
        from {{ ref("fct_orders") }}
    ),
    customer_orders as (
        select
            customer_id,
            min(order_date) as first_order_date,
            max(order_date) as most_recent_order_date,
            count(o.order_id) as number_of_orders,
            sum(amount) as lifetime_value
        from orders o
        group by customer_id
),

    final as (
        select
            customers.customer_id,
            customers.first_name,
            customers.last_name,
            lifetime_value,
            coalesce(customer_orders.first_order_date, null) as first_order_date,
            coalesce(
                customer_orders.most_recent_order_date, null
            ) as most_recent_order_date,
            coalesce(customer_orders.number_of_orders, 0) as number_of_orders
        from customers
        left join customer_orders on customers.customer_id = customer_orders.customer_id
        
    )

select
    customer_id,
    first_name,
    last_name,
    first_order_date,
    most_recent_order_date,
    number_of_orders,
    lifetime_value
from final
