#!/bin/bash
# build.sh - Automated build script for ParSec Nova
# Usage: ./build.sh [linux|windows|macos]

# Default to linux if no argument provided
TARGET_OS=${1:-linux}

echo "Building ParSec Nova for $TARGET_OS..."

# Create build directory
mkdir -p "build/${TARGET_OS}"

# Set Godot executable path
GODOT_EXEC="/opt/godot/Godot/Godot_v4.6.2-stable_mono_linux.x86_64"

# Check if Godot is available
if [ ! -f "$GODOT_EXEC" ]; then
    echo "Warning: Godot is not installed at expected path: $GODOT_EXEC"
    echo "Please install Godot 4.x or run this script in a DevContainer"
    echo "Download Godot from: https://godotengine.org/download"
    echo ""
    echo "For now, creating placeholder files for testing..."
    
    # Create placeholder file for testing
    case $TARGET_OS in
        linux)
            touch build/linux/ParSecNova.x86_64
            ;;
        windows)
            touch build/windows/ParSecNova.exe
            ;;
        macos)
            touch build/macos/ParSecNova.zip
            ;;
        *)
            echo "Error: Invalid OS. Use: linux, windows, or macos"
            exit 1
            ;;
    esac
    
    echo "✓ Placeholder file created for $TARGET_OS"
    echo "Replace this with real build by installing Godot"
    exit 0
fi

echo "✓ Godot found: $($GODOT_EXEC --version)"

# Check if project files exist
if [ ! -f "project.godot" ]; then
    echo "Error: project.godot not found. Are you in the correct directory?"
    exit 1
fi

if [ ! -f "export_presets.cfg" ]; then
    echo "Error: export_presets.cfg not found. Cannot export."
    exit 1
fi

# Build for target OS
case $TARGET_OS in
    linux)
        echo "Building Linux version..."
        $GODOT_EXEC --headless --export-release "Linux/X11" "build/linux/ParSecNova.x86_64"
        if [ $? -eq 0 ]; then
            echo "✓ Linux build successful"
            FILE_PATH="build/linux/ParSecNova.x86_64"
        else
            echo "✗ Linux build failed"
            exit 1
        fi
        ;;
    windows)
        echo "Building Windows version..."
        $GODOT_EXEC --headless --export-release "Windows Desktop" "build/windows/ParSecNova.exe"
        if [ $? -eq 0 ]; then
            echo "✓ Windows build successful"
            FILE_PATH="build/windows/ParSecNova.exe"
        else
            echo "✗ Windows build failed (cross-compilation may not be available)"
            exit 1
        fi
        ;;
    macos)
        echo "Building macOS version..."
        $GODOT_EXEC --headless --export-release "macOS" "build/macos/ParSecNova.zip"
        if [ $? -eq 0 ]; then
            echo "✓ macOS build successful"
            FILE_PATH="build/macos/ParSecNova.zip"
        else
            echo "✗ macOS build failed (cross-compilation may not be available)"
            exit 1
        fi
        ;;
    *)
        echo "Error: Invalid OS. Use: linux, windows, or macos"
        exit 1
        ;;
esac

echo ""
echo "Build completed!"
echo "File created: $FILE_PATH"

# Fix .NET runtime for C# projects
if [ "$TARGET_OS" = "linux" ] && [ -f "fix_runtime.sh" ]; then
    echo ""
    echo "Fixing .NET runtime for host execution..."
    ./fix_runtime.sh
    
    # Generate launcher scripts for host execution
    echo "Generating launcher scripts..."
    
    # Generate enhanced launcher script
    {
        echo '#!/bin/bash'
        echo '# Launcher script for ParSec Nova with correct host paths'
        echo ''
        echo 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"'
        echo 'EXECUTABLE="$SCRIPT_DIR/ParSecNova.x86_64"'
        echo 'DATA_DIR="$SCRIPT_DIR/data_ParSecNova.x86_64"'
        echo ''
        echo 'echo "=== ParSec Nova Launcher ==="'
        echo 'echo "Executable: $EXECUTABLE"'
        echo 'echo "Data directory: $DATA_DIR"'
        echo 'echo ""'
        echo ''
        echo '# Check if executable exists'
        echo 'if [ ! -f "$EXECUTABLE" ]; then'
        echo '    echo "Error: Executable not found at $EXECUTABLE"'
        echo '    exit 1'
        echo 'fi'
        echo ''
        echo '# Create a temporary directory for Mono runtime'
        echo 'TEMP_MONO_DIR="/tmp/parsecnova_mono_$$"'
        echo 'mkdir -p "$TEMP_MONO_DIR"'
        echo ''
        echo '# Copy Mono runtime files to temp directory'
        echo 'if [ -d "$DATA_DIR" ]; then'
        echo '    echo "Setting up Mono runtime in $TEMP_MONO_DIR..."'
        echo '    cp -r "$DATA_DIR"/* "$TEMP_MONO_DIR/" 2>/dev/null || true'
        echo '    '
        echo '    # Set up Mono environment'
        echo '    export MONO_PATH="$TEMP_MONO_DIR:$DATA_DIR:$SCRIPT_DIR"'
        echo '    export MONO_CFG_DIR="$TEMP_MONO_DIR"'
        echo '    export LD_LIBRARY_PATH="$TEMP_MONO_DIR:$TEMP_MONO_DIR/lib:$DATA_DIR:$DATA_DIR/lib:$SCRIPT_DIR:$LD_LIBRARY_PATH"'
        echo '    '
        echo '    # Try to find and use bundled Mono if available'
        echo '    if [ -f "$SCRIPT_DIR/ParSecNova.x86_64_assemblies/libmono.so" ]; then'
        echo '        export LD_PRELOAD="$SCRIPT_DIR/ParSecNova.x86_64_assemblies/libmono.so:$LD_PRELOAD"'
        echo '    fi'
        echo '    '
        echo '    echo "Environment setup complete."'
        echo '    echo "MONO_PATH: $MONO_PATH"'
        echo '    echo "LD_LIBRARY_PATH: $LD_LIBRARY_PATH"'
        echo '    echo ""'
        echo 'else'
        echo '    echo "Warning: Data directory not found at $DATA_DIR"'
        echo 'fi'
        echo ''
        echo '# Run the executable'
        echo 'echo "Starting ParSec Nova..."'
        echo '"$EXECUTABLE" "$@"'
        echo 'EXIT_CODE=$?'
        echo ''
        echo '# Cleanup'
        echo 'rm -rf "$TEMP_MONO_DIR"'
        echo ''
        echo 'exit $EXIT_CODE'
    } > "${BUILD_DIR}/launch.sh"

    # Generate simple wrapper script
    {
        echo '#!/bin/bash'
        echo '# Wrapper script to run ParSec Nova with proper environment for host'
        echo ''
        echo 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"'
        echo 'EXECUTABLE="$SCRIPT_DIR/ParSecNova.x86_64"'
        echo 'DATA_DIR="$SCRIPT_DIR/data_ParSecNova.x86_64"'
        echo ''
        echo '# Check if executable exists'
        echo 'if [ ! -f "$EXECUTABLE" ]; then'
        echo '    echo "Error: Executable not found at $EXECUTABLE"'
        echo '    exit 1'
        echo 'fi'
        echo ''
        echo '# Set up environment variables for .NET/Mono runtime'
        echo 'export LD_LIBRARY_PATH="$DATA_DIR:$DATA_DIR/lib:$SCRIPT_DIR:$LD_LIBRARY_PATH"'
        echo 'export MONO_PATH="$DATA_DIR:$SCRIPT_DIR"'
        echo 'export DOTNET_ROOT="$DATA_DIR"'
        echo ''
        echo 'echo "Starting ParSec Nova with environment:"'
        echo 'echo "  LD_LIBRARY_PATH=$LD_LIBRARY_PATH"'
        echo 'echo "  MONO_PATH=$MONO_PATH"'
        echo 'echo "  DOTNET_ROOT=$DOTNET_ROOT"'
        echo 'echo ""'
        echo ''
        echo '# Run the executable'
        echo 'exec "$EXECUTABLE" "$@"'
    } > "${BUILD_DIR}/run.sh"

    # Make launcher scripts executable
    chmod +x "${BUILD_DIR}/launch.sh" "${BUILD_DIR}/run.sh"
    
    echo "✓ Launcher scripts generated: $BUILD_DIR/launch.sh, $BUILD_DIR/run.sh"
fi
