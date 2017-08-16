#!/bin/bash

# Copy from https://raw.githubusercontent.com/gr4per/azureswarm/master/elasticsearch-install.sh
DATACENTER=$1
MASTERVMNAME=$2
ADMINUSER=$3
NODETYPE=$4
echo "datacenter=$1"
echo "masterVmName=$2"
echo "adminUserName=$3"
echo "nodeType=$4"

#install docker
curl https://raw.githubusercontent.com/gr4per/azureswarm/master/vmUpdates/update_docker_engine_to_ce.sh > update_docker_engine_to_ce.sh
sudo chmod +x update_docker_engine_to_ce.sh
./update_docker_engine_to_ce.sh

echo "adding user to docker group" && sudo usermod -aG docker $3
sudo echo "setting nodeType in /etc/docker/daemon.json" && echo '{  "labels": ["nodetype='$NODETYPE'"]}' > daemon.json
sudo mv daemon.json /etc/docker/
sudo echo "restarting docker" && systemctl restart docker

#join swarm cluster
curl https://raw.githubusercontent.com/gr4per/azureswarm/master/vmUpdates/join_swarm.sh > join_swarm.sh
sudo chmod +x join_swarm.sh
./join_swarm.sh $MASTERVMNAME


#setup consul
curl https://raw.githubusercontent.com/gr4per/azureswarm/master/vmUpdates/install_consul_agent.sh > install_consul_agent.sh
sudo chmod +x install_consul_agent.sh
./install_consul_agent.sh $DATACENTER $MASTERVMNAME

#add managed data disk
sudo fdisk /dev/sdc << EOF
n
p



w
EOF

sudo mkfs -t ext4 /dev/sdc1

sudo mkdir -p /elasticsearch/data

sudo mount /dev/sdc1 /elasticsearch/data
