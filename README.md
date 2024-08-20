# Data modelling exercise

--------------------------------------------------------------------------------------------------------------------------------

This is a task to show case my data modelling skills from a task I was asked to complete.
All models apart from `base_pricing__rules.sql` and `intm_pricing__tariffs.sql` were designed by me.
I made significant changes to the `_base.yml` and `_intm.yml` files.
The rest were previously designed.

The task, database and framework for the task were designed by someone else.
If you would like more details about who designed these things, please get in contact.

The aim was to build some DBT models that fulfil the objectives listed below:
1. allow us to easily look up the _current_ price that would be charged on different days of the week for parking sessions of
various durations, at a specific location
2. allow us to easily look up how the price for a one hour parking session at a specific location has changed over time

--------------------------------------------------------------------------------------------------------------------------------

## Solutions

You will find my solutions in the `models/` directory. More specifically they are the `.sql` and `.yml` files.
They represent my data models and documentation.
Once you've run `poetry install` and `poetry run dbt run`, you can run `poetry run dbt show --select {model.sql}` to get a
preview of my models.

--------------------------------------------------------------------------------------------------------------------------------

## Task Intro

First, defining some terms:

- a parking location is a parking spot or car park where parking is offered
- a parking session is when a parking spot is used for a particular duration, starting at some specific time/date
- a price is a set of rules you can use to calculate the cost of a parking session
- a tariff is member of the set of rules (e.g. 'if parking on a Saturday for 2 hours starting after 4pm, the hourly cost is £4.00')

--------------------------------------------------------------------------------------------------------------------------------

## Getting started

I was asked to use two key technologies:

- DuckDB
- DBT

For this project we're managing everything via `poetry`. You can install it [using these instructions]
(https://python-poetry.org/docs/#installing-with-the-official-installer). If you run `poetry install` you will end up with
`duckdb` and `dbt` installed in a local virtual environment.

--------------------------------------------------------------------------------------------------------------------------------

## What I had to do

There is an example dataset in the warehouse file `pricing.duckdb`. It contains

- two source tables `main.prices` and `main.rules`
- two example, incomplete DBT models `main_base.base_pricing__rules` and `main_intm.intm_pricing__tariffs`

In brief:

- `prices` represents the history of which pricing logic applied at particular times in the past
- `rules` contains the actual pricing rules, in a nested JSON structure

The example DBT models are defined in `models/base/base_pricing__rules.sql` and `models/intm/intm_pricing__tariffs.sql`.
These are there mostly to demonstrate some DuckDB syntax for working with JSON data (since candidates are not expected to
be familiar with this - [here is a reference](https://duckdb.org/docs/extensions/json.html#json-extraction-functions)
in case needed).

There is also `pricing_original.duckdb`, this is the original warehouse file _before_ the example DBT models have been run.

There are many ways to read `duckdb` files. One way is to use Python to read the table into a DataFrame:

```
import duckdb

conn = duckdb.connect("./pricing.duckdb")
prices = conn.execute("SELECT * FROM prices;).fetchdf()
conn.close()
```

--------------------------------------------------------------------------------------------------------------------------------

**ENJOY MY DATA MODELS AND PLAYING AROUND WITH DUCK DB AND DBT**