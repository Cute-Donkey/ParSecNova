# Contributing to ParSec Nova

Thank you for your interest in contributing! We want to make world creation as accessible as possible using AI assistance and Rust's powerful ecosystem.

## 🛠 Development Setup

### Prerequisites
- Rust toolchain (stable): `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Docker and DevContainer support (recommended)
- VS Code with DevContainer and Rust extensions

### Getting Started
1. **Clone and setup**:
```bash
git clone https://github.com/donkey-projects/ParSecNova.git
cd ParSecNova
code .  # Open in VS Code, reopen in container when prompted
```

2. **Build and test**:
```bash
cargo build --release
cargo test
cargo run  # Start both simulation and client
```

## 🌌 Creating New Worlds
You can contribute by designing new sectors. We use a standardized JSON format for world definitions that are dynamically loaded at runtime.

### How to use AI for World Gen
We recommend using an LLM (like ChatGPT, Claude, or a local Llama model) with the following prompt structure:
> "Act as a level designer for ParSec Nova. Create a JSON sector definition using the Bevy ECS schema. Include entities with components for position, velocity, mass, and visual asset references. Theme: [Your Theme, e.g., Asteroid Belt]."

### World Schema Structure
Worlds are defined using Bevy ECS concepts:
- **Entities**: Game objects with unique IDs
- **Components**: Data bundles (Transform, Physics, RenderAsset)
- **Systems**: Processing logic (handled by the engine)

### Submission Guidelines
- **Via P2P**: Share your world directly in-game using the peer-to-peer transfer protocol.

## 🔧 Code Contributions

### Rust Code Style
We use `rustfmt` and `clippy` for consistent code quality:
```bash
cargo fmt
cargo clippy -- -D warnings
```

### ECS Best Practices
- Use Bevy's `Query` patterns for component access
- Prefer system parameters over direct world access
- Implement `Component` and `Resource` traits appropriately
- Use `Bundle` for related component groups

### Testing
```bash
# Unit tests
cargo test

# Integration tests
cargo test --test integration

# Benchmarks
cargo bench
```

## ⚖️ Legal & Licensing
By contributing, you agree that:
1. Your contribution is licensed under the **GPL-3.0**.
2. You have the rights to any assets or data you provide.
3. AI-generated content must not violate the copyrights of existing franchises (e.g., do not use exact names/logos from Star Trek or Star Wars for public contributions).
4. Rust code contributions must follow the Rust API guidelines and be compatible with our Bevy-based ECS architecture.

## 📦 Performance Guidelines

### Headless Simulation
- Keep simulation logic independent of rendering
- Use Bevy's `FixedUpdate` for physics calculations
- Optimize for parallel processing across CPU cores

### Asset Loading
- Use dynamic loading via JSON definitions
- Prefer glTF/GLB for 3D models
- Compress textures (WebP preferred)

### Memory Management
- Leverage Rust's ownership system for memory safety
- Use `Box` for large heap allocations
- Implement `Drop` for proper resource cleanup
