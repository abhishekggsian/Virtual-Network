# 🚀 Azure 3-Tier Architecture Deployment using Terraform

This project demonstrates the provisioning of a basic 3-tier architecture on Microsoft Azure using **Terraform**. It includes:

- A resource group
- A virtual network with frontend and backend subnets
- Two Linux virtual machines (frontend & backend)
- Network security groups with SSH access
- Public IPs for each VM
- An Azure SQL Server and database instance

## 🧱 Architecture Overview

Azure Resource Group: abhi-todo
├── Virtual Network: abhi-vnet21
│ ├── Subnet: frontend-subnet (with NSG allowing port 22)
│ └── Subnet: backend-subnet (with NSG allowing port 22)
├── Network Interfaces:
│ ├── NIC1 -> Frontend VM (with Public IP)
│ └── NIC2 -> Backend VM (with Public IP)
├── Linux Virtual Machines:
│ ├── vm-frontend-abhi
│ └── vm-backend-abhi
├── Azure SQL Server:
│ └── SQL Database: abhi-mssql-db

## 🔧 Prerequisites
- An Azure subscription with permissions to create resources.

## 📁 Project Structure

New Project:ToDo
│
├── main.tf             # All resources declared here
├── variables.tf        # Input variables (optional, if modularized)
├── terraform.tfvars    # Values for input variables (optional)
├── outputs.tf          # Output for frontend and backend public IPs
├── provider.tf         # Azure provider block with authentication
└── README.md           # You're reading it 🙂
🚀 How to Use
Step 1: Clone the Repo
git clone https://github.com/yourusername/project-7.git
cd New Project : ToDo
Step 2: Initialize Terraform
terraform init
Step 3: Review the Execution Plan
terraform plan
Step 4: Apply the Configuration
terraform apply

📤 Outputs
After a successful deployment, Terraform will output:

✅ Frontend VM public IP

✅ Backend VM public IP

These can be used to SSH into the machines.

🔒 Security Notes
The NSG allows SSH access (port 22) from anywhere. In production, this should be limited to specific IPs.

Administrator passwords should be securely stored and never committed to version control.

📚 Learnings
This project is ideal for practicing:

Azure Infrastructure as Code

NSG, Subnet, and VM creation

Working with public IPs

Deploying and accessing Azure SQL via Terraform

