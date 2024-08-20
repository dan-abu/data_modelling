import duckdb
import json

conn = duckdb.connect("./pricing.duckdb")

# inspecting the prices table
prices = conn.execute("SELECT * FROM prices;").fetchdf()

# inspecting the rules table
rules = conn.execute("SELECT * FROM rules;").fetchdf()

# spot checking rules
random_rule = rules["tariffs"][25]

# inspecting example tariffs
example_tariff = json.loads(rules["tariffs"][0])[0]
random_monthly_tariff = json.loads(random_rule)[-1]

conn.close()

# get list of unique keys from tariffs
def get_unique_keys(value: list) -> set:
    result = []
    value = json.loads(value)
    for k_v in value:
        for key in k_v.keys():
            result.append(key)
    return result

all_keys = []
for row in rules["tariffs"]:
    keys = get_unique_keys(row)
    all_keys.extend(keys)

all_keys = set(all_keys)

# print(prices)
# print(rules)
# print(random_rule)
# print(example_tariff)
# print(random_monthly_tariff)
print(all_keys)

# You'll need to inspect the types of intervals
# So far it looks like intervals are always measured in hours 
# unless the monthly flag is true

# poetry run python3 ./data_inspection/scratch.py