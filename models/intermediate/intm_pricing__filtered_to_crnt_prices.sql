-- intm_pricing__filtered_to_crnt_prices.sql

SELECT
    price_id
    , rule_id
    , location_id
    , pricing_created_at
    , pricing_deleted_at
FROM {{ ref('base_pricing__prices')}}
-- excluding historical prices
WHERE pricing_deleted_at IS NULL