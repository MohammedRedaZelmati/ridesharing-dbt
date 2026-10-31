select

    ride_id,
    passenger_id,
    driver_id,

    request_time,
    driver_status_time,

    pickup_longitude,
    pickup_latitude,
    pickup_h3,

    dropoff_longitude,
    dropoff_latitude,
    dropoff_h3,

    driver_longitude,
    driver_latitude,
    driver_h3,

    h3_distance,
    distance_km,
    freshness_seconds,
    freshness_penalty,
    final_score,
    candidate_rank

from {{ source('ridesharing_raw', 'BEST_DRIVER_MATCH') }}