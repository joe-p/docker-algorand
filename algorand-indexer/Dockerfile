FROM golang:1.17.8-bullseye as builder

RUN apt-get update 
RUN apt-get install -y libboost-dev libtool

ARG repo=algorand/indexer
ARG ref=master

# If using a branch name, this will serve as a cache buster if there are new commits
ADD https://api.github.com/repos/${repo}/commits/${ref} /tmp/response

RUN git clone https://github.com/${repo}.git /usr/local/src/indexer
WORKDIR /usr/local/src/indexer

RUN git checkout ${ref}
RUN make

FROM debian:bullseye-slim as final
COPY --from=builder /usr/local/src/indexer/cmd/algorand-indexer/algorand-indexer /usr/local/bin/algorand-indexer

CMD algorand-indexer daemon \
    --loglevel ${LOG_LEVEL} \
    --postgres "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} password=${POSTGRES_USER} dbname=${POSTGRES_DB} sslmode=disable" \
    --algod-net "${ALGOD_HOST}:${ALGOD_PORT}" \
    --algod-token ${ALGOD_TOKEN} \
    --data-dir /data \
    --dev-mode