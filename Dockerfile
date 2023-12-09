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
ENV CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_LIMIT_VERSION_FOR_AIRFLOW_DOWNLOAD}.txt"
ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:1234@host.docker.internal:5432/airflow_db
ENV AIRFLOW__CORE__LOAD_EXAMPLES=false
ENV AIRFLOW__WEBSERVER__SHOW_TRIGGER_FORM_IF_NO_PARAMS=True
ENV AIRFLOW__WEBSERVER__DEFAULT_UI_TIMEZONE=Asia/Seoul
ENV AIRFLOW__CORE__DEFAULT_TIMEZONE=Asia/Seoul


ENV AIRFLOW_HOME=$APP_HOME/airflow
ENV AIRFLOW_DAG_HOME=$APP_HOME/terra/git-sync/dags
# ENV AIRFLOW_DAG_HOME=$AIRFLOW_HOME/dags

# ENV AIRFLOW_PLUGINS_HOME=$APP_HOME/terra/git-sync/dags/utils
# ENV AIRFLOW__CORE__DAGS_FOLDER=/home1/irteam/apps/terra/git-sync/terra-infras/kubernetes/airflow/dags
ENV AIRFLOW__CORE__DAGS_FOLDER=$AIRFLOW_DAG_HOME

# ENV AIRFLOW__CORE__PLUGINS_FOLDER=$AIRFLOW_PLUGINS_HOME
# ENV AIRFLOW__CORE__PLUGINS_FOLDER=/home1/irteam/apps/terra/git-sync/terra-infras/kubernetes/airflow

# create directory
RUN mkdir -p $USER_HOME \
    $APP_HOME \
    $AIRFLOW_HOME \
    AIRFLOW_DAG_HOME \
    AIRFLOW_PLUGINS_HOME \
    $SCRIPT_HOME

# download airflow
RUN set -ex \
    && pip install --upgrade pip \
    && pip install --no-cache-dir apache-airflow[postgres,kubernetes,ssh,celery,rabbitmq]==${AIRFLOW_VERSION} --constraint "${CONSTRAINT_URL}"

# Metadata DB init
RUN airflow db migrate

# COPY dag files
# COPY /dags $AIRFLOW_DAG_HOME
# COPY /commons $AIRFLOW_PLUGINS_HOME

# COPY scripts
COPY /scripts $SCRIPT_HOME
RUN chmod -R +x $SCRIPT_HOME

EXPOSE 8080 8793

ENTRYPOINT $SCRIPT_HOME/entrypoint.sh