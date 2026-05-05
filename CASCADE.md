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

### Git Workflow - ABSOLUTE RESTRICTIONS

🚫 **FORBIDDEN GIT OPERATIONS - NEVER EXECUTE:**
- git commit (ABSOLUTELY FORBIDDEN)
- git push (ABSOLUTELY FORBIDDEN) 
- git add . (ABSOLUTELY FORBIDDEN)
- git reset --hard (ABSOLUTELY FORBIDDEN)
- git merge (ABSOLUTELY FORBIDDEN)
- git rebase (ABSOLUTELY FORBIDDEN)

✅ **ALLOWED GIT OPERATIONS (READ-ONLY):**
- git status (SHOW RESULTS TO USER)
- git diff (SHOW RESULTS TO USER)
- git log (SHOW RESULTS TO USER)
- git show (SHOW RESULTS TO USER)

🔓 **EXPLICIT COMMANDS - ONE-TIME EXECUTION ONLY:**
- "commit [file/description]" → ALLOWED: ONLY this specific change
- "commit the plan" → ALLOWED: ONLY plan files, NOTHING else
- "push only this" → ALLOWED: ONLY the last committed changes

🚫 **STRICT PROJECTION PROHIBITIONS:**
- NEVER assume permission extends to other files
- NEVER assume permission extends to subsequent operations  
- NEVER batch multiple commits without explicit request
- NEVER push after commit unless explicitly requested

✅ **MANDATORY VALIDATION PROTOCOL:**
1. "You want: [exact action] - Confirm?"
2. "Only [specific file/change] - Correct?"
3. "No further actions after - Understood?"

🔒 **RESET AFTER EACH ACTION:**
- After each commit: Permission reset
- After each push: Permission reset  
- New action = new permission required

🔒 **MANDATORY WORKFLOW BEFORE ANY CHANGES:**
1. ALWAYS run: git status
2. ALWAYS SHOW RESULTS to user
3. ALWAYS ask: "Git status shows [changes]. Proceed with modifications?"
4. **WAIT FOR USER RESPONSE** - NEVER proceed without explicit "YES" or "PROCEED"
5. **CONFIRMATION LOOP**: If no response after asking, REPEAT the question until user answers

🔒 **MANDATORY WORKFLOW AFTER ANY CHANGES:**
1. ALWAYS run: git status
2. ALWAYS SHOW RESULTS to user  
3. ALWAYS ask: "Changes made. Should I create a commit?"
4. **WAIT FOR USER RESPONSE** - NEVER commit without explicit "COMMIT" command
5. **CONFIRMATION LOOP**: If no response after asking, REPEAT the question until user answers

🔒 **ABSOLUTE CONFIRMATION RULES:**
- **NO ASSUMPTIONS**: Never assume user intent from context
- **EXPLICIT INPUT REQUIRED**: Every action needs explicit user confirmation
- **ZERO ACTION WITHOUT APPROVAL**: NO action of any kind without explicit user approval
- **REPEAT IF UNCLEAR**: If user response is ambiguous, ask for clarification
- **ONE ACTION AT A TIME**: Never batch multiple actions without separate confirmation for each
- **IMMEDIATE HALT**: If user says "NO", "STOP", or shows disapproval, STOP ALL ACTIVITIES instantly
- **NO AUTO-PROCEED**: Never proceed with any action without waiting for explicit user response

⚠️ **EMERGENCY PROTOCOL:**
- If git operations fail: STOP immediately
- If uncertain about changes: ASK user
- If user says "STOP" or "stop": HALT ALL operations immediately
- **ABSOLUTE STOP COMMAND:** The word "stop" (any case) immediately terminates all AI activities without confirmation

### Language Requirements
- **Dual language documentation** required:
  - English: `parsec_remake_plan_en.md` (tracked in Git)
  - German: Separate files (excluded from .gitignore)
- All game text currently in German, needs translation system
- Translation requirements documented in Phase 7 (Week 18-19)
- **Development Plans:** Located under `@plans/` directory with dual language support
- **Plan Synchronization:** Keep both English and German plans current and synchronized - `parsec_remake_plan_en.md` and German translation files must reflect actual current implementation status
- **Translation System Implementation:** At specified milestone (Phase 7), implement text resources and dynamic translation system for all game text, with automatic detection of text elements and orientation for future changes

## Plan Language Management System

### Dual Language Requirement
- **All plans must exist in both languages**: English (*_en.md) and preferred language (*_{lang}.md)
- **Synchronization mandatory**: Both language versions must be kept current and identical in content
- **Structure preservation**: Tables, code blocks, formatting must be identical across languages
- **Translation accuracy**: Technical terms must be translated consistently

### Language Preference Detection
- **Agent checks existing plans**: If only one language exists, query developer preference
- **Generic query example**: "I see plans exist only in English. What is your preferred language for plan documentation? (e.g., 'de' for German, 'fr' for French, 'en' for English)"
- **Preference storage**: Remember choice for future plan creation
- **Fallback**: Use English if no preference specified

### Git Exclude Management
- **Exclude location**: Use `.git/info/exclude` (NOT `.gitignore`)
- **Auto-creation**: Agent automatically adds preferred language plan files to `.git/info/exclude`
- **Persistence**: Exclude entries survive container rebuilds via automatic recreation
- **Scope**: Only preferred language plans are excluded; English plans remain tracked

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
- **Automatic Updates:** Key binding changes are automatically reflected in F1 help dialog

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

## CRITICAL REMINDER
THESE GIT RULES ARE ABSOLUTE. VIOLATION CONSTITUTES SYSTEM FAILURE.

## Last Updated
2026-05-04 - Added comprehensive Plan Language Management System with dual language requirements, preference detection, and .git/info/exclude management
2026-05-04 - Added absolute Git restrictions with granular permission system and explicit command validation
