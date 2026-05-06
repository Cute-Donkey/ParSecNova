FROM mcr.microsoft.com/devcontainers/rust:1-1-bookworm

# Abhängigkeiten für Bevy (Grafik-Libraries für den Build-Prozess)
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && apt-get -y install --no-install-recommends libasound2-dev libudev-dev pkg-config libx11-dev libxcursor-dev libxi-dev libxrandr-dev libvulkan-dev libwayland-dev libxkbcommon-dev

USER vscode