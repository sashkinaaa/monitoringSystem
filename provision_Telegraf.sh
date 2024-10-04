#!/bin/bash

# Update system
yum update -y

# Add InfluxData repository for Telegraf
cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
[influxdata]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF

# Install Telegraf
sudo yum install -y Telegraf

# Change permissions to make the file writable
sudo chmod  755 /etc/Telegraf/Telegraf.conf

# Configure Telegraf (edit as needed)
cat <<EOF | sudo tee /etc/Telegraf/Telegraf.conf
# Telegraf configuration file
[global_tags]

[agent]
  interval = 10s
  round_interval = true
  metric_batch_size = 1000
  metric_buffer_limit = 10000
  collection_jitter = 0s
  flush_interval = 10s
  flush_jitter = 0s
  precision = 
  hostname = 
  omit_hostname = false

[[outputs.InfluxDB_v2]]
  urls = [http://192.168.56.12:8086]
  organization = TU
  bucket = COLLECTION
  token = $INFLUX_TOKEN

[[inputs.cpu]]
[[inputs.mem]]
[[inputs.disk]]
[[inputs.net]]
EOF

# Enable and start Telegraf
sudo systemctl enable --now Telegraf

sleep 10

# Check the status of Telegraf service
sudo systemctl status Telegraf.service || { sudo journalctl -xe; exit 1; }

sleep 10
sudo systemctl restart Telegraf
