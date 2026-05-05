#!/bin/bash
# build.sh - Automated build script for ParSec Nova
# Usage: ./build.sh [linux|windows|macos]

# Default to linux if no argument provided
TARGET_OS=${1:-linux}

echo "Building ParSec Nova for $TARGET_OS..."

# Create build directory
BUILD_DIR="build/${TARGET_OS}"

# Clean build directory first to avoid conflicts
echo "Cleaning build directory..."
rm -rf "$BUILD_DIR"
mkdir -p "$BUILD_DIR"

# Set Godot executable path
GODOT_EXEC="/opt/godot/Godot/Godot_v4.3-stable_mono_linux.x86_64"

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
if [ "$TARGET_OS" = "linux" ]; then
    echo ""
    echo "Setting up .NET runtime for host execution..."
    
    # Build C# project with correct output structure
    echo "Building C# project with dotnet publish..."
    dotnet publish -c Debug -o build/linux/GodotSharp/Api/Debug/ project.csproj
    
    # Copy GodotSharp folder structure from DevContainer
    echo "Copying GodotSharp folder structure..."
    mkdir -p build/linux/GodotSharp/Mono
    mkdir -p build/linux/GodotSharp/Mono/lib/net6.0
    cp -r /opt/godot/Godot/GodotSharp/Mono/* build/linux/GodotSharp/Mono/ 2>/dev/null || true
    cp -r /opt/godot/Godot/GodotSharp/Api build/linux/GodotSharp/ 2>/dev/null || true
    
    # Copy PCK file from Godot export to build directory
    echo "Copying PCK file from Godot export to build directory..."
    find /workspaces/ParSecNova -name "*.pck" -exec cp {} build/linux/ \;
    
    # Create runtimeconfig.json in correct location
    echo "Creating runtimeconfig.json..."
    cat > build/linux/GodotSharp/Api/Debug/ParSecNova.runtimeconfig.json << 'EOF'
{
  "runtimeOptions": {
    "tfm": "net8.0",
    "framework": {
      "name": "Microsoft.NETCore.App",
      "version": "8.0.26"
    },
    "configProperties": {
      "System.Reflection.Metadata.MetadataUpdater.IsSupported": false
    },
    "rollForward": "LatestMinor"
  }
}
EOF
    
    # Create lowercase DLL copy to avoid case sensitivity issues
    echo "Creating lowercase DLL copy..."
    cp build/linux/GodotSharp/Api/Debug/ParSecNova.dll build/linux/GodotSharp/Api/Debug/parsecnova.dll
    
    # Generate launcher script for host execution
    echo "Generating launcher script..."
    
    # Generate launcher script for host execution
    {
        echo '#!/bin/bash'
        echo '# Launcher script for ParSec Nova with correct host paths'
        echo ''
        echo 'SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"'
        echo 'EXECUTABLE="$SCRIPT_DIR/ParSecNova.x86_64"'
        echo 'PCK_FILE="$SCRIPT_DIR/ParSecNova.pck"'
        echo ''
        echo '# Check if executable exists'
        echo 'if [ ! -f "$EXECUTABLE" ]; then'
        echo '    echo "Error: Executable not found at $EXECUTABLE"'
        echo '    exit 1'
        echo 'fi'
        echo ''
        echo '# Function to check if .NET runtime is available'
        echo 'check_dotnet() {'
        echo '    # First check for Mono (preferred for Godot)'
        echo '    if command -v mono >/dev/null 2>&1; then'
        echo '        echo " Mono runtime found: $(mono --version | head -1)"'
        echo '        # Set up Mono environment for Godot'
        echo '        export MONO_PATH="$(dirname "$EXECUTABLE")"'
        echo '        export MONO_CFG_DIR="/etc/mono"'
        echo '        export LD_LIBRARY_PATH="$(dirname "$EXECUTABLE"):$LD_LIBRARY_PATH"'
        echo '        return 0'
        echo '    fi'
        echo ''
        echo '    # Check PATH for .NET'
        echo '    if command -v dotnet >/dev/null 2>&1; then'
        echo '        echo " .NET runtime found: $(dotnet --version)"'
        echo '        return 0'
        echo '    fi'
        echo ''
        echo '    # Check installed .NET directory'
        echo '    if [ -f "$HOME/.dotnet/dotnet" ]; then'
        echo '        echo " .NET runtime found in ~/.dotnet: $("$HOME/.dotnet/dotnet" --version 2>/dev/null)"'
        echo '        export DOTNET_ROOT="$HOME/.dotnet"'
        echo '        export PATH="$PATH:$HOME/.dotnet"'
        echo '        return 0'
        echo '    fi'
        echo ''
        echo '    return 1'
        echo '}'
        echo ''
        echo '# Function to install Mono runtime'
        echo 'install_mono() {'
        echo '    echo "=== Mono Runtime Installation ==="'
        echo '    echo "This will install Mono runtime (preferred for Godot)"'
        echo '    echo "Continue? (y/N)"'
        echo '    read -r response'
        echo '    if [[ ! "$response" =~ ^[Yy]$ ]]; then'
        echo '        echo "Installation cancelled."'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    echo "Installing Mono runtime..."'
        echo '    # Detect package manager and install Mono'
        echo '    if command -v apt >/dev/null 2>&1; then'
        echo '        echo "Detected Ubuntu/Debian - installing mono-complete..."'
        echo '        sudo apt update'
        echo '        sudo apt install -y mono-complete'
        echo '    elif command -v dnf >/dev/null 2>&1; then'
        echo '        echo "Detected Fedora - installing mono-complete..."'
        echo '        sudo dnf install -y mono-complete'
        echo '    elif command -v pacman >/dev/null 2>&1; then'
        echo '        echo "Detected Arch Linux - installing mono..."'
        echo '        sudo pacman -S --noconfirm mono'
        echo '    else'
        echo '        echo "Error: Unsupported package manager"'
        echo '        echo "Please install Mono manually:"'
        echo '        echo "  Ubuntu/Debian: sudo apt install mono-complete"'
        echo '        echo "  Fedora: sudo dnf install mono-complete"'
        echo '        echo "  Arch: sudo pacman -S mono"'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    echo " Mono Runtime installed successfully!"'
        echo '}'
        echo ''
        echo '# Function to install .NET runtime (fallback)'
        echo 'install_dotnet() {'
        echo '    echo "=== .NET Runtime Installation ==="'
        echo '    echo "This will download and install .NET 9.0 Runtime using official Microsoft installer"'
        echo '    echo "Continue? (y/N)"'
        echo '    read -r response'
        echo '    if [[ ! "$response" =~ ^[Yy]$ ]]; then'
        echo '        echo "Installation cancelled."'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    echo "Downloading Microsoft .NET installer..."'
        echo '    INSTALL_SCRIPT="/tmp/dotnet-install.sh"'
        echo '    DOTNET_URL="https://dot.net/v1/dotnet-install.sh"'
        echo ''
        echo '    # Download installer script'
        echo '    if command -v wget >/dev/null 2>&1; then'
        echo '        wget -O "$INSTALL_SCRIPT" "$DOTNET_URL"'
        echo '    elif command -v curl >/dev/null 2>&1; then'
        echo '        curl -o "$INSTALL_SCRIPT" "$DOTNET_URL"'
        echo '    else'
        echo '        echo "Error: Neither wget nor curl available for download"'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    # Make installer executable'
        echo '    chmod +x "$INSTALL_SCRIPT"'
        echo ''
        echo '    echo "Installing .NET 9.0 Runtime..."'
        echo '    "$INSTALL_SCRIPT" --install-dir "$HOME/.dotnet" --runtime dotnet --channel 9.0'
        echo ''
        echo '    # Cleanup'
        echo '    rm "$INSTALL_SCRIPT"'
        echo ''
        echo '    # Add to PATH'
        echo '    echo "export PATH=\$PATH:$HOME/.dotnet" >> "$HOME/.bashrc"'
        echo '    export PATH="$PATH:$HOME/.dotnet"'
        echo ''
        echo '    echo " .NET Runtime installed successfully!"'
        echo '# Check if executable exists'
        echo 'if [ ! -f "$EXECUTABLE" ]; then'
        echo '    echo "Error: Executable not found at $EXECUTABLE"'
        echo '    exit 1'
        echo 'fi'
        echo ''
        echo '# Function to check if .NET runtime is available'
        echo 'check_dotnet() {'
        echo '    # First check for Mono (preferred for Godot)'
        echo '    if command -v mono >/dev/null 2>&1; then'
        echo '        echo "✓ Mono runtime found: $(mono --version | head -1)"'
        echo '        # Set up Mono environment for Godot'
        echo '        export MONO_PATH="$(dirname "$EXECUTABLE")"'
        echo '        export MONO_CFG_DIR="/etc/mono"'
        echo '        export LD_LIBRARY_PATH="$(dirname "$EXECUTABLE"):$LD_LIBRARY_PATH"'
        echo '        return 0'
        echo '    fi'
        echo ''
        echo '    # Check PATH for .NET'
        echo '    if command -v dotnet >/dev/null 2>&1; then'
        echo '        echo "✓ .NET runtime found: $(dotnet --version)"'
        echo '        return 0'
        echo '    fi'
        echo ''
        echo '    # Check installed .NET directory'
        echo '    if [ -f "$HOME/.dotnet/dotnet" ]; then'
        echo '        echo "✓ .NET runtime found in ~/.dotnet: $("$HOME/.dotnet/dotnet" --version 2>/dev/null)"'
        echo '        export DOTNET_ROOT="$HOME/.dotnet"'
        echo '        export PATH="$PATH:$HOME/.dotnet"'
        echo '        return 0'
        echo '    fi'
        echo ''
        echo '    return 1'
        echo '}'
        echo ''
        echo '# Function to install Mono runtime'
        echo 'install_mono() {'
        echo '    echo "=== Mono Runtime Installation ==="'
        echo '    echo "This will install Mono runtime (preferred for Godot)"'
        echo '    echo "Continue? (y/N)"'
        echo '    read -r response'
        echo '    if [[ ! "$response" =~ ^[Yy]$ ]]; then'
        echo '        echo "Installation cancelled."'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    echo "Installing Mono runtime..."'
        echo '    # Detect package manager and install Mono'
        echo '    if command -v apt >/dev/null 2>&1; then'
        echo '        echo "Detected Ubuntu/Debian - installing mono-complete..."'
        echo '        sudo apt update'
        echo '        sudo apt install -y mono-complete'
        echo '    elif command -v dnf >/dev/null 2>&1; then'
        echo '        echo "Detected Fedora - installing mono-complete..."'
        echo '        sudo dnf install -y mono-complete'
        echo '    elif command -v pacman >/dev/null 2>&1; then'
        echo '        echo "Detected Arch Linux - installing mono..."'
        echo '        sudo pacman -S --noconfirm mono'
        echo '    else'
        echo '        echo "Error: Unsupported package manager"'
        echo '        echo "Please install Mono manually:"'
        echo '        echo "  Ubuntu/Debian: sudo apt install mono-complete"'
        echo '        echo "  Fedora: sudo dnf install mono-complete"'
        echo '        echo "  Arch: sudo pacman -S mono"'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    echo "✓ Mono Runtime installed successfully!"'
        echo '}'
        echo ''
        echo '# Function to install .NET runtime (fallback)'
        echo 'install_dotnet() {'
        echo '    echo "=== .NET Runtime Installation ==="'
        echo '    echo "This will download and install .NET 9.0 Runtime using official Microsoft installer"'
        echo '    echo "Continue? (y/N)"'
        echo '    read -r response'
        echo '    if [[ ! "$response" =~ ^[Yy]$ ]]; then'
        echo '        echo "Installation cancelled."'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    echo "Downloading Microsoft .NET installer..."'
        echo '    INSTALL_SCRIPT="/tmp/dotnet-install.sh"'
        echo '    DOTNET_URL="https://dot.net/v1/dotnet-install.sh"'
        echo ''
        echo '    # Download installer script'
        echo '    if command -v wget >/dev/null 2>&1; then'
        echo '        wget -O "$INSTALL_SCRIPT" "$DOTNET_URL"'
        echo '    elif command -v curl >/dev/null 2>&1; then'
        echo '        curl -o "$INSTALL_SCRIPT" "$DOTNET_URL"'
        echo '    else'
        echo '        echo "Error: Neither wget nor curl available for download"'
        echo '        exit 1'
        echo '    fi'
        echo ''
        echo '    # Make installer executable'
        echo '    chmod +x "$INSTALL_SCRIPT"'
        echo ''
        echo '    echo "Installing .NET 9.0 Runtime..."'
        echo '    "$INSTALL_SCRIPT" --install-dir "$HOME/.dotnet" --runtime dotnet --channel 9.0'
        echo ''
        echo '    # Cleanup'
        echo '    rm "$INSTALL_SCRIPT"'
        echo ''
        echo '    # Add to PATH'
        echo '    echo "export PATH=\$PATH:$HOME/.dotnet" >> "$HOME/.bashrc"'
        echo '    export PATH="$PATH:$HOME/.dotnet"'
        echo ''
        echo '    echo "✓ .NET Runtime installed successfully!"'
        echo '    echo "Please restart your terminal or run: source ~/.bashrc"'
        echo '}'
        echo ''
        echo '# Check .NET runtime availability'
        echo 'if ! check_dotnet; then'
        echo '    echo "=== .NET Runtime Required ==="'
        echo '    echo "ParSec Nova requires .NET or Mono runtime to run."'
        echo '    echo "Neither .NET nor Mono was found on your system."'
        echo '    echo ""'
        echo '    echo "Options:"'
        echo '    echo "1) Install Mono runtime automatically (recommended for Godot)"'
        echo '    echo "2) Install .NET 9.0 Runtime manually"'
        echo '    echo "3) Exit"'
        echo '    echo ""'
        echo '    echo -n "Choose option [1-3]: "'
        echo '    read -r choice'
        echo ''
        echo '    case $choice in'
        echo '        1)'
        echo '            install_mono'
        echo '            if ! check_dotnet; then'
        echo '                echo "Installation failed. Please install manually."'
        echo '                exit 1'
        echo '            fi'
        echo '            ;;'
        echo '        2)'
        echo '            echo "Please install .NET 9.0 Runtime:"'
        echo '            echo "  Download from: https://dotnet.microsoft.com/download"'
        echo '            echo "  Or use: curl -sSL https://dot.net/v1/dotnet-install.sh | bash -s -- --channel 9.0"'
        echo '            exit 1'
        echo '            ;;'
        echo '        3)'
        echo '            echo "Exiting..."'
        echo '            exit 0'
        echo '            ;;'
        echo '        *)'
        echo '            echo "Invalid choice. Exiting..."'
        echo '            exit 1'
        echo '            ;;'
        echo '    esac'
        echo 'fi'
        echo ''
        echo '# Set up environment for .NET/Mono'
        echo 'if command -v dotnet >/dev/null 2>&1; then'
        echo '    export DOTNET_ROOT="$(dirname "$(which dotnet)")/.."'
        echo 'fi'
        echo ''
        echo 'echo "Starting ParSec Nova..."'
        echo 'echo "Executable: $EXECUTABLE"'
        echo 'if [ -f "$PCK_FILE" ]; then'
        echo '    echo "PCK file: $PCK_FILE"'
        echo 'fi'
        echo 'echo ""'
        echo ''
        echo '# Run the executable'
        echo 'if [ -f "$EXECUTABLE" ]; then'
        echo '    # Check if this is a Mono build by looking for .NET files'
        echo '    if [ -f "GodotSharp/Mono/ParSecNova.dll" ] && [ -f "ParSecNova.pck" ]; then'
        echo '        # Use Mono engine directly with PCK file'
        echo '        MONO_ENGINE="$(dirname "$EXECUTABLE")/GodotMono.x86_64"'
        echo '        if [ -f "$MONO_ENGINE" ]; then'
        echo '            exec "$MONO_ENGINE" --main-pack "ParSecNova.pck" --verbose "$@"'
        echo '        else'
        echo '            echo "Warning: Mono engine not found, falling back to standard executable"'
        echo '            exec "$EXECUTABLE" --verbose "$@"'
        echo '        fi'
        echo '    else'
        echo '        exec "$EXECUTABLE" --verbose "$@"'
        echo '    fi'
        echo 'else'
        echo '    echo "Error: Executable not found at $EXECUTABLE"'
        echo '    exit 1'
        echo 'fi'
    } > "${BUILD_DIR}/run.sh"

    # Make launcher script executable
    chmod +x "${BUILD_DIR}/run.sh"
    
    echo "✓ Launcher script generated: ${BUILD_DIR}/run.sh"
fi
