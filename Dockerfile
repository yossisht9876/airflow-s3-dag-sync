FROM alpine:latest

RUN  apk add py3-pip
RUN apk add bash
RUN apk add --no-cache \
        python3 \
        py3-pip \
    && pip3 install --upgrade pip \
    && pip3 install \
        awscli \
    && rm -rf /var/cache/apk/*

RUN aws --version
RUN wget -q https://storage.googleapis.com/kubernetes-release/release/$(wget -q -O - https://storage.googleapis.com/kubernetes-release/release/stable.txt -O -)/bin/linux/amd64/kubectl -O kubectl
RUN chmod +x ./kubectl && mv ./kubectl /usr/local/bin/kubectl
RUN mkdir -p ~/.kube
COPY s3-sync.sh /s3-sync.sh
RUN chmod +x /s3-sync.sh
CMD ["/s3-sync.sh"]



#ENTRYPOINT [ "/bin/sh", "-c", "aws s3 sync s3://airflow-stg-s3-log-bucket/airflow_home/dags/ /opt/airflow/dags" ]
#ENTRYPOINT ["tail", "-f", "/dev/null"]
