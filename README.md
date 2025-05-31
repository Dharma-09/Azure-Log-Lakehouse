## 🛡️ Azure Secure Audit Log Lakehouse for Multi-Cloud Environments

Build a centralized lakehouse architecture in Azure that ingests, stores, and analyzes audit logs from multiple cloud providers (Azure, AWS, GCP). This project is tailored for enterprises needing unified compliance, threat detection, and security insights across cloud environments.
This project sets up a **secure, serverless data ingestion and analytics pipeline** on Azure using the free tier. It ingests log data via **Event Hub**, processes it with **Azure Functions**, and stores it in **Azure Data Lake Gen2**, with analytics handled by **Synapse Serverless SQL**. Credentials are securely managed with **Azure Key Vault**.

## 🧩 Architecture Overview
![image](https://github.com/user-attachments/assets/aa9b4786-bd69-416e-b2c7-bab3b9ba2230)

## 📦 Components

- **Azure Event Hub** - Scalable log ingestion
- **Azure Function** - Parses and loads data into Data Lake
- **Azure Data Lake Storage Gen2** - Stores raw and processed logs
- **Azure Synapse Workspace** - Serverless SQL analytics engine
- **Azure Key Vault** - Secures SQL admin credentials
- **Azure Log Analytics** - For metrics and diagnostics

## ✅ Features

- Fully automated infrastructure using Terraform
- Uses **free Azure tiers** to stay cost-efficient
- Stores sensitive secrets in **Azure Key Vault**
- Serverless data pipeline: minimal management
- Extendable for ML or dashboard integration

## 🛠️ Prerequisites

- [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/install-azure-cli)
- [Terraform CLI](https://developer.hashicorp.com/terraform/downloads)
- Azure Subscription (Free Tier supported)

## 🚀 Deployment

```bash
# Step 1: Clone this repo
git clone https://github.com/your-org/secure-log-lakehouse.git
cd secure-log-lakehouse

# Step 2: Initialize Terraform
terraform init

# Step 3: Review/Customize variable values (optional)
nano terraform.tfvars

# Step 4: Apply the configuration
terraform apply
```

## 🔐 Managing Secrets

Your synapse_sql_admin and synapse_sql_password are stored securely in Azure Key Vault via:
```hcl
resource "azurerm_key_vault_secret" "sql_admin" { ... }
resource "azurerm_key_vault_secret" "sql_password" { ... }
```

You can retrieve them in Azure Function using Python:
```python
from azure.identity import DefaultAzureCredential
from azure.keyvault.secrets import SecretClient

kv_url = "https://<your-key-vault-name>.vault.azure.net"
credential = DefaultAzureCredential()
client = SecretClient(vault_url=kv_url, credential=credential)

sql_user = client.get_secret("synapse-sql-admin").value
sql_pass = client.get_secret("synapse-sql-password").value
```
📄 License
MIT © 2025 Dharmik

