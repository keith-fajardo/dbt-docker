FROM python:3.12.10

WORKDIR /app

USER root

RUN apt-get update && \
    apt-get install -y vim && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY requirements.txt /app/requirements.txt
RUN pip3 install -r requirements.txt

COPY profiles.yml /root/.dbt/profiles.yml
COPY demo_project /root/projects/demo_project

