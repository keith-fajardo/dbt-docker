FROM python:3.12.10

WORKDIR /app

USER root

COPY requirements.txt /app/requirements.txt
RUN pip3 install -r requirements.txt

COPY profiles.yml /root/.dbt/profiles.yml
COPY demo_project /root/projects/demo_project

