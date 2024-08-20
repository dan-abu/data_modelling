"""
easily look up how the price for a one hour parking session
at a specific location has changed over time
"""
import duckdb

# checking distinct intervals
query1 = """
    WITH unnested AS (
        SELECT
            rule_id
            , created_at AS rule_created_at
            , json_extract(UNNEST(tariffs->'$[*]'), ['is_session', 'monthly', 'applies_from', 'price', 'type', 'applies_to', 'applies_on_days', 'size', 'applies_between', 'proportional', 'interval', 'repeat']) AS tariffs
        FROM rules
    )
    SELECT
        DISTINCT tariffs[11] AS time_intervals
    FROM unnested
    ;
"""
query2= """
    WITH unnested AS (
        SELECT
            rule_id
            , created_at AS rule_created_at
            , json_extract(UNNEST(tariffs->'$[*]'), ['is_session', 'monthly', 'applies_from', 'price', 'type', 'applies_to', 'applies_on_days', 'size', 'applies_between', 'proportional', 'interval', 'repeat']) AS tariffs
        FROM rules
    ),
    extended_extract AS (
        SELECT
            tariffs[4] price
            , rule_created_at as tariff_created_at
            , CASE
                WHEN tariffs[2] == TRUE THEN '1 month'
                ELSE CAST(tariffs[8] AS VARCHAR) || ' ' || tariffs[11]
              END AS duration
            , rule_id
            , UNNEST(tariffs[7]->'$[*]') applies_on_weekday_id 
        FROM unnested
        WHERE tariffs[8] == 1
    )
    SELECT
        ee.price
        , p.created_at pricing_created_at
        , ee.tariff_created_at
        , ee.rule_id
        , p.location_id
    FROM prices p
    INNER JOIN extended_extract ee ON ee.rule_id = p.rule_id
"""

conn = duckdb.connect("./pricing.duckdb")
test = conn.execute(query1).fetchdf()
one_hour_price = conn.execute(query2).fetchdf()
conn.close()

print(test)
print(one_hour_price)

# poetry run python3 ./data_inspection/one_hour_price.py