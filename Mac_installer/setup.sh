#!/bin/bash
# MacOS Setup Replication Script
# Updated as of: 2026-01-12

echo "Starting system setup..."

function pause() {
  read -p "$*"
}

CWD=($PWD)

cd ~

# We can't get them directly, but just click this button :)
xcode-select --install

pause 'Press [Enter] once you have installed XCode and XCode Command Line Tools.'

# Just make sure...
sudo xcodebuild -license accept


# 1. Install Homebrew if not installed
if ! command -v brew &> /dev/null; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    
    # Add brew to path for immediate use in this script
    if [[ $(uname -m) == 'arm64' ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    else
        eval "$(/usr/local/bin/brew shellenv)"
    fi
else
    echo "Homebrew already installed."
fi

# Update brew
echo "Updating Homebrew..."
brew update

# 2. Install Brew Formulae (CLI Tools)
echo "Installing Brew Formulae..."
brew_formulae=(
    "git"
    "node"
    "python3"
    "ffmpeg"
    "htop"
    "wget"
    "yarn"
    "zsh-autosuggestions"
    "zsh-syntax-highlighting"
    "mas"
    "yt-dlp"
    "lazydocker"
    "uv"
    "deno"
)

for formula in "${brew_formulae[@]}"; do
    brew install "$formula"
done

# 3. Install Brew Casks (GUI Apps)
echo "Installing Brew Casks..."
brew_casks=(
    "dozer"
    "calibre"
    "veracrypt"
    "balenaetcher"
    "wireshark"
    "google-drive"
    "imageoptim"
    "protonvpn"
    "ghostty"
    "github"
    "raycast"
    "tiles"
    "visual-studio-code"
    "cursor"
    "discord"
    "docker"
    "obsidian"
    "spotify"
    "zoom"
    "arc"
)

for cask in "${brew_casks[@]}"; do
    brew install --cask "$cask" --force
done

# 4. Install Mac App Store Apps (via mas)
# You need to be signed into the App Store for this to work.
echo "Signing into App Store..."
mas signin ronnycoste@pm.me

echo "Installing Mac App Store Apps..."
mas_apps=(
    "1352778147" # Bitwarden
    "425264550"  # Blackmagic Disk Speed Test
    "424390742"  # Compressor
    "571213070"  # DaVinci Resolve
    "640199958"  # Developer
    "1435957248" # Drafts
    "424389933"  # Final Cut Pro
    "682658836"  # GarageBand
    "1351639930" # Gifski
    "409183694"  # Keynote
    "1661733229" # LocalSend
    "634148309"  # Logic Pro
    "434290957"  # Motion
    "409203825"  # Numbers
    "6720708363" # Obsidian Web Clipper
    "409201541"  # Pages
    "1289583905" # Pixelmator Pro
    "1611378436" # Pure Paste
    "1475387142" # Tailscale
    "425424353"  # The Unarchiver
    "1477089520" # Backtrack
    # "310633997"  # WhatsApp
    "1451685025" # WireGuard
    "497799835"  # Xcode
)

for app_id in "${mas_apps[@]}"; do
    mas install "$app_id"
done

# 5. Global NPM Packages
echo "Installing Global NPM Packages..."
npm_globals=(
    "@google/gemini-cli"
    "@google/jules"
    "expo-cli"
    "fast-cli"
    "imageoptim-cli"
    "npm-check-updates"
)

for pkg in "${npm_globals[@]}"; do
    npm install -g "$pkg"
done

# 6. Install Bun
if ! command -v bun &> /dev/null; then
    echo "Installing Bun..."
    curl -fsSL https://bun.sh/install | bash
fi

# 7. VS Code Extensions
# Ensuring 'code' command is available
if ! command -v code &> /dev/null; then
    echo "Linking VS Code command..."
    # Standard location for VS Code binary on macOS
    if [ -f "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
        export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"
    fi
fi

if command -v code &> /dev/null; then
    echo "Installing VS Code Extensions..."
    vscode_exts=(
        "amazonwebservices.aws-toolkit-vscode"
        "blanu.vscode-styled-jsx"
        "bradlc.vscode-tailwindcss"
        "dbaeumer.vscode-eslint"
        "esbenp.prettier-vscode"
        "github.copilot"
        "github.copilot-chat"
        "google.geminicodeassist"
        "ms-python.python"
        "ms-python.vscode-pylance"
        "ms-toolsai.jupyter"
        "ms-azuretools.vscode-docker"
        "svelte.svelte-vscode"
        "github.vscode-pull-request-github"
    )
    for ext in "${vscode_exts[@]}"; do
        code --install-extension "$ext" --force
    done
else
    echo "VS Code CLI ('code') not found. Skipping extension installation."
fi

# 8. Setup SSH keys in keychain
# This https://github.com/jirsbek/SSH-keys-in-macOS-Sierra-keychain
#curl -o ~/Library/LaunchAgents/ssh.add.a.plist https://raw.githubusercontent.com/jirsbek/SSH-keys-in-macOS-Sierra-keychain/master/ssh.add.a.plist
touch ~/.ssh/config
echo "Host *
   AddKeysToAgent yes
   UseKeychain yes" >> ~/.ssh/config

# Hold my own hand to make sure I finish configuring.
echo "Add your ssh keys (you put them in your secret hiding place)."
pause 'Press [Enter] when you have added your ssh key.'
chmod 400 ~/.ssh/*

echo "NICE!!! Setup script completed! Please restart the terminal."
