#!/bin/bash
set -e

#curl https://raw.githubusercontent.com/smokedsalmonbagel/hothost-client/main/install-client.sh -o install-client.sh && chmod u+x install-client.sh && ./install-client.sh
echo Installing to "$PWD"
read -p "Server base URL:" url
read -p "Update interval in seconds:" interval
read -p "Agent secret:" agentsecret
curl https://raw.githubusercontent.com/smokedsalmonbagel/hothost-client/main/getinfo.sh -o getinfo.sh
chmod u+x getinfo.sh
echo -e "HOTHOST_SERVER_BASE=${url}\nHOTHOST_MONITOR_INTERVAL=${interval}\nHOTHOST_AGENT_SECRET=${agentsecret}" > hhconfig.sh
chmod u+x hhconfig.sh

curl https://raw.githubusercontent.com/smokedsalmonbagel/hothost-client/main/hothost.conf -o  hothost.conf
envsubst < hothost.conf > hothost_deploy.conf
mv hothost_deploy.conf hothost.conf
if ! command -v supervisorctl &> /dev/null
then
    echo "supervisor not found, installing..."
    sudo apt install -y supervisor
fi
sudo mv hothost.conf /etc/supervisor/conf.d/hothost.conf
sudo supervisorctl reload
sudo service supervisor start hothostclient