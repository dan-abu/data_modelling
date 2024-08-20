
  
  create view "pricing"."main_base"."base_pricing__rules__dbt_tmp" as (
    -- base_pricing__rules.sql

SELECT
    rule_id
    , created_at rule_created_at
    -- 'tariffs' is a JSON array, here we read it out and unwrap
    -- the contents into one record per element:
    , UNNEST(tariffs->'$[*]') AS tariff
FROM
    "pricing"."main"."rules"
  );
