from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import  BashOperator
from datetime import datetime
import duckdb
from pycoingecko import CoinGeckoAPI
import pandas as pd



def load():
    cg = CoinGeckoAPI()
    data = cg.get_coin_market_chart_by_id(id='bitcoin', vs_currency='eur', days=1)
    prices = data['prices']  # Each entry is [timestamp_in_ms, price]
    # Convert to DataFrame
    df = pd.DataFrame(prices, columns=['timestamp', 'price'])
    # Convert timestamp to datetime
    df['datetime'] = pd.to_datetime(df['timestamp'], unit='ms')
    df = df.drop(columns="timestamp")
    con = duckdb.connect('/opt/airflow/bitcoin.db')
    con.execute("INSERT INTO bronze.trading_data select datetime,price from df")
    con.close()


with DAG(
        dag_id="candlestick_etl",
        start_date=datetime(2025, 6, 30),
        schedule='0 0 * * *',  # Run daily at midnight
        catchup=False
) as dag:

    load_transactions_raw = PythonOperator(
        task_id="load_transactions_raw",
        python_callable=load,
        provide_context=True,
    )


    transform_transactions = BashOperator(
        task_id='transform_transactions',
        bash_command='cd /opt/airflow/dags/bitcoin_candlestick_etl_dbt; dbt run --profiles-dir profiles',
    )

    load_transactions_raw >> transform_transactions
