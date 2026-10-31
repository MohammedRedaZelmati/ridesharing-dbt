with source as (

    select *
    from {{ ref('stg_demand_supply') }}

),

dim_zone as (

    select
        h3_zone_key,
        h3_cell
    from {{ ref('dim_h3_zone') }}

),

dim_date as (

    select
        date_key,
        full_date
    from {{ ref('dim_date') }}

),

dim_time as (

    select
        time_key,
        time_slot
    from {{ ref('dim_time') }}

),

final as (

    select

        md5(
            concat(
                cast(s.h3_cell as varchar),
                '|',
                cast(s.window_start as varchar)
            )
        ) as zone_window_key,

        -- Foreign key -> DIM_H3_ZONE
        z.h3_zone_key,

        -- Foreign key -> DIM_DATE
        d.date_key,

        -- Foreign key -> DIM_TIME
        t.time_key,

        -- Business/source values
        s.h3_cell,
        s.window_start,
        s.window_end,

        -- Measures
        s.location_events,
        s.unique_drivers,
        s.request_count,
        s.unique_passengers,
        s.demand_supply_ratio

    from source s

    left join dim_zone z
        on s.h3_cell = z.h3_cell

    left join dim_date d
        on cast(s.window_start as date) = d.full_date

    left join dim_time t
        on cast(s.window_start as time) = t.time_slot

)

select *
from final