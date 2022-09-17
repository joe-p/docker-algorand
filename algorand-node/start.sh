[ -f /data ] && unlink /data

if [ -z "$NETWORK" ]; then
    echo "Network must be defined!"
    exit 1
elif [[ "$NETWORK" == 'sandnet' ]]; then
    ln -s /sandnet/Node/ /data
    goal node start --datadir /sandnet/Relay --listen 0.0.0.0:8081
else
    ln -s /public_node/ /data
    [ -f /public_node/genesis.json ] || cp /node/genesisfiles/${NETWORK}/genesis.json /public_node
fi

cd /data/kmd-*
echo ${KMD_TOKEN} > kmd.token
[ -f kmd_config.json ] || echo '{ "address": "0.0.0.0:4002", "allowed_origins":["*"] }' > kmd_config.json
goal kmd start -t 0

echo ${ALGOD_TOKEN} > /data/algod.token
[ -f /data/config.json ] || jq '.EnableDeveloperAPI = true | .EndpointAddress = "0.0.0.0:4001"' /public_node/config.json.example > /data/config.json
goal node start

tail -f /data/node.log