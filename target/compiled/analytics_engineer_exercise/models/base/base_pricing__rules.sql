-- base_pricing__rules.sql

SELECT
    rule_id
    , created_at rule_created_at
    -- 'tariffs' is a JSON array, here we read it out and unwrap
    -- the contents into one record per element:
    , UNNEST(tariffs->'$[*]') AS tariff
FROM
    "pricing"."main"."rules"