FROM golang:1.17.8-bullseye as builder

RUN mkdir /algo_bin/

ARG ref=rel/stable
ARG token=

# If using a branch name, this will serve as a cache buster if there are new commits
ADD https://$token@api.github.com/repos/algorand/go-algorand/commits/${ref} /tmp/response

RUN git clone https://github.com/algorand/go-algorand.git
WORKDIR go-algorand

RUN git checkout ${ref}
RUN ./scripts/configure_dev.sh
RUN ./scripts/buildtools/install_buildtools.sh
RUN make install
RUN mv ~/.algorand /public_node

# Get binary names from ./cmd and copy binary from /go/bin/ if they exist
RUN for binary in ./cmd/*; do if [ -f /go/bin/$(basename $binary) ]; then cp /go/bin/$(basename $binary) /algo_bin/; fi; done

COPY template.json /template.json
RUN /algo_bin/goal network create --network sandnet --rootdir /sandnet/ --template /template.json

FROM debian:bullseye-slim as final
COPY --from=builder /public_node/ /public_node/
COPY --from=builder /sandnet/ /sandnet/
COPY --from=builder /algo_bin/ /usr/local/bin/

ENV ALGORAND_DATA="/data"

RUN apt-get update
RUN apt-get install -y jq
COPY start.sh .
CMD /bin/bash start.sh
