-- base_pricing__prices.sql

SELECT
    price_id
    , rule_id
    , location_id
    -- explicity labelling created_at as pricing_created_at
    , created_at as pricing_created_at
    -- explicityly labelling deleted_at as pricing_deleted_at
    , deleted_at as pricing_deleted_at
FROM {{ source('pricing', 'prices')}}