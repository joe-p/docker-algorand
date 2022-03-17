# Algorand Sandbox v2

## Improvements 

### docker-compose Configuration

All configuration is done via `docker-compose.yml`. This makes sandbox configuration simple while also allowing it to be very extensible. Users familiar with Docker and docker-compose will be able to pick up sandbox configuration very quickly.

### Simplified Build/Start

The build and start process for the images are much simpler compared to the original sandbox repo. All of the build process is done within the respective Dockerfiles (no external scripts). `algorand-node` leverages `algorand-node/start.sh` as a start script, but it is relatively short and not too complex. 

### GitHub/Docker Hub CI/CD Potential

The only build arg for determine the target version is the Git ref (branch, tag, or commit) to checkout before building. This means it would be very easy to plug these images into a CI/CD process and have public Docker images built upon every release/update. 

### Smaller Images

Thanks to multi-stage builds and debian-slim images, the final images are relatively small in size. 

### Build Caching/Cache Busting

When building the images, Docker will leverage its cache provided there are no new changes. This is true even when you are building off a specific branch. For example, if you are building from `master` and there are new commits since the last image build, the image will be rebuilt with the new commits. Otherwise, docker will leverage the previously cached build to provide a very quick build process.

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