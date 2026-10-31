with drivers as (

    select distinct
        driver_id

    from {{ ref('stg_best_driver_match') }}

    where driver_id is not null

),

final as (

    select
        md5(cast(driver_id as varchar)) as driver_key,
        driver_id

    from drivers

)

select *
from final