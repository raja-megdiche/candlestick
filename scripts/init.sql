-- Create schema
CREATE SCHEMA IF NOT EXISTS silver;
CREATE SCHEMA IF NOT EXISTS bronze;

-- Create  tables inside the schemas
CREATE TABLE IF NOT EXISTS bronze.trading_data (
    datetime TIMESTAMP,
    price DOUBLE
);

CREATE TABLE IF NOT EXISTS silver.candlestick (
    daydate date,
    open DOUBLE,
    close DOUBLE,
    low DOUBLE,
    high DOUBLE
);
