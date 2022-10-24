FROM golang:1.17.8-bullseye as builder

ARG repo=algorand/go-algorand
ARG ref=rel/stable

ADD https://github.com/${repo}/archive/${ref}.tar.gz /tmp/tarball.tar.gz
RUN tar -xzvf /tmp/tarball.tar.gz -C /usr/local/src/
RUN mv /usr/local/src/go-algorand* /usr/local/src/go-algorand

WORKDIR /usr/local/src/go-algorand

RUN ./scripts/configure_dev.sh
RUN ./scripts/buildtools/install_buildtools.sh
RUN make install
RUN mv ~/.algorand /node_install
RUN mv /usr/local/src/go-algorand/installer/genesis /node_install/genesisfiles

# Get binary names from ./cmd and copy binary from /go/bin/ if they exist
RUN for binary in ./cmd/*; do \
        if [ -f /go/bin/$(basename $binary) ]; \
            then cp /go/bin/$(basename $binary) /usr/local/bin/; \
        fi; \
    done

COPY template.json /template.json

RUN mkdir /sandnet/
ARG create_sandnet=false
ARG dev_mode=true

RUN apt-get update && apt-get install -y jq moreutils
RUN if [ "$dev_mode" = false ] && [ "$create_sandnet" = true ]; then jq '.Genesis.DevMode = false'  /template.json | sponge /template.json; fi
RUN if [ "$create_sandnet" = true ]; then goal network create --network sandnet --rootdir /sandnet/ --template /template.json; fi

RUN rm -rf /sandnet/Node/config.json /node_install/config.json /sandnet/Node/kmd-*/kmd_config.json /node_install/kmd-*/kmd_config.json /node_install/genesis.json /node_install/mainnet*

FROM debian:bullseye-slim as final
COPY --from=builder /node_install/ /node_install/
COPY --from=builder /sandnet/ /sandnet/
COPY --from=builder /usr/local/bin/ /usr/local/bin/

ENV ALGORAND_DATA="/data"

ENV ALGOD_TOKEN='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
ENV KMD_TOKEN='aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa'
ENV ENABLE_DEVELOPER_API=true
ENV ARCHIVAL=false
ENV NETWORK='mainnet'

RUN apt-get update
RUN apt-get install -y jq rsync moreutils
COPY start.sh .
CMD /bin/bash start.sh
