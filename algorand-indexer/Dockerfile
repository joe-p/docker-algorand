FROM golang:1.17.8-bullseye as builder

RUN apt-get update 
RUN apt-get install -y \
wget \
git \
libtool \
libboost-dev

ARG ref=master
ARG token=

# If using a branch name, this will serve as a cache buster if there are new commits
ADD https://$token@api.github.com/repos/algorand/indexer/commits/${ref} /tmp/response

RUN git clone https://github.com/algorand/indexer.git
WORKDIR indexer

RUN git checkout ${ref}
RUN make

FROM debian:bullseye-slim as final
COPY --from=builder /go/indexer/cmd/algorand-indexer/algorand-indexer /usr/local/bin/algorand-indexer

ENV LOG_LEVEL=info

ENV POSTGRES_HOST=indexer-db
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=algorand
ENV POSTGRES_PASSWORD=algorand
ENV POSTGRES_DB=indexer

ENV ALGOD_HOST=algorand-node
ENV ALGOD_PORT=8080
ENV ALGOD_TOKEN='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

CMD algorand-indexer daemon \
    --loglevel ${LOG_LEVEL} \
    --postgres "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} password=${POSTGRES_USER} dbname=${POSTGRES_DB} sslmode=disable" \
    --algod-net "${ALGOD_HOST}:${ALGOD_PORT}" \
    --algod-token ${ALGOD_TOKEN} \
    --dev-mode  
