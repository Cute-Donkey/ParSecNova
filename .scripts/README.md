# Development Scripts

This directory contains scripts for development workflow automation.

## Dev Container Scripts

### rebuild-dev-container.sh
Forces a complete rebuild of the Dev Container by removing the existing container and image.

**Usage:**
```bash
./.scripts/rebuild-dev-container.sh
```

**What it does:**
1. Stops the running Dev Container
2. Removes the container
3. Removes the container image
4. Forces Windsurf to rebuild on next "Reopen in Container"

**When to use:**
- After changing Dockerfile
- After changing devcontainer.json
- When container setup is broken

**After running:**
In Windsurf: `Ctrl+Shift+P` → "Dev Containers: Reopen in Container"
