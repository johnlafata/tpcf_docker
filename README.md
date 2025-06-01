# Docker Workshop

This repository contains a simple example of a Docker file that extends the Alpine Linux image and uses Bash shell.

## Dockerfile

```dockerfile
# Use Alpine Linux as base image
FROM alpine:latest

# Install bash
RUN apk add --no-cache bash

# Set bash as the default shell
SHELL ["/bin/bash", "-c"]

# Command to run when container starts
CMD ["/bin/bash"]
```

## Usage

Build the Docker image (replace the tag with your repository tag):

```bash
docker build --platform linux/amd64 -t jltestcr.azurecr.io/alpine-bash:latest . 
```

## Run the container locally:

```bash
docker run -it jltestcr.azurecr.io/alpine-bash:latest
```


## run the container on tanzu platform for cloud foundry
user or pipeline must export or set CF_DOCKER_PASSWORD to the registry password before executing `cf push` command
```
docker push jltestcr.azurecr.io/alpine-bash:latest
cf push
```

##  ssh to container and test access to other container 
```
cf ssh tpcf_docker
wget  books_api.apps.agi-explorer.com
```

self-signed cert error?
```
wget --no-check-certificate https://books_api.apps.agi-explorer.com
```

but how to trust self-signed cert?
