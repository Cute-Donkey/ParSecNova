#!/bin/bash
# ParSec Nova Launcher - Option 4: System .NET Runtime Nutzung
# Prüft ob .NET Runtime vorhanden und startet entsprechend

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXECUTABLE="$SCRIPT_DIR/ParSecNova.x86_64"

echo "=== ParSec Nova Launcher ==="
echo "Executable: $EXECUTABLE"
echo ""

# Prüfen ob Executable existiert
if [ ! -f "$EXECUTABLE" ]; then
    echo "Fehler: Executable nicht gefunden: $EXECUTABLE"
    exit 1
fi

# .NET Runtime prüfen (Linux)
check_dotnet() {
    if command -v dotnet >/dev/null 2>&1; then
        echo "✓ System .NET Runtime gefunden: $(dotnet --version)"
        return 0
    else
        echo "✗ Keine .NET Runtime gefunden"
        return 1
    fi
}

# .NET Runtime installieren (falls nicht vorhanden)
install_dotnet() {
    echo "Installiere .NET 8.0 Runtime..."
    
    # Architektur prüfen
    ARCH=$(uname -m)
    case $ARCH in
        x86_64)
            DOTNET_URL="https://download.microsoft.com/download/dotnet-core/v8.0/dotnet-runtime-8.0.0-linux-x64.tar.gz"
            ;;
        aarch64|arm64)
            DOTNET_URL="https://download.microsoft.com/download/dotnet-core/v8.0/dotnet-runtime-8.0.0-linux-arm64.tar.gz"
            ;;
        *)
            echo "Nicht unterstützte Architektur: $ARCH"
            exit 1
            ;;
    esac
    
    # Download und Entpacken
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    
    echo "Lade .NET Runtime herunter..."
    wget -q "$DOTNET_URL" -O dotnet-runtime.tar.gz
    
    echo "Entpacke .NET Runtime..."
    tar -xzf dotnet-runtime.tar.gz
    
    # In Projektverzeichnis verschieben
    mkdir -p "$SCRIPT_DIR/dotnet"
    mv * "$SCRIPT_DIR/dotnet/"
    
    # Aufräumen
    cd "$SCRIPT_DIR"
    rm -rf "$TEMP_DIR"
    
    echo "✓ .NET 8.0 Runtime installiert in $SCRIPT_DIR/dotnet/"
}

# Hauptlogik
if check_dotnet; then
    echo "Starte ParSec Nova mit system .NET Runtime..."
    "$EXECUTABLE" "$@"
else
    echo "Versuche lokale .NET Runtime..."
    if [ -f "$SCRIPT_DIR/dotnet/dotnet" ]; then
        export DOTNET_ROOT="$SCRIPT_DIR/dotnet"
        export PATH="$DOTNET_ROOT:$PATH"
        echo "✓ Lokale .NET Runtime gefunden"
        echo "Starte ParSec Nova..."
        "$EXECUTABLE" "$@"
    else
        echo "Keine .NET Runtime gefunden. Möchtest du sie installieren? (j/n)"
        read -r response
        if [[ "$response" =~ ^[Jj]$ ]]; then
            install_dotnet
            export DOTNET_ROOT="$SCRIPT_DIR/dotnet"
            export PATH="$DOTNET_ROOT:$PATH"
            echo "Starte ParSec Nova..."
            "$EXECUTABLE" "$@"
        else
            echo "ParSec Nova benötigt .NET 8.0 Runtime zum Ausführen."
            echo "Bitte installiere .NET 8.0 oder starte diesen Launcher erneut."
            exit 1
        fi
    fi
fi
