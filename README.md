# ParSec Nova xxxxx

A modern, open-source rebirth of the legendary linux space combat simulator **ParSec** (1999/2002). 

This project aims to bridge the gap between classic Newtonian flight physics and modern game engine technology. By leveraging **Godot 4** and **C#**, we are rebuilding the experience from the ground up, focusing on decentralized multiplayer and AI-driven world-building.

## ✨ Core Vision

- **Authentic Physics:** Implementation of the original Newtonian flight model for deep, skill-based space combat.
- **AI-Driven World Building:** Every player can define their own static sectors using AI prompts, saved in a standardized JSON format.
- **Decentralized Multiplayer:** No central server authority. Players host their own worlds and share sector data peer-to-peer.
- **Open Source Heritage:** Built on the spirit of the original GPL sources, keeping the galaxy free and moddable forever.

## 🛠 Tech Stack

- **Engine:** [Godot 4.x](https://godotengine.org/)
- **Language:** C# (.NET 8/9)
- **Physics:** Custom RigidBody3D implementation based on original ParSec logic.
- **Multiplayer:** Godot High-level Multiplayer API (ENet/P2P).
- **Data Format:** JSON-based world and ship definitions.

## 📂 Repository Structure
This project is part of the [donkey-projects](https://github.com/donkey-projects) organization. To facilitate development, the following repositories are used:

* **Development:** [ParSecNova](https://github.com/donkey-projects/ParSecNova) (This repository)
* **Legacy Source:** [parsec](https://github.com/donkey-projects/parsec) (Original source code fork for logic reference)
* **Legacy Assets:** [orig-openparsec-assets](https://github.com/donkey-projects/orig-openparsec-assets) (Original artwork and sound archives)

## 🚀 Getting Started

*(Note: This project is currently in the early conceptual/prototyping stage.)*

### Prerequisites
- .NET SDK (8.0 or higher)
- Godot Engine 4.x (.NET Version)

### Installation
1. Clone the repository:
```bash
   git clone https://github.com/donkey-projects/ParSecNova.git
```

For detailed licensing and a list of original contributors, see **[CREDITS.md](CREDITS.md)**.
