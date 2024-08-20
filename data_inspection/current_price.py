"""
easily look up the _current_ price that would be charged on different days of the week
for parking sessions of various durations, at a specific location
"""

import duckdb

# sketching out final output
query = """
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
    )
    SELECT
        ee.*
        , p.location_id
    FROM prices p
    LEFT JOIN extended_extract ee ON ee.rule_id = p.rule_id
    WHERE p.deleted_at IS NULL
    ;
"""

conn = duckdb.connect("./pricing.duckdb")
current_price = conn.execute(query).fetchdf()
conn.close()

print(current_price)

# poetry run python3 ./data_inspection/current_price.py