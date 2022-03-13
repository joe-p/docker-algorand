[ -f /data ] && unlink /data

if [ -z "$NETWORK" ]; then
    echo "Network must be defined!"
    exit 1
elif [[ "$NETWORK" == 'sandnet' ]]; then
    ln -s /sandnet/Node/ /data
    goal node start --datadir /sandnet/Relay --listen 0.0.0.0:8081
else
    ln -s /public_node/ /data
    cp /node/genesisfiles/${NETWORK}/genesis.json /public_node
fi

echo ${TOKEN} > /data/algod.token

cd /data/kmd-*
echo ${TOKEN} > kmd.token
echo '{ "address": "0.0.0.0:7833", "allowed_origins":["*"] }' > kmd_config.json

echo "Starting node..."
goal kmd start -t 0

jq '.EnableDeveloperAPI = true | .EndpointAddress = "0.0.0.0:8080"' /public_node/config.json.example > /data/config.json
goal node start

tail -f /data/node.log