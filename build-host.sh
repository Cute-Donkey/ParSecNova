#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Starting complete host build (static, optimized)...${NC}"

# 1. Clean release build without dev features
cargo build --release

# 2. Ensure target directory
mkdir -p ./dist

# 3. Copy binary
cp target/release/parsec_nova ./dist/

# 4. Copy assets (IMPORTANT for your JSON worlds)
echo -e "${BLUE}Syncing assets...${NC}"
cp -r assets ./dist/ 2>/dev/null || echo "No assets found to copy."

echo -e "${GREEN}Done! The standalone version is in ./dist/${NC}"
echo "You can start it on your host with './dist/parsec_nova'."