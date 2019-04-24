from datetime import datetime
from airflow import DAG
from airflow.operators.dummy_operator import DummyOperator
from airflow.operators.python_operator import PythonOperator
from airflow.operators.bash_operator import BashOperator
from dsutil import NbExecuter

# Define default args
default_args = {
    'owner': 'Alpha',
    'on_failure_callback': lambda context: True
}    

# Define DAG setting
dag = DAG('tut-schedule', description='Schedule a jupyter notebook in airflow ',
          schedule_interval='04 20 * * *',
          start_date=datetime(2017, 10, 19), 
          default_args=default_args,
          catchup=False)

# Define DAG components
dummy_nb = PythonOperator(
    task_id='dummy',
    python_callable=NbExecuter.execute_nb_airflow,
    provide_context=True,
    op_kwargs={'path': '/app/ws-aplha/tutorials/airflow.ipynb'},
    dag=dag
)



# Define dependencies
dummy_nb 
# first_nb >> second_nb # dependencies can be declared by >>