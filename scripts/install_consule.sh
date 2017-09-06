#!/bin/bash

# Copied from https://raw.githubusercontent.com/gr4per/azureswarm/master/vmUpdates/install_consul_agent.sh 
DATACENTER=$1
MASTERVMNAME=$2

echo "datacenter=$1"
echo "masterVmName=$2"
echo "adminUserName=$3"


sudo echo "adding consul agent config"
ADV_ADDR=$(ifconfig | grep -A1 "eth0" | grep -o "inet addr:\S*" | grep -o -e "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
BRIDGE_IP=$(ifconfig | grep -A1 "docker0" | grep -o "inet addr:\S*" | grep -o -e "[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*")
DOCKER_HOST=$(hostname)
DEN=$(sudo docker info | grep "Name:" | grep -o "\S*" | grep -v "Name:")
sudo echo "advertise_address=$ADV_ADDR, hostname=$DOCKER_HOST, docker engine name=$DEN"
sudo mkdir /consul
sudo mkdir /consul/config
sudo mkdir /consul/data
sudo echo "{\"datacenter\": \"$DATACENTER\",\"advertise_addr\": \"$ADV_ADDR\"}" > /consul/config/agent-config.json
HOSTPREFIX=${MASTERVMNAME%?}
NAMESERVER=$(cat /etc/resolv.conf | grep "nameserver" | tail -n1 | grep -o "\S*" | grep -v "nameserver")
echo "using nameserver $NAMESERVER found in /etc/resolv.conf as consul recursor"
sudo docker run -d -v /consul/data:/consul/data -v /consul/config:/consul/config --restart always --env SERVICE_IGNORE=true -p 8300:8300 -p 8301:8301 -p 8301:8301/udp -p 8302:8302 -p 8302:8302/udp -p 8400:8400 -p 8500:8500 -p 53:8600/udp consul agent -join ${HOSTPREFIX}0 -join ${HOSTPREFIX}1 -join ${HOSTPREFIX}2 -ui -data-dir=/consul/data -config-dir=/consul/config -client 0.0.0.0 -node $DOCKER_HOST -recursor $NAMESERVER
sudo echo "starting consul registrator"
sudo docker run -d --net=host --restart always --volume=/var/run/docker.sock:/tmp/docker.sock gliderlabs/registrator -ip $ADV_ADDR consul://localhost:8500
sudo echo "configuring name resolution to include consul"
sudo echo "nameserver $ADV_ADDR" > /etc/resolvconf/resolv.conf.d/head
sudo bash -c "echo \"nameserver $BRIDGE_IP\" > /etc/resolvconf/resolv.conf.d/head"
sudo bash -c "echo \"search service.consul\" > /etc/resolvconf/resolv.conf.d/base"
sudo resolvconf -u
sudo echo "consul setup finished"
