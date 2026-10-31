with zones as (

    select distinct
        h3_cell

    from {{ ref('stg_demand_supply') }}

    where h3_cell is not null
),

final as (

    select
        md5(cast(h3_cell as varchar)) as h3_zone_key,
        h3_cell

    from zones
)

select *
from final