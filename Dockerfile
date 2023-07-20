FROM gcr.io/dataflow-templates-base/python3-template-launcher-base

ARG WORKDIR=/template
RUN mkdir -p ${WORKDIR}
WORKDIR ${WORKDIR}

COPY . ${WORKDIR}/

# The setup.py file need to be copied at the same level of Dataflow root folder team_league_dataflow_job.
COPY team_league_dataflow_job/setup.py ${WORKDIR}/setup.py

RUN ls -R ${WORKDIR}

ENV PYTHONPATH ${WORKDIR}

ENV REQUIREMENTS_FILE="${WORKDIR}/team_league_dataflow_job/requirements.txt"
ENV FLEX_TEMPLATE_PYTHON_SETUP_FILE="${WORKDIR}/setup.py"
ENV FLEX_TEMPLATE_PYTHON_PY_FILE="${WORKDIR}/team_league_dataflow_job/application/team_league_app.py"

RUN apt-get update \
    && pip install --no-cache-dir --upgrade pip \
    && pip install --no-cache-dir -r $REQUIREMENTS_FILE

# Since we already downloaded all the dependencies, there's no need to rebuild everything.
ENV PIP_NO_DEPS=True

ENTRYPOINT ["/opt/google/dataflow/python_template_launcher"]
