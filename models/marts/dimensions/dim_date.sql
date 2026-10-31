with dates as (

    select distinct
        cast(window_start as date) as full_date

    from {{ ref('stg_demand_supply') }}

    where window_start is not null

),

final as (

    select

        to_number(
            to_char(full_date, 'YYYYMMDD')
        ) as date_key,

        full_date,

        year(full_date) as year,

        month(full_date) as month,

        monthname(full_date) as month_name,

        day(full_date) as day_of_month,

        dayname(full_date) as day_name,

        dayofweekiso(full_date) as day_of_week,

        weekofyear(full_date) as week_of_year,

        case
            when dayofweekiso(full_date) in (6, 7)
                then true
            else false
        end as is_weekend

    from dates

)

select *
from final