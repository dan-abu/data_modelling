-- current_price_by_weekday_loc_dur.sql
WITH unnested_weekday_tariffs AS (
    SELECT * FROM "pricing"."main_intm"."intm_tariffs__unnested_weekday"
),
current_prices AS (
    SELECT
        rule_id
        , location_id
    FROM "pricing"."main_intm"."intm_pricing__filtered_to_crnt_prices"
),
current_prices_by_weekday_loc_dur AS (
    -- joining location data to show the weekdays when a location's rule's current
    -- tariff price applies row by row depending on duration
    SELECT
        cp.location_id
        , uwt.rule_id
        , uwt.applies_on_weekday_id
        , uwt.tariff_price
        , uwt.duration
    FROM current_prices cp 
    LEFT JOIN unnested_weekday_tariffs uwt on uwt.rule_id = cp.rule_id
)
SELECT * FROM current_prices_by_weekday_loc_dur