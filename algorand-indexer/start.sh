algorand-indexer daemon \
    --loglevel ${LOG_LEVEL} \
    --postgres "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} password=${POSTGRES_USER} dbname=${POSTGRES_DB} sslmode=disable" \
    --algod-net "${ALGOD_HOST}:${ALGOD_PORT}" \
    --algod-token ${ALGOD_TOKEN} \
    --dev-mode \
