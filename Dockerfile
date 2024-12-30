# syntax=docker/dockerfile:1.4

# Define main build ARGs for flexibility during build
ARG PYTHON_BASE_IMAGE="python:3.11-slim-bookworm"

# Base image
FROM ${PYTHON_BASE_IMAGE} AS airflow-base

# Define build-time arguments
ARG AIRFLOW_VERSION=2.10.4
ARG INSTALL_POSTGRES_CLIENT="true"
ARG INSTALL_MYSQL_CLIENT="false"

# Set environment variables for Airflow
ENV AIRFLOW_HOME="/opt/airflow" \
    AIRFLOW__CORE__LOAD_EXAMPLES="False" \
    AIRFLOW__CORE__SQL_ALCHEMY_CONN="postgresql+psycopg2://airflow:airflow@postgres:5432/airflow" \
    AIRFLOW__CORE__EXECUTOR="LocalExecutor" \
    AIRFLOW__CORE__FERNET_KEY="${AIRFLOW__CORE__FERNET_KEY}" \
    PATH="/home/airflow/.local/bin:${PATH}"

# Switch to root user to install system packages
USER root

# Install system dependencies and essential build tools
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential \
    libssl-dev \
    libffi-dev \
    libpq-dev \
    gcc \
    musl-dev \
    libxml2-dev \
    libxslt1-dev \
    libjpeg-dev \
    zlib1g-dev \
    libldap2-dev \
    libsasl2-dev \
    libyaml-dev \
    curl \
    tzdata \
    ca-certificates && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set timezone to Mexico City
ENV TZ="America/Mexico_City"
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Create required directories for Airflow
RUN mkdir -p /opt/airflow/dags /opt/airflow/logs /opt/airflow/plugins

# Create a non-root user for Airflow and set permissions
RUN useradd -ms /bin/bash airflow --uid 1000 && \
    chown -R airflow:root /opt/airflow

# Switch to airflow user for running Airflow services
USER airflow
WORKDIR /opt/airflow

# Upgrade pip, wheel, and setuptools for compatibility
RUN pip install --upgrade pip wheel setuptools

# Install Airflow with specified version
RUN pip install apache-airflow==${AIRFLOW_VERSION}

# Build ARGs for additional package installation
ARG DOCKER_CONTEXT_FILES="/docker-context-files"
ARG INSTALL_PACKAGES_FROM_CONTEXT="true"

# Copy context files (e.g., requirements.txt) for package installation
COPY --chown=airflow:root ${DOCKER_CONTEXT_FILES} /docker-context-files

# Install Python dependencies if specified
RUN if [ "${INSTALL_PACKAGES_FROM_CONTEXT}" = "true" ]; then \
      pip install --no-cache-dir -r /docker-context-files/requirements.txt && \
      pip install psycopg2-binary; \
    fi

# Copy entrypoint script and set executable permissions
COPY --chown=airflow:root entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Define default entrypoint
ENTRYPOINT ["/entrypoint.sh"]

# Expose the default port for Airflow Webserver
EXPOSE 8080