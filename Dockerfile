#################
## Dockerfile
#################

# base image
FROM python:3.11.5
USER root

# version
ARG AIRFLOW_VERSION=2.7.2
ARG PYTHON_VERSION=3.11.5
ARG PYTHON_LIMIT_VERSION_FOR_AIRFLOW_DOWNLOAD=3.11

# environment
ENV USER_HOME=/home1/irteam
ENV PYTHON_HOME=$USER_HOME/python
ENV SCRIPT_HOME=$USER_HOME/scripts
ENV APP_HOME=$USER_HOME/apps
ENV AIRFLOW_HOME=$APP_HOME/airflow
ENV CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_LIMIT_VERSION_FOR_AIRFLOW_DOWNLOAD}.txt"
ENV PIP_ROOT_USER_ACTION=ignore

# create directory
RUN mkdir -p $USER_HOME \
    $APP_HOME \
    $AIRFLOW_HOME

# download airflow
RUN set -ex \
    && pip install --upgrade pip \
    && pip install mysqlclient --constraint "${CONSTRAINT_URL}" \
    && pip install --no-cache-dir apache-airflow==${AIRFLOW_VERSION} --constraint "${CONSTRAINT_URL}"

# Metadata DB init

# COPY dag files

# COPY scripts


WORKDIR ${AIRFLOW_HOME}
