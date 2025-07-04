FROM apache/airflow:2.9.0
USER root
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
    vim \
    && apt-get autoremove -yqq --purge \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*
USER airflow
RUN curl -sSL https://install.python-poetry.org | python3 -
RUN poetry --version
RUN pip install --upgrade pip
WORKDIR /opt/airflow

# Copy project files
COPY --chown=airflow:airflow . .

RUN poetry config virtualenvs.create false \
    && poetry install --no-interaction --no-ansi --no-root

RUN curl https://install.duckdb.org | sh
RUN scripts/init.sh

