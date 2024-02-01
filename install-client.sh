#!/bin/bash
set -e

#curl -O https://raw.githubusercontent.com/smokedsalmonbagel/hothost-client/main/install-client.sh && chmod u+x install-client.sh && ./install-client.sh
echo Installing to "$PWD"
read -p "Server base URL:" url
read -p "Update interval in seconds:" interval
read -p "Agent secret:" agentsecret
curl -O https://raw.githubusercontent.com/smokedsalmonbagel/hothost-client/main/getinfo.sh
HH_SERVER_BASE=${url} HH_MONITOR_INTERVAL=${interval} HH_AGENT_SECRET=${agentsecret} envsubst < getinfo.sh > getinfo_deploy.sh
mv getinfo_deploy.sh getinfo.sh 
chmod u+x getinfo.sh
curl -O https://raw.githubusercontent.com/smokedsalmonbagel/hothost-client/main/hothost.conf
envsubst < hothost.conf > hothost_deploy.conf
mv hothost_deploy.conf hothost.conf
if ! command -v supervisorctl &> /dev/null
then
    echo "supervisor not found, installing..."
    apt install -y supervisor
fi
sudo mv hothost.conf /etc/supervisor/conf.d/hothost.conf
sudo supervisorctl reload
sudo service supervisor start hothostclient