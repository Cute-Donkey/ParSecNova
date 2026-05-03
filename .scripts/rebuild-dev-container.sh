#!/bin/bash

echo "🔄 Dev Container Rebuild Script"
echo "================================"

# Container stoppen und entfernen
echo "🛑 Stopping existing container..."
docker stop codium-devcontainer-parsecnova 2>/dev/null && echo "✅ Container stopped" || echo "⚠️  No running container found"

echo "🗑️  Removing existing container..."
docker rm codium-devcontainer-parsecnova 2>/dev/null && echo "✅ Container removed" || echo "⚠️  No container to remove"

# Image entfernen, damit es neu gebaut wird
echo "🗑️  Removing existing image to force rebuild..."
docker rmi codium-devcontainer-parsecnova:latest 2>/dev/null && echo "✅ Image removed" || echo "⚠️  No image to remove"

echo ""
echo "✅ Dev Container environment cleaned!"
echo "📝 Next step: In Windsurf press Ctrl+Shift+P → 'Dev Containers: Reopen in Container'"
echo "🔨 This will trigger a complete rebuild of the container"
