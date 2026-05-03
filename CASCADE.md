# CASCADE AI Agent Context

## Project Overview
**ParSec Nova** - A modern remake of the classic ParSec space simulation game using Godot Engine v4.6.2.

## Key Project Information

### Repository Structure
- **Main Game:** `/workspaces/ParSecNova/` (Git root)
- **Engine:** Godot Engine v4.6.2.stable.official.71f334935
- **Language:** GDScript (C# disabled for web compatibility)
- **Build System:** Custom `build.sh` with multi-platform support

### Critical Directories
- `plans/` - Project documentation (English and German)
  - `parsec_remake_plan_en.md` - English project plan
  - `*_de.md` - German plans (excluded from Git via .gitignore)
- `scripts/` - Game logic (GDScript)
- `scenes/` - Godot scene files
- `assets/` - Game assets (textures, models, etc.)
- `.github/workflows/` - CI/CD pipeline

### Important Files
- `project.godot` - Godot project configuration
- `build.sh` - Build script with export template download
- `TestControls.gd` - Main game controller with ship physics, HUD, and help system
- `SimplePrototype.tscn` - Current main scene

## Development Rules

### Git Workflow
- **NO automatic pushes** - User controls when to push manually
- Only commit when explicitly requested
- Default behavior: commit only, no push
- User preference: "lassen Sie das jetzt so, aber in zukunft keine pushes mehr. Ich will nicht alles pushen was ich committe."

### Language Requirements
- **Dual language documentation** required:
  - English: `parsec_remake_plan_en.md` (tracked in Git)
  - German: Separate files (excluded from .gitignore)
- All game text currently in German, needs translation system
- Translation requirements documented in Phase 7 (Week 18-19)

### Technical Constraints
- **Web compatibility:** C# disabled, only GDScript
- **CI/CD:** GitHub Actions with multi-platform builds (Linux, Windows, Web)
- **Export templates:** Automatically downloaded by build script
- **Godot metadata:** Excluded from Git via .gitignore

## Current Game Features

### Ship Controls
- **Arrow Keys:** Rotation (pitch/yaw)
- **Space:** Forward thrust
- **Shift+Space:** Reverse thrust  
- **S:** Emergency stop (all movement)
- **ESC:** Quit game
- **F1:** Toggle help dialog

### HUD Display
- Ship telemetry (speed, velocity, rotation rates)
- Object distances (sun, asteroid)
- Real-time data updates

### Help System
- Modal dialog with key bindings
- Toggle with F1 key
- Covers movement, special functions, display info

## Known Issues & Solutions

### Web Canvas Scaling
- Documented limitation: 64px canvas attributes persist despite CSS overrides
- Requires Godot Editor export settings changes for full resolution
- Current workaround: Acceptable small canvas size

### German Plan Files
- Excluded from Git via `.gitignore` (`plans/*_de.md`)
- Create separate German documentation files when needed
- User wants both languages maintained

## Translation Requirements (Phase 7)

### Text Elements Requiring Translation
- **HUD Display:** Ship data, rotation rates, object information
- **Help Dialog:** Key bindings, control descriptions, instructions  
- **Console Messages:** System notifications, status updates

### Implementation Strategy
- Use Godot's built-in translation system
- Create separate translation files per language
- Implement runtime language switching
- Fallback to German for missing translations

## CI/CD Status
- ✅ Complete pipeline with automated builds
- ✅ Multi-platform support (Linux, Windows, Web)
- ✅ Automated releases on main branch
- ⏳ Node.js 24 update pending (low priority)

## Build Commands
```bash
# Build for specific OS
./build.sh linux
./build.sh windows  
./build.sh web

# Local development
godot --headless --path . scenes/prototypes/SimplePrototype.tscn
```

## Memory Context
This file serves as persistent context for CASCADE AI agent across chat sessions and devcontainer rebuilds. Update this file when:
- New critical project information emerges
- Development rules change
- Important technical decisions are made
- Translation requirements evolve

## Last Updated
2026-05-03 - Added translation requirements and German documentation rules
