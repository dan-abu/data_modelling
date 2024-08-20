
  
    
    

    create  table
      "pricing"."main_mart"."historical_1hr_prices_by_loc__dbt_tmp"
  
    as (
      -- historical_1hr_prices_by_loc.sql
WITH one_hr_session AS (
    -- including only 1 hour parking sessions
    SELECT
        *
    FROM "pricing"."main_intm"."intm_tariffs__converted_to_duration"
    WHERE duration == '1 hours'
),
prices AS (
    SELECT
        location_id
        , rule_id
        , pricing_created_at
    FROM "pricing"."main_base"."base_pricing__prices"
),
historical_one_hr_prices_by_loc AS (
    SELECT
        p.location_id
        , p.rule_id
        , ohs.tariff_price
        , ohs.tariff_created_at
        , p.pricing_created_at
    FROM prices p
    LEFT JOIN one_hr_session ohs ON ohs.rule_id = p.rule_id
)
SELECT * FROM historical_one_hr_prices_by_loc
    );
  
  