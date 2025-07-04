#!/bin/bash

duckdb bitcoin.db

# Run the SQL file using DuckDB
duckdb "bitcoin.db" < "scripts/init.sql"


chmod 777 bitcoin.db


