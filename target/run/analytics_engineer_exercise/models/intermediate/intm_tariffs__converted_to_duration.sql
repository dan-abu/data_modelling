
  
  create view "pricing"."main_intm"."intm_tariffs__converted_to_duration__dbt_tmp" as (
    -- intm_tariffs__converted_to_duration.sql
WITH extracted_json AS (
    SELECT
        rule_id
        , rule_created_at AS tariff_created_at
        -- extracting price from tariff json
        , tariff->>'$.price' AS tariff_price
        , tariff->>'$.size' AS size
        , tariff->>'$.interval' AS interval
        , tariff->>'$.monthly' AS monthly
        -- applies_on_days is an array
        , tariff->>'$.applies_on_days[*]' AS applies_on_days
    FROM "pricing"."main_base"."base_pricing__rules"
)
SELECT
    rule_id
    , tariff_created_at
    , tariff_price
    -- concatenating size and interval to create parking session duration
    -- using CASE statement to convert monthly key into duration value when true
    , CASE
        WHEN monthly == 'TRUE' THEN '1 month'
        ELSE size || ' ' || interval
      END AS duration
    , applies_on_days
FROM extracted_json
  );
