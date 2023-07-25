import airflow
from airflow.providers.google.cloud.operators.dataflow import DataflowStartFlexTemplateOperator
from airflow.providers.google.cloud.transfers.gcs_to_gcs import GCSToGCSOperator

from team_league_etl_dataflow_dag.settings import Settings

settings = Settings()

with airflow.DAG(
        "team_league_etl_dataflow_dag",
        default_args=settings.dag_default_args,
        schedule_interval=None) as dag:
    start_dataflow_flex_template = DataflowStartFlexTemplateOperator(
        task_id="start_dataflow_flex_template",
        project_id=settings.project_id,
        body=settings.team_stats_job_config,
        location=settings.team_stats_job_location
    )

    move_file_to_cold = GCSToGCSOperator(
        task_id="move_file_to_cold",
        source_bucket=settings.team_stats_source_bucket,
        source_object=settings.team_stats_source_object,
        destination_bucket=settings.team_stats_dest_bucket,
        destination_object=settings.team_stats_dest_object,
        move_object=True
    )

    start_dataflow_flex_template >> move_file_to_cold
