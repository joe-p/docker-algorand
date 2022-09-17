[ -f /data ] && unlink /data

rsync -a /node_install/ /node/

if [ -z "$NETWORK" ]; then
    echo "Network must be defined!"
    exit 1
elif [[ "$NETWORK" == 'sandnet' ]]; then
    if [ -d /sandnet/Node/ ]; then
        ln -s /sandnet/Node/ /data
        goal node start --datadir /sandnet/Relay --listen 0.0.0.0:8081
    else
        echo "Sandnet was not created during docker image build process. Please rebuild image with build argument create_sandnet=true"
        exit 1 
    fi
else
    ln -s /node/ /data
    [ -f /node/genesis.json ] || cp /node/genesisfiles/${NETWORK}/genesis.json /node
fi

cd /data/kmd-*
echo ${KMD_TOKEN} > kmd.token
[ -f kmd_config.json ] || echo '{ "address": "0.0.0.0:4002", "allowed_origins":["*"] }' > kmd_config.json
goal kmd start -t 0

echo ${ALGOD_TOKEN} > /data/algod.token
[ -f /data/config.json ] || jq '.EnableDeveloperAPI = true | .EndpointAddress = "0.0.0.0:4001"' /node/config.json.example > /data/config.json
goal node start

tail -f /data/node.log