![Apache Airflow Logo](https://raw.githubusercontent.com/apache/airflow/19ebcac2395ef9a6b6ded3a2faa29dc960c1e635/docs/apache-airflow/img/logos/wordmark_1.png)

# 🌀 Apache Airflow Dockerfile

This Dockerfile sets up an optimized environment to run **Apache Airflow** version **2.10.4** using **Python 3.11** on a lightweight base image (`slim-bookworm`). 🚀

---

### ✨ **Key Features**:
- 🐍 **Python 3.11**: Python version for improved performance and compatibility.
- 🎛️ **Customizable**: Allows flexible configurations via `ARG` and `ENV` variables.
- 📦 **Slim Base**: Uses a minimal Debian-based image to reduce size and improve efficiency.
- 🔐 **Non-root User**: Runs Airflow under a dedicated non-root user for enhanced security.
- 📄 **Extensible**: Supports the installation of additional Python packages via `requirements.txt`.
- 🌍 **Timezone Configuration**: Preconfigured for `America/Mexico_City` but easily adjustable.

---

### 🛠️ **Optimizations**:
- 🔧 Efficient layer management for reduced image size.
- 🧹 Automatic cleanup of temporary files and package lists.
- 📚 Modular structure with clear documentation for maintainability.

---

### 🔧 **Default Configuration**:
- 🖥️ **Executor**: LocalExecutor
- 🎲 **Database**: PostgreSQL
- 📂 **Airflow Home**: `/opt/airflow`
- 🌐 **Webserver Port**: `8080`

---
### 🔧 **Setup Instructions**
#### 1️⃣ **Clone the Repository**
To get started, clone this repository to your local machine:

```bash
git clone https://github.com/your-username/your-repository.git
cd your-repository
```
---
### 2️⃣ **Create a `.env` File**

Create a `.env` file in the root of the project directory. This file will store the configuration for PostgreSQL, Airflow, and secure settings. Below is a sample template you can use:

```env
# PostgreSQL Configuration
POSTGRES_USER=
POSTGRES_PASSWORD=
POSTGRES_DB=

# Fernet Key for Airflow (Generate a secure key following the steps below)
FERNET_KEY=your-generated-key

# Airflow Admin User Configuration
AIRFLOW_USERNAME=
AIRFLOW_PASSWORD=
AIRFLOW_FIRSTNAME=
AIRFLOW_LASTNAME=
AIRFLOW_EMAIL=
```
---
### 3️⃣ **Generate a Secure Fernet Key**

Airflow requires a Fernet key for encrypting sensitive data in its database. Follow these steps to generate a secure key:

1. Run the following Python script in your terminal:
   ```python
   python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
   ```
2. **Update Your `.env` File**:
   - Open your `.env` file in a text editor.
   - Paste the copied key into the `FERNET_KEY` field, like this:
     ```env
     FERNET_KEY=your-generated-key
     ```
   - Save the `.env` file to apply the changes.
---

### 4️⃣ **Build and Start the Docker Environment**

After updating the `.env` file, you can build and start the Docker environment. Follow these steps:

1. **Build the Docker Images**:
   Run the following command to build the images based on the `Dockerfile` and configurations:
   ```bash
   docker-compose up --build
   ```