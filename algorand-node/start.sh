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

echo ${TOKEN} > /data/kmd.token
echo ${TOKEN} > /data/algod.token

goal kmd start -t 0
goal node start --listen 0.0.0.0:8080

tail -f /data/algod-out.log
