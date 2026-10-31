select *
from {{ ref('fact_driver_match') }}
where freshness_seconds < 0