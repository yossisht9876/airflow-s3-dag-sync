# airflow-s3-dag-sync
sidecar container for syncing dags from aws s3

the container is syncing every 1 min between s3 and the $airflow-home/dags folder

base on airflow chart:

https://artifacthub.io/packages/helm/airflow-helm/airflow


usege:

``` docker build -t <iamge-name>:<tag> ```


add to the chart value.yaml file under ExtraContainers part:
  * the dags folder must be mounted 

``` extraContainers:
    - name: s3-sync
      image: <iamge-name>:<tag>
      imagePullPolicy: Always
      volumeMounts:
        - mountPath: "/opt/airflow/dags"
          name: dags-data

