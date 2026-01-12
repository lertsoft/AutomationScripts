# System Setup Inventory
Updated as of: 2026-01-12

# Mac_installer
Automation of all my mac utilities.

### Links to some of the apps I use

* <a href="https://max.codes/latest/" > Latest </a> This is an app that update all of your apps!
* <a href="https://hovrly.com/?ref=producthunt" > Hovrly </a> This App shows you the time of a different location constanly on the menu bar. Simple app but pretty useful.
* <a href="https://tempbox.waseem.works/" > Tempbox </a> This app creates temporary emails but saves the locally and allows you to keep them for a longer period because all the info is stored on device.
* <a href="https://menubarx.app/" > Menu Bar X </a> This is an app that is a browser but minify to work from the menu bar and can be fake as a mobile browser.
* <a href="https://apps.apple.com/app/id1611378436"> Pure Paste </a> This clears off all the formating on a text.
* <a href="https://apps.apple.com/us/app/hotkey-app/id975890633?mt=12" > Hotkey </a>
* <a href="https://quietreader.app/" > Quit Reader </a> This is a clean Reading app for the web and beyond.

**[Full List of tools that I use](https://ronnycoste.com/uses)**


## 1. System Information
- **OS:** macOS Darwin (arm64)
- **Shell:** zsh (with Oh My Zsh)

## 2. GUI Applications
### /Applications
- Affinity, Arc, Blender, DaVinci Resolve, Discord, Docker, Final Cut Pro, Google Chrome/Apps, Logic Pro, Microsoft Office (Word, Excel, PowerPoint, Outlook, OneNote), Notion, Obsidian, Raycast, Spotify, Visual Studio Code, WhatsApp, Xcode, Zoom, etc.

### Mac App Store (mas)
- Bitwarden, Blackmagic Disk Speed Test, Compressor, Drafts, Dropzone 4, GarageBand, Keynote/Numbers/Pages, Magnet/Tiles (check brew), Pixelmator Pro, Tailscale, The Unarchiver, WireGuard.

## 3. Package Managers & CLI Tools
### Homebrew
**Formulae:**
- git, node, python@3.13, ffmpeg, htop, wget, yarn, zsh-autosuggestions, zsh-syntax-highlighting, mas, yt-dlp, etc.
**Casks:**
- dozer, ghostty, github, karabiner-elements, raycast, tiles.

### NPM Global Packages
- @angular/cli
- @google/gemini-cli
- @google/jules
- expo-cli
- fast-cli
- imageoptim-cli
- npm-check-updates
- sass
- vercel/serve (implied if common, but only explicit ones listed above)

### Conda (Miniconda3)
- Base environment: python 3.x, standard libs.
- Custom environments: `llama-gpt`.

### Python (Pip in Base Env)
- standard data science/dev stack + `mcp` packages.

### Other CLI
- **Bun:** Installed (`~/.bun`)
- **Deno:** Installed (`~/.deno`)
- **LM Studio:** (`~/.cache/lm-studio/bin`)
- **uv:** (`~/.local/bin/uv`)

## 4. IDE Extensions
### VS Code
- **Python:** Pylance, Python, isort, debugpy.
- **Web:** Tailwind CSS, Prettier, ESLint, Angular (implied by CLI), Svelte.
- **AI:** GitHub Copilot, Gemini Code Assist.
- **Tools:** Docker, GitLens (or similar), Remote Containers, Live Share, Jupyter.

### Cursor
- Similar to VS Code + Cursor specific extensions.

## 5. Shell Configuration (.zshrc)
- **Framework:** Oh My Zsh
- **Theme:** robbyrussell
- **Plugins:** git
- **Integrations:**
  - Angular CLI completion
  - Conda initialization
  - LM Studio path
  - Local bin (`~/.local/bin/env`)
  - Deno env
  - Bun env
  - Kiro integration
