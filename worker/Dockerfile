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
ENV AIRFLOW_DAG_HOME=$AIRFLOW_HOME/dags
ENV AIRFLOW__DATABASE__SQL_ALCHEMY_CONN=postgresql+psycopg2://airflow:1234@host.docker.internal:5432/airflow_db
ENV AIRFLOW_WORKER_CONFIG_HOME=$AIRFLOW_HOME/worker/config
ENV CONSTRAINT_URL="https://raw.githubusercontent.com/apache/airflow/constraints-${AIRFLOW_VERSION}/constraints-${PYTHON_LIMIT_VERSION_FOR_AIRFLOW_DOWNLOAD}.txt"
ENV PIP_ROOT_USER_ACTION=ignore
ENV AIRFLOW__CORE__DAGS_FOLDER=$AIRFLOW_DAG_HOME
ENV AIRFLOW__CORE__EXECUTOR=KubernetesExecutor
#ENV AIRFLOW__KUBERNETES_EXECUTOR__POD_TEMPLATE_FILE=$AIRFLOW_WORKER_CONFIG_HOME/worker-pod.yaml
ENV AIRFLOW__CORE__LOAD_EXAMPLES=False

# create directory
RUN mkdir -p $USER_HOME \
    $APP_HOME \
    $AIRFLOW_HOME \
    $AIRFLOW_DAG_HOME \
    $SCRIPT_HOME

# download airflow
RUN set -ex \
    && pip install --upgrade pip \
    && pip install --no-cache-dir apache-airflow[kubernetes,ssh,postgres]==${AIRFLOW_VERSION} --constraint "${CONSTRAINT_URL}"

# COPY dag files
COPY /dags $AIRFLOW_DAG_HOME

# COPY Worker Pod Template
#COPY /worker-pod.yaml $AIRFLOW_WORKER_CONFIG_HOME/worker-pod.yaml

# COPY scripts
#COPY /scripts $SCRIPT_HOME
#RUN chmod -R +x $SCRIPT_HOME

#WORKDIR ${AIRFLOW_HOME}
#EXPOSE 8080 8793

#ENTRYPOINT $SCRIPT_HOME/entrypoint.sh