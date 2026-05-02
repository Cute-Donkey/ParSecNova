FROM mcr.microsoft.com/devcontainers/dotnet:8.0

USER root

RUN apt-get update && apt-get install -y --no-install-recommends \
    libvulkan1 \
    binutils \
    pkg-config \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
