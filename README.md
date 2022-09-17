# Algorand Docker

## How To Use

To get started, all you need is a system with Docker and docker-compose installed. If you have those two installed, you can clone this repo and then run `docker-compose build` to build the containers followed by `docker-compose up` to start them. 

### Changing Networks

To change networks, simply change the NETWORK environment variable for `algorand-node` to `sandnet`, `testnet`, `betanet`, or `devnet`.

```yml
      NETWORK: 'sandnet'
```

By default, it is `sandnet`, which is a private network with developer mode enabled (instant blocks). The exposed node contains one wallet with most of the circulation that you can use to fund newly created accounts. 

### Changing Versions

To change versions for indexer or the node, simply modify the ref build arg for the image to the desired Git ref (commit, branch, or tag) you want to checkout before building. By default, `algorand-node` will checkout `rel/stable` to get the latest stable release and `algorand-indexer` will checkout `master` to get the latest release. 

You must run `docker-compose build` after making any changes to the build args. 

If you want to build from the latest commit on a branch (for example, build with new changes to `master` or `rel/stable`). You must run `docker-compose build`. If there are new commits, the image will be built with them included. If there aren't any new changes, the image will be built from the previously cached build.

### Automatic HTTPS

To enable automatic HTTP endpoints on a public domain, uncomment the `caddy` service in [docker-compose.yml](docker-compose.yml) and set `DOMAIN` variable to your domain. By default it will route `algod.DOMAIN` to the algod endpoints and `indexer.DOMAIN` to the indexer endpoints. Further configuration can be done in the [Caddyfile](./Caddyfile). 

**NOTE:** If you are exposing public endpoints ensure your tokens are set properly and only expose KMD if you really need to. In most cases KMD should not be publicly exposed. 

### Fast Catchup

[catchup.sh](./catchup.sh) can be used to perform fast catchup. The script will get the latest catchpoint for the network supplied as the argument to the script. For example, to catchup using the latest testnet catchpoint: `./catchup.sh testnet`

### Persistent Storage

To have a persistent data directory simply mount a directoy to `/node` for the `algorand-node` service in [docker-compose.yml](docker-compose.yml)

### Updating

To update the node, ensure you have a persistent volume mounted to `/node` as mentioned above. Then simply rebuild the image for whatever tag you would like to update to.