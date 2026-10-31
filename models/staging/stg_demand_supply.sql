select
    window_start,
    window_end,
    h3_cell,
    location_events,
    unique_drivers,
    request_count,
    unique_passengers,
    demand_supply_ratio

from {{ source('ridesharing_raw', 'H3_DEMAND_SUPPLY_METRICS') }}