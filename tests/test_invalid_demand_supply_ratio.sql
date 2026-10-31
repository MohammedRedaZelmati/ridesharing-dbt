select *
from {{ ref('fact_zone_demand') }}
where demand_supply_ratio < 0