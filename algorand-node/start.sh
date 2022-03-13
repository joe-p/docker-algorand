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

cd /data/kmd-*
echo ${TOKEN} > kmd.token
echo '{ "address": "0.0.0.0:4002", "allowed_origins":["*"] }' > kmd_config.json
goal kmd start -t 0

echo ${TOKEN} > /data/algod.token
jq '.EnableDeveloperAPI = true | .EndpointAddress = "0.0.0.0:4001"' /public_node/config.json.example > /data/config.json
goal node start

tail -f /data/node.log