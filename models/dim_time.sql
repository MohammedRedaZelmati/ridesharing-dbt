with times as (

    select distinct
        cast(window_start as time) as time_slot

    from {{ ref('stg_demand_supply') }}

    where window_start is not null

),

final as (

    select

        hour(time_slot) * 100
        + minute(time_slot) as time_key,

        time_slot,

        hour(time_slot) as hour,

        minute(time_slot) as minute,

        case
            when hour(time_slot) between 5 and 11 then 'Morning'
            when hour(time_slot) between 12 and 16 then 'Afternoon'
            when hour(time_slot) between 17 and 21 then 'Evening'
            else 'Night'
        end as time_period

    from times

)

select *
from final