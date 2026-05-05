#!/bin/bash
# fix_runtime.sh - Fix .NET runtime for host execution of Godot exports

echo "Fixing .NET runtime for host execution..."

BUILD_DIR="build/linux"
EXECUTABLE="$BUILD_DIR/ParSecNova.x86_64"
DATA_DIR="$BUILD_DIR/data_ParSecNova.x86_64"

if [ ! -f "$EXECUTABLE" ]; then
    echo "Error: Executable not found at $EXECUTABLE"
    exit 1
fi

# Check if data directory exists
if [ ! -d "$DATA_DIR" ]; then
    echo "Warning: Data directory not found at $DATA_DIR"
    echo "This is normal for placeholder builds. For real builds, ensure export included data files."
    exit 0
fi

echo "Found data directory: $DATA_DIR"

# Set up environment variables for .NET/Mono runtime
export LD_LIBRARY_PATH="$DATA_DIR:$DATA_DIR/lib:$BUILD_DIR:$LD_LIBRARY_PATH"
export MONO_PATH="$DATA_DIR:$BUILD_DIR"
export DOTNET_ROOT="$DATA_DIR"

echo "Environment configured:"
echo "  LD_LIBRARY_PATH=$LD_LIBRARY_PATH"
echo "  MONO_PATH=$MONO_PATH"
echo "  DOTNET_ROOT=$DOTNET_ROOT"

# Try to find and use bundled Mono libraries
if [ -f "$BUILD_DIR/ParSecNova.x86_64_assemblies/libmono.so" ]; then
    echo "Found bundled Mono library"
    export LD_PRELOAD="$BUILD_DIR/ParSecNova.x86_64_assemblies/libmono.so:$LD_PRELOAD"
fi

echo "✓ Runtime configuration complete"
