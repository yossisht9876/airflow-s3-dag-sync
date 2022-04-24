#!/bin/sh

while true; do aws s3 sync s3://airflow-stg-s3-log-bucket/airflow_home/dags/ opt/airflow/dags/repo/; sleep 60; done