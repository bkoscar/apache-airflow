🌀 Apache Airflow Dockerfile

This Dockerfile sets up an optimized environment to run Apache Airflow version 2.10.4 using Python 3.11 on a lightweight base image (slim-bookworm). 🚀


### ✨ Key Features:
	•	🐍 Python 3.11: Python version for improved performance and compatibility.
	•	🎛️ Customizable: Allows flexible configurations via ARG and ENV variables.
	•	📦 Slim Base: Uses a minimal Debian-based image to reduce size and improve efficiency.
	•	🔐 Non-root User: Runs Airflow under a dedicated non-root user for enhanced security.
	•	📄 Extensible: Supports the installation of additional Python packages via requirements.txt.
	•	🌍 Timezone Configuration: Preconfigured for America/Mexico_City but easily adjustable.

### 🛠️ Optimizations:
	•	Efficient layer management for reduced image size.
	•	Automatic cleanup of temporary files and package lists.
	•	Modular structure with clear documentation for maintainability.

### 🔧 Default Configuration:
	•	Executor: LocalExecutor 🖥️
	•	Database: PostgreSQL 🎲
	•	Airflow Home: /opt/airflow 📂
	•	Webserver Port: 8080 🌐