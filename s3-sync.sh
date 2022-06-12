#!/bin/bash
while true; do

# checking if new file added to the bucket - if yes - it will upload it the dag bag

account_id=$(aws sts get-caller-identity --query "Account" --output text)
if [ $account_id == "45689" ];
then
  BUCKET_NAME="airflow-prod-dags"
  aws s3 ls "airflow-prod-dags" --recursive | awk '{if ($3 !=0) print "s3://airflow-prod-dags/"$4}' > s3.txt
elif [ $account_id == "716890" ];
then
  BUCKET_NAME="airflow-stg-dags"
  aws s3 ls "airflow-stg-dags" --recursive | awk '{if ($3 !=0) print "s3://airflow-stg-dags/"$4}' > s3.txt
elif [ $account_id == "1630" ];
then
  BUCKET_NAME="airflow-dev-dags"
  aws s3 ls "airflow-dev-dags" --recursive | awk '{if ($3 !=0) print "s3://airflow-dev-dags/"$4}' > s3.txt
fi

while IFS= read -r file; do
    aws s3 sync "$file" "opt/airflow/dags/repo/"
done < s3.txt;
echo sleeping && sleep 60  && rm ./s3.txt;

# checking if dag file was removed from the s3 bucket - compare the dag bag and the s3
# and if there is a diff it will remove it from the dag bag

aws s3 ls "$BUCKET_NAME" --recursive | awk '{if ($3 !=0) print $4}' |  sed 's/.*[/:]//' > s3_diff.txt
ls opt/airflow/dags/repo/ > dag_diff.txt
sort s3_diff.txt dag_diff.txt | uniq -u > diff.txt

while IFS= read -r file; do rm -rf "$file" "opt/airflow/dags/repo/"
done < diff.txt;

echo checking  && rm s3_diff.txt dag_diff.txt diff.txt && sleep 80

done;
