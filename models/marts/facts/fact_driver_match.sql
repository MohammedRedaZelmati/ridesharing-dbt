with source as (

    select *
    from {{ ref('stg_best_driver_match') }}

),

dim_driver as (

    select
        driver_key,
        driver_id
    from {{ ref('dim_driver') }}

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
            cast(s.ride_id as varchar)
        ) as driver_match_key,

        s.ride_id,
        s.passenger_id,

        -- Foreign key -> DIM_DRIVER
        d.driver_key,

        -- Foreign key -> DIM_H3_ZONE
        z.h3_zone_key,

        -- Foreign key -> DIM_DATE
        dt.date_key,

        -- Foreign key -> DIM_TIME
        tm.time_key,

        -- Source/business values
        s.driver_id,
        s.request_time,
        s.driver_status_time,

        s.pickup_h3,
        s.driver_h3,

        -- Measures
        s.h3_distance,
        s.distance_km,
        s.freshness_seconds,
        s.freshness_penalty,
        s.final_score

    from source s

    left join dim_driver d
        on s.driver_id = d.driver_id

    left join dim_zone z
        on s.pickup_h3 = z.h3_cell

    left join dim_date dt
        on cast(s.request_time as date) = dt.full_date

    left join dim_time tm
    on tm.time_slot = cast(
        dateadd(
            minute,
            -mod(date_part(minute, s.request_time), 5),
            date_trunc('minute', s.request_time)
        )
        as time
    )
)

select *
from final