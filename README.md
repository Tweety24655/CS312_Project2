# 🎮 Terraform-Powered Minecraft Server on AWS EC2

## 🔍 Project Overview

This project automates the deployment of a Minecraft server using **Terraform** to provision an AWS EC2 instance, and a **Bash script** to configure and start the server. The goal is to make the process hands-free — no manual steps in the AWS Console or via SSH.

## 📦 Technologies Used

- AWS EC2
- Terraform
- Amazon Linux 2 AMI
- Bash
- Minecraft Java Edition
- Systemd (for auto-start)

---

## 📁 Directory Structure

minecraft-automation/
├── terraform/
│ ├── main.tf # Terraform infrastructure setup
│ ├── outputs.tf # Terraform outputs (e.g., public IP)
│ └── setup-minecraft.sh # Provisioner script to install Minecraft
├── README.md # This file
└── demo1.mp4 # First Demo video
└── demo2.mp4 # Second Demo video


---

## 🚀 Quick Start

> 🛑 **Pre-requisites**: AWS CLI configured, Terraform installed, and `.pem` / `.pub` key pair in the Terraform folder

1. **Clone the repo**

```bash
git clone https://github.com/Tweety24655/CS312_Project2.git
cd minecraft-automation/terraform
```

2. **Initialize Terraform**

```bash
terraform init
```

3. **Apply infrastructure**

```bash
terraform apply -auto-approve
```

4. **Wait for EC2 + Minecraft server to spin up**

Once the server is up, Terraform will output something like:
```bash
Outputs:

public_ip = "3.84.195.63"
```

5. **Test with nmap**

Replace <ip> with your EC2 public IP:

```bash
nmap -sV -Pn -p T:25565 <ip>
```

You should see something like:

```bash
25565/tcp open  minecraft Mojang Minecraft Classic
```


