#!/bin/bash

# Copy from https://raw.githubusercontent.com/gr4per/azureswarm/master/vmUpdates/join_swarm.sh

MASTERVMNAME=$1

echo "masterVmName=$1"

JOINTOKEN=$(curl $MASTERVMNAME:8888/worker-token.txt)
echo "joining swarm with token $JOINTOKEN" && sudo docker swarm join --token $JOINTOKEN $MASTERVMNAME:2377
sudo echo "swarm worker init finished"
