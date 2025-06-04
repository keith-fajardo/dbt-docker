FROM python:3.12.10

WORKDIR /app

COPY requirements.txt /app/requirements.txt

COPY profiles.yml .dbt/profiles.yml

RUN pip3 install -r requirements.txt