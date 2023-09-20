#!/bin/bash

# Get the OS and ARCH
OS=$(uname -s)
ARCH=$(uname -m)

# Get the latest version of node-exporter
VERSION=$(curl -s https://api.github.com/repos/prometheus/node_exporter/releases/latest | jq -r '.tag_name')

# Download node-exporter
wget https://github.com/prometheus/node_exporter/releases/download/v${VERSION}/node_exporter-${VERSION}.${OS}-${ARCH}.tar.gz

# Extract node-exporter
tar -xzvf node_exporter-${VERSION}.${OS}-${ARCH}.tar.gz

# Move node-exporter to the /usr/bin directory
mv node_exporter-${VERSION}.${OS}-${ARCH}/node_exporter /usr/bin

# Make node-exporter executable
chmod +x /usr/bin/node_exporter

# Create a systemd service file for node-exporter
cat << EOF > /etc/systemd/system/node_exporter.service
[Unit]
Description=Node Exporter
After=network.target

[Service]
Type=simple
ExecStart=/usr/bin/node_exporter

[Install]
WantedBy=multi-user.target
EOF

# Reload the systemd daemon
systemctl daemon-reload

# Start and enable the node-exporter service
systemctl start node_exporter
systemctl enable node_exporter
