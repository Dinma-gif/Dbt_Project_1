select
    id as payment_id,
    orderid as order_id,
    paymentmethod as payment_method,
    status,
    -- converts cents to dollars 
    {{ cents_to_dollars("amount") }} as amount,
    cast(created as datetime) as created_at
from {{ source("stripe", "payment") }} {{ limit_data_in_dev("created", 5) }}
