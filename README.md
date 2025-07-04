# Candlestick data Project

This project extracts data from the [CoinGeckoAPI](https://www.coingecko.com/en/api) . The architecture includes 2 layers : **Bronze** and **Silver** to ensure  separation between raw and transformed data (ELT).
The technical stack is airflow for orchestration and dbt for the transform layer.
---

## DAG Overview

### `bitcoin_etl`

**Description:**  
Automates daily computation of candlestick data.

- **Steps:** 
- 1. Extract : Extracts raw daily prices for the cryptocurrency **bitcoin** with a granularity of one hour for the previous day.
  2. Load : stores the data into duckDB (**Bronze** layer / table trading_data).
  3. Transform : Compute daily candlestick data (business logic).


- **Run Frequency:** Daily at the end of the day after the market closes **midnight**

---

## Data Architecture

- **Bronze Layer**: Stores raw ingested trading data exactly as received.
- **Silver Layer**: Stores transformed data (includes business logic).

---

## Prerequisites

- [Docker](https://www.docker.com/) installed
- [Docker Compose](https://docs.docker.com/compose/) available

---

## Getting Started

### Step 1: Reset the Environment

Remove existing containers and volumes:

```bash
echo AIRFLOW_UID=1000 > .env
docker compose down --volumes
```
### Step 2: Start the Infrastructure

```bash
docker compose up
```
This will spin up:

- **Airflow**: Handles DAG orchestration and scheduling through its webserver, scheduler, and worker components ( DuckDb is installed on worker).
- **PostgreSQL**: Serves as the Airflow metadata database.
- **Redis**: Acts as the message broker for Celery, which is used by Airflow for task execution in distributed mode.
- ## Accessing the Web Interfaces

### Airflow UI

- **URL**: [http://localhost:8080](http://localhost:8080)
- **Login**:
    - **Username**: `airflow`
    - **Password**: `airflow`

## DAG Activation Workflow

By default, all DAGs are **paused** when Airflow starts. Follow the steps below to run your pipeline in the correct order:

### 1. Activate `candlestick_etl`

- In the **Airflow UI** (`http://localhost:8080`), navigate to the `candlestick_etl` DAG.
- Toggle the switch to **activate** it.
- Wait for the DAG to complete successfully.

Once complete, connect to the worker container:
```bash
# seek the container_id with docker ps
docker exec --user airflow -it [container_id] bash
# connect to the DB
duckdb bitcoin.db
```

You can then inspect:

- The `trading_data` table in the **bronze layer** (raw data)
- The `candlestick` table in the **silver layer** (transformed)

---


