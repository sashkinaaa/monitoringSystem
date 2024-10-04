Vagrant.configure(2) do |config|
config.vm.box = centos/7
config.vm.network private_network, type: dhcp

config.vm.provider virtualbox do |vb|
vb.memory = 1024
vb.cpus = 1
end

# InfluxDB API token and IP addresses
InfluxDB_token = yourToken
server1_ip = 192.168.56.11
server2_ip = 192.168.56.12
server3_ip = 192.168.56.13
server4_ip = 192.168.56.14

# Server 1: Telegraf + Grafana
config.vm.define server1 do |server|
server.vm.hostname = server1
server.vm.network private_network, ip: server1_ip
server.vm.provision shell, path: provision_Telegraf_Grafana.sh
server.vm.synced_folder ., /vagrant, type: rsync,
rsync__exclude: [.vagrant/, .vs/]
server.vm.provision shell, inline: <<-SHELL
echo 'export INFLUX_TOKEN=${InfluxDB_token}' >> /etc/profile
echo 'export SERVER2_IP=${server2_ip}' >> /etc/profile
source /etc/profile
SHELL
end

# Server 2: Telegraf + InfluxDB
config.vm.define server2 do |server|
server.vm.hostname = server2
server.vm.network private_network, ip: server2_ip
server.vm.provision shell, path: provision_Telegraf_InfluxDB.sh
server.vm.synced_folder ., /vagrant, type: rsync,
rsync__exclude: [.vagrant/, .vs/]
server.vm.provision shell, inline: <<-SHELL
echo 'export INFLUX_TOKEN=${InfluxDB_token}' >> /etc/profile
echo 'export SERVER2_IP=${server2_ip}' >> /etc/profile
source /etc/profile
SHELL
end

# Sever 3: Telegraf
config.vm.define server3 do |server|
server.vm.hostname = server3
server.vm.network private_network, ip: server3_ip
server.vm.provision shell, path: provision_Telegraf.sh
server.vm.synced_folder ., /vagrant, type: rsync,
rsync__exclude: [.vagrant/, .vs/]
server.vm.provision shell, inline: <<-SHELL
echo 'export INFLUX_TOKEN=${InfluxDB_token}' >> /etc/profile
echo 'export SERVER2_IP=${server2_ip}' >> /etc/profile
source /etc/profile
SHELL
end

# Server 4: Telegraf
config.vm.define server4 do |server|
server.vm.hostname = server4
server.vm.network private_network, ip: server4_ip
server.vm.provision shell, path: provision_Telegraf.sh
server.vm.synced_folder ., /vagrant, type: rsync,
rsync__exclude: [.vagrant/, .vs/]
server.vm.provision shell, inline: <<-SHELL
echo 'export INFLUX_TOKEN=${InfluxDB_token}' >> /etc/profile
echo 'export SERVER2_IP=${server2_ip}' >> /etc/profile
source /etc/profile
SHELL
end
End
