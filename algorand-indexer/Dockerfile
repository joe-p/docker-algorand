FROM golang:1.17.8-bullseye as builder

RUN apt-get update 
RUN apt-get install -y \
wget \
git \
libtool \
libboost-dev \
ruby

ARG version=''
ARG branch='master'

COPY install.rb .
RUN ruby install.rb

FROM debian:bullseye-slim as final
COPY --from=builder /usr/bin/algorand-indexer /usr/bin/algorand-indexer

ENV LOG_LEVEL=info

ENV POSTGRES_HOST=indexer-db
ENV POSTGRES_PORT=5432
ENV POSTGRES_USER=algorand
ENV POSTGRES_PASSWORD=algorand
ENV POSTGRES_DB=indexer

ENV ALGOD_HOST=algorand-node
ENV ALGOD_PORT=8080
ENV ALGOD_TOKEN='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'

COPY start.sh .
CMD /bin/bash start.sh  
