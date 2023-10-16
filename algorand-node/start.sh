[ -f /data ] && unlink /data

rsync -a /node_install/ /node/

if [ -z "$NETWORK" ]; then
    echo "Network must be defined!"
    exit 1
elif [[ "$NETWORK" == 'sandnet' ]]; then
    if [ -d /sandnet/Node/ ]; then
        ln -s /sandnet/Node/ /data
        echo ${ALGOD_TOKEN} > /sandnet/Follower/algod.token

        goal node start --datadir /sandnet/Follower
    else
        echo "Sandnet was not created during docker image build process. Please rebuild image with build argument create_sandnet=true"
        exit 1 
    fi
else
    ln -s /node/ /data
    [ -f /node/genesis.json ] || cp /node/genesisfiles/${NETWORK}/genesis.json /node
fi

echo ${ALGOD_TOKEN} > /data/algod.token
[ -f /data/config.json ] || cp /node/config.json.example /data/config.json

jq '.EndpointAddress = "0.0.0.0:4001"' /data/config.json | sponge /data/config.json
jq '.IsIndexerActive = true' /data/config.json | sponge /data/config.json

jq ".EnableDeveloperAPI = ${ENABLE_DEVELOPER_API}" /data/config.json | sponge /data/config.json
jq ".Archival = ${ARCHIVAL}" /data/config.json | sponge /data/config.json

goal node start

cd /data/kmd-*
echo ${KMD_TOKEN} > kmd.token
[ -f kmd_config.json ] || echo '{ "address": "0.0.0.0:4002", "allowed_origins":["*"] }' > kmd_config.json
goal kmd start -t 0

tail -f /data/node.log