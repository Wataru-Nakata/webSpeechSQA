FROM python:3.10.6-alpine as builder
WORKDIR /usr/src/app
RUN pip install poetry
COPY pyproject.toml poetry.lock ./
RUN poetry export -f requirements.txt > requirements.txt


FROM python:3.10.6-alpine
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
RUN apk update 
RUN apk --no-cache add build-base
RUN apk --no-cache add postgresql-dev
RUN python3 -m pip install psycopg2
WORKDIR /code
COPY --from=builder /usr/src/app/requirements.txt /code/
RUN pip install -r requirements.txt
COPY . /code/
