with fact as (

    select *
    from {{ ref('fact_zone_demand') }}

),

dim_zone as (

    select *
    from {{ ref('dim_h3_zone') }}

),

dim_date as (

    select *
    from {{ ref('dim_date') }}

),

dim_time as (

    select *
    from {{ ref('dim_time') }}

)

select

    f.zone_window_key,

    -- Geography
    f.h3_zone_key,
    z.h3_cell,

    -- Date
    f.date_key,
    d.full_date,
    d.year,
    d.month,
    d.month_name,
    d.day_of_month,
    d.day_name,
    d.day_of_week,
    d.week_of_year,
    d.is_weekend,

    -- Time
    f.time_key,
    t.time_slot,
    t.hour,
    t.minute,
    t.time_period,

    -- Window
    f.window_start,
    f.window_end,

    -- Measures
    f.location_events,
    f.unique_drivers,
    f.request_count,
    f.unique_passengers,
    f.demand_supply_ratio

from fact f

left join dim_zone z
    on f.h3_zone_key = z.h3_zone_key

left join dim_date d
    on f.date_key = d.date_key

left join dim_time t
    on f.time_key = t.time_key