{{ config(materialized='table') }}


WITH raw AS (

   select
   DATE_TRUNC('day', datetime) AS daydate,
   price from {{source('bronze','trading_data')}}
),
grouped AS (
    SELECT
        daydate,
        FIRST(price) AS open,
        LAST(price) AS close,
        MIN(price) AS low,
        MAX(price) AS high
    FROM raw
    GROUP BY 1
)
SELECT * FROM grouped