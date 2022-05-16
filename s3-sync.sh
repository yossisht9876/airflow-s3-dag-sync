#!/bin/bash
while true; do
aws s3 ls lusha-airflow-stg-dags --recursive | awk '{if ($3 !=0) print "<Bucket-Name>/"$4}' > s3.txt
while IFS= read -r file; do
    aws s3 cp "$file" "opt/airflow/dags/repo/"
done < s3.txt;
echo sleeping && sleep 60  && rm ./s3.txt;
done;
