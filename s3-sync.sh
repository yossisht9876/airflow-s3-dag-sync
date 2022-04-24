#!/bin/sh

while true; do aws s3 sync s3://<bucket-name>/ <airflow-dags-home-folder>/; sleep 60; done
