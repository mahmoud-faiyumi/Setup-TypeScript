# TypeScript Project Setup Script

This PowerShell script automates the setup of a TypeScript project on Windows. It installs Node.js (if missing), configures TypeScript globally, initializes an npm project, sets up a `tsconfig.json`, and creates a sample TypeScript project with essential scripts.

## Features
- 📌 Installs Node.js if not detected.
- 🌐 Installs TypeScript globally.
- 📂 Sets up a structured TypeScript project.
- 📜 Generates `package.json` with predefined scripts.
- ⚙️ Creates a `tsconfig.json` for compilation settings.
- 📝 Includes sample TypeScript files for testing.
- ✅ Provides ready-to-use npm commands.

## Prerequisites
- Windows OS
- PowerShell
- Internet connection (for Node.js installation if required)

## Installation & Usage
1. Download or clone this repository.
2. Open PowerShell as Administrator.
3. Navigate to the script directory.
4. Run the script:
   ```powershell
   .\setup-typescript.ps1
   ```
5. Follow the instructions displayed in the terminal.

## Available Commands
After running the script, you can use:
- `npm run build` → Compiles TypeScript files.
- `npm run start` → Runs the compiled JavaScript file.
- `npm run start-ts` → Runs the TypeScript file directly using `ts-node`.

## Author
By **Mahmoud Alfaiyumi** from IIH Angular course.

🚀 Happy Coding! 🎯

