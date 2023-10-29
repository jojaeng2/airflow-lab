import os, pendulum

from airflow import DAG
from airflow.decorators import dag, task
from airflow.providers.cncf.kubernetes.operators.pod import KubernetesPodOperator
from kubernetes import client
from kubernetes.client import V1EnvVar, V1PodSecurityContext, V1SecurityContext, models as k8s
from airflow.operators.empty import EmptyOperator
from datetime import datetime, timedelta 

## 배치 app name
TASK_NAME="test_kubernetes_operator"

@dag(
    schedule=None,
    tags=["kubenetes"],
    start_date=pendulum.datetime(2023, 10, 22, tz="UTC"),
    catchup=False,
    doc_md=
    """
    DAG 설명

    """,
)
def k8s_oper_dag():

    start = EmptyOperator(task_id="task_start")

    k = KubernetesPodOperator(
        name="hello-dry-run",
        image="debian",
        cmds=["bash", "-cx"],
        arguments=["echo", "10"],
        labels={"foo": "bar"},
        task_id="dry_run_demo",
    )

    k.dry_run()
    start >> k

k8s_oper_dag()


