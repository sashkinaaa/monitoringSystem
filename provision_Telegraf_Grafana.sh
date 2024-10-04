#!/bin/bash

# Update system
yum update -y

# influxdata-archive_compat.key GPG fingerprint:
#     9D53 9D90 D332 8DC7 D6C8 D3B9 D8FF 8E1F 7DF8 B07E
cat <<EOF | sudo tee /etc/yum.repos.d/influxdata.repo
[influxdata]
name = InfluxData Repository - Stable
baseurl = https://repos.influxdata.com/stable/\$basearch/main
enabled = 1
gpgcheck = 1
gpgkey = https://repos.influxdata.com/influxdata-archive_compat.key
EOF

sudo yum install -y Telegraf

# Change permissions to make the file writable 755
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


# Install Grafana
cat <<EOF | sudo tee /etc/yum.repos.d/Grafana.repo
# nano /etc/yum.repos.d/Grafana.repo
[Grafana]
name=Grafana
baseurl=https://rpm.Grafana.com
repo_gpgcheck=1
enabled=1
gpgcheck=1
gpgkey=https://rpm.Grafana.com/gpg.key
sslverify=1
sslcacert=/etc/pki/tls/certs/ca-bundle.crt
EOF

yum install Grafana -y
systemctl enable --now Grafana-server
