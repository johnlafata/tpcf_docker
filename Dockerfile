# Use Alpine Linux as base image
FROM alpine:latest

# Install bash
RUN apk add --no-cache bash

# Set bash as the default shell
SHELL ["/bin/bash", "-c"]

# Command to run when container starts
CMD ["/bin/bash"]