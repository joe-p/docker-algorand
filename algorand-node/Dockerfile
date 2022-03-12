FROM golang:1.17.8-bullseye as builder

RUN apt-get update 
RUN apt-get install -y \
wget \
curl \
git \ 
ruby

RUN mkdir /algo_bin/

ARG channel=stable
ARG branch=

ADD https://api.github.com/repos/algorand/go-algorand/branches /tmp/branches

COPY install.rb .
RUN ruby install.rb

COPY template.json /template.json
RUN /algo_bin/goal network create --network sandnet --rootdir /sandnet/ --template /template.json

FROM debian:bullseye-slim as final
COPY --from=builder /public_node/ /public_node/
COPY --from=builder /sandnet/ /sandnet/
COPY --from=builder /algo_bin/ /usr/local/bin/

ENV ALGORAND_DATA="/data"

COPY start.sh .
CMD /bin/bash start.sh
