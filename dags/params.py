import pendulum
import os
from utils.batch_utils import create_scripts
from airflow.decorators import dag, task
from airflow.models.param import Param
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator
from airflow.operators.python import get_current_context


def get_phased_instance():
    # [dev, real]
    return ["dev-instance", "real-instance"]

@dag(
    tags=["batch", "pod"],
    start_date=pendulum.datetime(2023, 10, 22, tz="Asia/Seoul"),
    schedule_interval= '*/5 * * * *' ,
    catchup=False,
    params={
    },
    render_template_as_native_obj=True,
)
def account_personal_info_decryption():

    dag_start = EmptyOperator(task_id="dag_start")

    @task()
    def get_batch_scripts():
        context = get_current_context()
        params = context["params"]
        return create_scripts(instance_list=get_phased_instance(), params=params)
        

    batch_run = BashOperator(
        task_id="account_personal_info_decryption",
        bash_command='{{ task_instance.xcom_pull(task_ids="get_batch_scripts") }}',
    )

    dag_end = EmptyOperator(task_id="dag_end")

    dag_start >> get_batch_scripts() >> batch_run >> dag_end


account_personal_info_decryption()
