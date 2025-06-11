#!/bin/bash

set -e  # Exit on any error

# Update system
sudo yum update -y

# Install required tools
sudo yum install -y curl tar

# Download and install Amazon Corretto 21 manually
cd /tmp
curl -LO https://corretto.aws/downloads/latest/amazon-corretto-21-x64-linux-jdk.rpm
sudo yum install -y amazon-corretto-21-x64-linux-jdk.rpm

# Verify Java installation
java -version

# Create Minecraft directory
mkdir -p ~/minecraft
cd ~/minecraft

# Download latest Minecraft server JAR
curl -LO https://piston-data.mojang.com/v1/objects/e6ec2f64e6080b9b5d9b471b291c33cc7f509733/server.jar

# Verify valid JAR
if ! file server.jar | grep -q "Zip archive data"; then
  echo "❌ Downloaded server.jar is not valid. Exiting."
  exit 1
fi

# Accept EULA
echo "eula=true" > eula.txt

# Create systemd service file
sudo tee /etc/systemd/system/minecraft.service > /dev/null <<EOF
[Unit]
Description=Minecraft Server
After=network.target

[Service]
WorkingDirectory=/home/ec2-user/minecraft
ExecStart=/usr/bin/java -Xmx1024M -Xms1024M -jar server.jar nogui
Restart=always
User=ec2-user
Group=ec2-user
StandardOutput=journal
StandardError=journal

[Install]
WantedBy=multi-user.target
EOF

# Enable and start Minecraft server
sudo systemctl daemon-reexec
sudo systemctl daemon-reload
sudo systemctl enable minecraft.service
sudo systemctl start minecraft.service
