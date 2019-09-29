# Have not used PostgresHook, so that connection properties to you are visible
# Have used fixed startdate
# Have scheduled the workflow for daily
# Task 5 is dependent on the completion of the 1st 4 tasks, and calls a SP to insert the data into star schema
from datetime import timedelta

import airflow
import psycopg2
from airflow import DAG
from airflow.hooks.postgres_hook import PostgresHook
from airflow.operators.python_operator import PythonOperator
from datetime import datetime, timedelta
from psycopg2.extras import execute_values


default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2019, 9, 29),
    'email': ['airflow@example.com'],
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 0}

dag = DAG('edw_veriff', default_args=default_args, description='ETL for EDW', schedule_interval=timedelta(days=1))

def etl(tbl_name):
    src_conn = psycopg2.connect(dbname="veriff", user="postgres", password="root", host="localhost", port=5432)
    dest_conn = psycopg2.connect(dbname="edw", user="postgres", password="root", host="localhost", port=5432)
    src_cursor = src_conn.cursor("serverCursor")
    src_cursor.execute("SELECT * FROM " + tbl_name)
    dest_cursor = dest_conn.cursor()
    dest_cursor.execute("TRUNCATE TABLE " + tbl_name + "_lnd")

    while True:
        records = src_cursor.fetchmany(size=2000)
        if not records:
            break
        execute_values(dest_cursor, "INSERT INTO " + tbl_name + "_lnd VALUES %s", records)
        dest_conn.commit()

    src_cursor.close()
    dest_cursor.close()
    src_conn.close()
    dest_conn.close()

def countries(ds, **kwargs):
    etl("countries")

def verifiers(ds, **kwargs):
    etl("verifiers")

def sessions(ds, **kwargs):
    etl("sessions")

def events(ds, **kwargs):
    etl("events")

def edw(ds, **kwargs):
    dest_conn = psycopg2.connect(dbname="edw", user="postgres", password="root", host="localhost", port=5432)
    dest_cursor = dest_conn.cursor()
    dest_cursor.execute("CALL procedure_edw()")
    dest_cursor.close()
    dest_conn.close()


tbl_name = "countries"
t1 = PythonOperator(
    task_id='countries',
    provide_context=True,
    python_callable=countries,
    dag=dag)

tbl_name = "events"
t2 = PythonOperator(
    task_id='events',
    provide_context=True,
    python_callable=events,
    dag=dag)

tbl_name = "verifiers"
t3 = PythonOperator(
    task_id='verifiers',
    provide_context=True,
    python_callable=verifiers,
    dag=dag)

tbl_name = "sessions"
t4 = PythonOperator(
    task_id='sessions',
    provide_context=True,
    python_callable=sessions,
    dag=dag)

t5 = PythonOperator(
    task_id='edw',
    provide_context=True,
    python_callable=edw,
    dag=dag)

t5 << [t1, t2, t3, t4]
