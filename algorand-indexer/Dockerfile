FROM golang:1.17.8-bullseye as builder

RUN apt-get update 
RUN apt-get install -y libboost-dev libtool

ARG repo=algorand/indexer
ARG ref=master

ADD https://github.com/${repo}/archive/${ref}.tar.gz /tmp/tarball.tar.gz
RUN tar -xzvf /tmp/tarball.tar.gz -C /usr/local/src/
RUN mv /usr/local/src/indexer* /usr/local/src/indexer

WORKDIR /usr/local/src/indexer

# Build process relies on submodules, so we need to setup git
RUN git init
RUN git checkout -b ${ref}
RUN git remote add origin https://github.com/${repo}
RUN git fetch origin ${ref}
RUN git reset --hard origin/${ref}
RUN make

FROM debian:bullseye-slim as final
COPY --from=builder /usr/local/src/indexer/cmd/algorand-indexer/algorand-indexer /usr/local/bin/algorand-indexer

ENV POSTGRES_HOST=indexer-db
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=algorand
ENV POSTGRES_PASSWORD=algorand
ENV POSTGRES_DB=indexer
ENV ALGOD_HOST=algorand-node
ENV ALGOD_PORT=4001
ENV ALGOD_TOKEN='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
ENV LOG_LEVEL=info

CMD algorand-indexer daemon \
    --loglevel ${LOG_LEVEL} \
    --postgres "host=${POSTGRES_HOST} port=${POSTGRES_PORT} user=${POSTGRES_USER} password=${POSTGRES_USER} dbname=${POSTGRES_DB} sslmode=disable" \
    --algod-net "${ALGOD_HOST}:${ALGOD_PORT}" \
    --algod-token ${ALGOD_TOKEN} \
    --data-dir /data \
    --dev-mode