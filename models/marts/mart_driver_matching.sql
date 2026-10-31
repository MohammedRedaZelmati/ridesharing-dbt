with fact as (

    select *
    from {{ ref('fact_driver_match') }}

),

dim_driver as (

    select *
    from {{ ref('dim_driver') }}

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

    f.driver_match_key,
    f.ride_id,
    f.passenger_id,

    -- Driver
    f.driver_key,
    d.driver_id,

    -- Zone
    f.h3_zone_key,
    z.h3_cell as pickup_h3,

    -- Date
    f.date_key,
    dt.full_date,
    dt.year,
    dt.month,
    dt.month_name,
    dt.day_of_month,
    dt.day_name,
    dt.day_of_week,
    dt.week_of_year,
    dt.is_weekend,

    -- Time
    f.time_key,
    tm.time_slot,
    tm.hour,
    tm.minute,
    tm.time_period,

    -- Event timestamps
    f.request_time,
    f.driver_status_time,

    -- Matching context
    f.driver_h3,

    -- Measures
    f.h3_distance,
    f.distance_km,
    f.freshness_seconds,
    f.freshness_penalty,
    f.final_score

from fact f

left join dim_driver d
    on f.driver_key = d.driver_key

left join dim_zone z
    on f.h3_zone_key = z.h3_zone_key

left join dim_date dt
    on f.date_key = dt.date_key

left join dim_time tm
    on f.time_key = tm.time_key