#!/bin/bash

echo "🔄 Dev Container Rebuild Script"
echo "================================"

# Container mit "-parsecnova-" im Namen oder Image finden und entfernen
echo "🛑 Finding and stopping containers with '-parsecnova-'..."
CONTAINERS=$(docker ps -a --format "{{.Names}}:{{.Image}}" | grep parsecnova | cut -d: -f1)

if [ -n "$CONTAINERS" ]; then
    echo "📋 Found containers:"
    echo "$CONTAINERS"
    echo ""
    
    for container in $CONTAINERS; do
        echo "🛑 Stopping container: $container"
        docker stop "$container" 2>/dev/null && echo "✅ Stopped: $container" || echo "⚠️  Could not stop: $container"
        
        echo "🗑️  Removing container: $container"
        docker rm "$container" 2>/dev/null && echo "✅ Removed: $container" || echo "⚠️  Could not remove: $container"
        echo ""
    done
else
    echo "⚠️  No containers with '-parsecnova-' found"
fi

# Images mit "-parsecnova-" im Namen finden und entfernen
echo "🗑️  Finding and removing images with '-parsecnova-'..."
IMAGES=$(docker images --format "{{.Repository}}:{{.Tag}}" | grep parsecnova)

if [ -n "$IMAGES" ]; then
    echo "📋 Found images:"
    echo "$IMAGES"
    echo ""
    
    for image in $IMAGES; do
        echo "🗑️  Removing image: $image"
        docker rmi "$image" 2>/dev/null && echo "✅ Removed: $image" || echo "⚠️  Could not remove: $image"
        echo ""
    done
else
    echo "⚠️  No images with '-parsecnova-' found"
fi

echo ""
echo "✅ Dev Container environment cleaned!"
echo "📝 Next step: In Windsurf press Ctrl+Shift+P → 'Dev Containers: Reopen in Container'"
echo "🔨 This will trigger a complete rebuild of the container"
