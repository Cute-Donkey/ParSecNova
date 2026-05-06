# ParSec Nova

A modern, open-source rebirth of the legendary linux space combat simulator **ParSec** (1999/2002). 

This project aims to bridge the gap between classic Newtonian flight physics and modern game engine technology. By leveraging **Rust** and **Bevy**, we are rebuilding the experience from the ground up, focusing on decentralized multiplayer and AI-driven world-building.

## ✨ Core Vision

- **Authentic Physics:** Implementation of the original Newtonian flight model for deep, skill-based space combat.
- **AI-Driven World Building:** Every player can define their own static sectors using AI prompts, saved in a standardized JSON format.
- **Decentralized Multiplayer:** No central server authority. Players host their own worlds and share sector data peer-to-peer.
- **Open Source Heritage:** Built on the spirit of the original GPL sources, keeping the galaxy free and moddable forever.

## 🛠 Tech Stack

- **Language:** [Rust](https://www.rust-lang.org/)
- **Engine:** [Bevy](https://bevyengine.org/) (ECS-based game engine)
- **Physics:** Custom Newtonian physics systems using Bevy's ECS architecture.
- **Architecture:** Strict separation of simulation (headless) and visualization.
- **Data Format:** JSON-based world definitions with dynamic runtime loading.
- **Build System:** Cargo with static compilation for portable binaries.
- **Development:** Docker/DevContainer for isolated build environment.

## 📂 Repository Structure
This project is part of the [donkey-projects](https://github.com/donkey-projects) organization. To facilitate development, the following repositories are used:

* **Development:** [ParSecNova](https://github.com/donkey-projects/ParSecNova) (This repository)
* **Legacy Source:** [parsec](https://github.com/donkey-projects/parsec) (Original source code fork for logic reference)
* **Legacy Assets:** [orig-openparsec-assets](https://github.com/donkey-projects/orig-openparsec-assets) (Original artwork and sound archives)

## 🚀 Getting Started

**⚠️ Important Notice:** This project is currently in **early development**. We have completed the analysis and planning phase (Phase 1) and set up the basic project structure (Phase 1.4). The actual game implementation (Phase 2+) has not yet begun. Please see the [Project Plan](plans/) for detailed development progress.

### Prerequisites
- Rust toolchain (stable)
- Docker and DevContainer support (recommended)
- For visualization: Native graphics drivers (Vulkan/Metal/DX12)

### Installation
1. Clone the repository:
```bash
   git clone https://github.com/donkey-projects/ParSecNova.git
   cd ParSecNova
```

2. Open in DevContainer (recommended):
```bash
   # Open in VS Code with DevContainer extension
   code .
   # Reopen in Container when prompted
```

3. Or build locally:
```bash
   cargo build --release
```

### Current Development Status
- ✅ **Phase 1.1**: Original ParSec Analysis (completed)
- ✅ **Phase 1.2**: Technical Requirements (completed)
- ✅ **Phase 1.3**: Asset Analysis & AI Modernization (completed)
- 🟠 **Phase 1.4**: Project Structure & Tech Stack Migration (in progress)
- ⏳ **Phase 2**: Early Prototype (upcoming)

### Project Structure
```
ParSecNova/
├── src/                    # Rust source code
│   ├── core/              # Core ECS systems (Physics, Components)
│   ├── simulation/        # Headless simulation logic
│   ├── visualization/     # Client-side rendering systems
│   └── systems/           # Bevy systems and queries
├── assets/                # Game assets
│   ├── models/            # 3D models (glTF/GLB)
│   ├── textures/          # Textures (PNG/WebP)
│   ├── sounds/            # Audio files (WAV/OGG)
│   └── worlds/            # JSON world definitions
├── benches/               # Performance benchmarks
├── tests/                 # Integration and unit tests
└── target/                # Cargo build output
```

### Building
```bash
# Development build
cargo build

# Release build with optimizations
cargo build --release

# Run tests
cargo test

# Run benchmarks
cargo bench
```

### Running
```bash
# Headless simulation (server mode)
cargo run --bin simulation

# Full client with visualization
cargo run --bin client

# Both simulation and client
cargo run
```

### Architecture Highlights

#### ECS-Based Design
ParSecNova uses Bevy's Entity Component System for massive parallel processing:
- **Entities**: Game objects (ships, asteroids, projectiles)
- **Components**: Data (position, velocity, mass, visual assets)
- **Systems**: Logic that processes components (physics, rendering, AI)

#### Headless Simulation
The core simulation runs completely headless, enabling:
- Server-side world generation with AI
- Massive-scale physics calculations
- P2P world sharing without visual dependencies

#### Dynamic World Loading
Worlds are defined entirely in JSON format:
- Entities and their physical properties
- Asset references (models, textures, sounds)
- Complete world state can be shared between players
- No code changes required for new content

For detailed licensing and a list of original contributors, see **[CREDITS.md](CREDITS.md)**.
