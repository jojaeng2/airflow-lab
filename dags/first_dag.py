import pendulum

from airflow.decorators import dag, task

@dag(
    schedule=None,
    start_date=pendulum.datetime(2023, 10, 22, tz="UTC"),
    tags=["example"]
)
def first_dag_by_taskflow_api():

    @task()
    def print_hello():
        print("hello, ")
    
    @task()
    def print_world():
        print("world!")

    print_hello() >> print_world()

first_dag_by_taskflow_api()