
  
  create view "pricing"."main_intm"."intm_tariffs__unnested_weekday__dbt_tmp" as (
    -- intm_tariffs__unnested_weekday.sql

SELECT
    rule_id
    , tariff_created_at
    , tariff_price
    , duration
    -- unnesting applies_on_days to show the weekdays when a rule's tariff price
    -- applies row by row depending on duration
    , UNNEST(applies_on_days->>'$[*]') applies_on_weekday_id
FROM "pricing"."main_intm"."intm_tariffs__converted_to_duration"
  );
