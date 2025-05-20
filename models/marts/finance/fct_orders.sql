with
    orders as (
        select 
           *
        from {{ ref("stg_jaffle_shop__orders") }}
),
payments as (
        select 
            *
        from {{ ref("stg_stripe__payments") }}
),
order_payments as (

        select 
            order_id,
            sum( 
                case when status = 'success' then amount end) as amount

        from 
            payments 
        group by order_id
        
),
    

final as (
    select 
        a.order_id,
        customer_id,
        order_date,
        coalesce(b.amount, 0) as amount
        from orders a 
            left join order_payments b on a.order_id = b.order_id
            
)
select 
*
from final
