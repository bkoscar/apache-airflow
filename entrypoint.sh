#!/bin/bash
set -e

# Enable strict error handling. If any command exits with a non-zero status, the script will terminate immediately.

# Set environment variables for the admin user creation.
# If variables are not provided, default values are used.
AIRFLOW_USERNAME="${AIRFLOW_USERNAME:-admin}"     # Default admin username
AIRFLOW_PASSWORD="${AIRFLOW_PASSWORD:-admin}"     # Default admin password
AIRFLOW_FIRSTNAME="${AIRFLOW_FIRSTNAME:-Admin}"   # Default first name for the admin user
AIRFLOW_LASTNAME="${AIRFLOW_LASTNAME:-User}"      # Default last name for the admin user
AIRFLOW_EMAIL="${AIRFLOW_EMAIL:-admin@example.com}" # Default email for the admin user

# Initialize the Airflow database.
airflow db init

# Apply database migrations to ensure schema consistency.
airflow db migrate

# Check if the admin user already exists. If not, create it.
if ! airflow users list | grep -q "${AIRFLOW_USERNAME}"; then
    # Create a new admin user using the predefined environment variables.
    airflow users create \
        --username "${AIRFLOW_USERNAME}" \
        --password "${AIRFLOW_PASSWORD}" \
        --firstname "${AIRFLOW_FIRSTNAME}" \
        --lastname "${AIRFLOW_LASTNAME}" \
        --role Admin \  # Assign the Admin role to the new user.
        --email "${AIRFLOW_EMAIL}"
fi

# Start the Airflow scheduler in the background.
airflow scheduler &

# Start the Airflow webserver in the foreground (blocking call).
exec airflow webserver