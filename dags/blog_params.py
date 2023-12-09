import pendulum
from airflow.decorators import dag
from airflow.models.param import Param
from airflow.operators.bash import BashOperator
from airflow.operators.empty import EmptyOperator


@dag(
    schedule=None,
    tags=["blog", "pod"],
    start_date=pendulum.datetime(2023, 10, 22, tz="UTC"),
    catchup=False,
    params={
        "REGION": Param("kr", type="string", description="환경변수 region 설정"),
        "JOB_NAME": Param("testJob", type="string", description="실행하고자 하는 batch job 이름"),
    },
    render_template_as_native_obj=True,
)
def test_params():

    start_task = EmptyOperator(task_id="task_start")
    command = "{{dag_run.conf.JOB_NAME}}"
    print(command)
    # if command == ... :
    #     ...

    bash_task = BashOperator(
        task_id="test_params",
        bash_command=command,
    )

    end_task = EmptyOperator(task_id="task_end")

    start_task >> bash_task >> end_task


test_params()
