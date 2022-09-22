This repository contains docker images and a docker-compose file for easily spinning up an Algorand node and/or indexer. This is an alternative to the official Algorand [sandbox](https://github.com/algorand/sandbox). The main goal is to make node setup as simple as possible for both private and public networks.

# Usage

## Local Development Network

The default [docker-compose.yml](./docker-compose.yml) is configured for setting up a local network with development mode enabled.

To build the docker images and start the network, simply run `docker compose up`

## Public Network Nodes

An example configuration for running a mainnet node can be seen in [mainnet-node.yml](./mainnet-node.yml). The key here is there will be a mounted volumed located at `./node` that keeps persistent data storage across updates and rebuilds. 

## Configuration

See [CONFIGURATION.md](./CONFIGURATION.md) for configuration details

## Fast Catchup

[catchup.sh](./catchup.sh) is a convenience script to easily perform fast catchup on a node. The script only takes one required argument, which must be `mainnet` or `testnet`. For example, to catchup on mainnet: `./catchup.sh mainnet`.

## Updating

To update the software, simply run `docker compose build` to get the latest version of the configured git ref and restart the containers with `docker compose restart`. By default, for algod/kmd this will be the latest `rel/stable` release and for indexer it will be the latest `master` commit.

## Public APIs with HTTPS

[public-indexer.yml](./public-indexer.yml) is an example of a mainnet node and indexer configured with automatic HTTPS

You can configure Caddy to automatically provide HTTPS endpoints for the algod and indexer HTTP APIs. Simply update your domain name under the `caddy` service in `docker-compose.yml`. By default, it will route `algod.$DOMAIN` to the algod HTTP API and `indexer.$DOMAIN` to the indexer HTTP endpoint. A different reverse proxy configuration can be done by changing the [Caddyfile](./Caddyfile). See the [Caddy documentation](https://caddyserver.com/docs/caddyfile) for more information.

If you expose the endpoints publicly via Caddy, it is strongly recommended to change the `ports` to `expose` in `docker-compose.yml`. This will ensure that the API can only be accessed via HTTPS. For example:

```yml
    #ports:
    #  - 4001:4001
    #  - 4002:4002
    expose:
        - 4001
        - 4002
...
    #ports:
    #    - 8980:8980
    expose: 
      - 8980
```

***NOTE:** BE SURE TO UPDATE TOKENS IF API IS PUBLIC

# Sandbox Comparison

 Below is a comparison of the codebase in this repo and sandbox via [scc](https://github.com/boyter/scc)

## Sandbox
```
───────────────────────────────────────────────────────────────────────────────
Language                 Files     Lines   Blanks  Comments     Code Complexity
───────────────────────────────────────────────────────────────────────────────
JSON                        10      2958        0         0     2958          0
Shell                        6      1125      171        77      877        119
Markdown                     4       397      122         0      275          0
Dockerfile                   3       117       25        12       80          6
Go                           2        78       18         2       58          7
YAML                         2       116        6         2      108          0
BASH                         1       717       68        57      592         42
Docker ignore                1         5        0         0        5          0
Python                       1       160        7        11      142          7
gitignore                    1         7        1         1        5          0
───────────────────────────────────────────────────────────────────────────────
Total                       31      5680      418       162     5100        181
───────────────────────────────────────────────────────────────────────────────
```

## This Repo
```
───────────────────────────────────────────────────────────────────────────────
Language                 Files     Lines   Blanks  Comments     Code Complexity
───────────────────────────────────────────────────────────────────────────────
YAML                         3       158        9        17      132          0
Dockerfile                   2        91       21         3       67          9
Markdown                     2       131       31         0      100          0
Shell                        2        39        8         1       30          7
JSON                         1        24        0         0       24          0
gitignore                    1         1        0         0        1          0
───────────────────────────────────────────────────────────────────────────────
Total                       11       444       69        21      354         16
───────────────────────────────────────────────────────────────────────────────
```