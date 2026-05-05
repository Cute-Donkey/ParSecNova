FROM mcr.microsoft.com/devcontainers/dotnet:8.0

USER root

# Install Godot 4 dependencies and Godot itself
RUN apt-get update && apt-get install -y --no-install-recommends \
    libvulkan1 \
    libvulkan-dev \
    libgl1-mesa-dev \
    libglu1-mesa-dev \
    libx11-dev \
    libxcursor-dev \
    libxext-dev \
    libxi-dev \
    libxinerama-dev \
    libxrandr-dev \
    libxrender-dev \
    binutils \
    pkg-config \
    wget \
    unzip \
    libfontconfig1 \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Download and install Godot 4.3 with Mono support (for C#)
RUN wget -O /tmp/godot-linux.x86_64.zip \
    https://github.com/godotengine/godot-builds/releases/download/4.3-stable/Godot_v4.3-stable_mono_linux_x86_64.zip \
    && unzip /tmp/godot-linux.x86_64.zip -d /opt/godot \
    && mv /opt/godot/Godot_v4.3-stable_mono_linux_x86_64 /opt/godot/Godot \
    && chmod +x /opt/godot/Godot \
    && ln -s /opt/godot/Godot /usr/local/bin/godot \
    && rm /tmp/godot-linux.x86_64.zip

# Switch back to vscode user
USER vscode
