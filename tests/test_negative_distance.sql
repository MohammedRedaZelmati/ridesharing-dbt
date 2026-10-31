select *
from {{ ref('fact_driver_match') }}
where distance_km < 0