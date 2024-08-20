-- intm_pricing__tariffs

SELECT
    rule_id
    , rule_created_at as tariff_created_at
    -- here we extract the values of certain keys in each
    -- JSON tariff record (d):
    , tariff->>'$.price' AS tariff_price
    -- 'size' refers to the duration of the parking session:
    , tariff->>'$.size' AS duration
    , tariff->>'$.interval' AS time_interval
    -- 'applies_on_days' is an array
    , tariff->>'$.applies_on_days[*]' AS applies_on_days
    , tariff->>'$.monthly' AS monthly
    {# N.B. not exhaustive, many other fields in 'tariff' #}
FROM
    {{ ref('base_pricing__rules') }}
