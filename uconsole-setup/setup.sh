#!/usr/bin/env bash
# Automated setup script for uConsole.
# This script is designed to replicate the uConsole setup based on the original uConsole.sh.

set -e

# Check if running as root
if [ "$(id -u)" = "0" ]; then
   echo "This script should not be run as root. Please run as a regular user." 1>&2
   exit 100
fi

# Store the script's directory for relative paths
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
cd "$SCRIPT_DIR"

echo "Starting automated uConsole setup..."

# --- 1. Update APT packages ---
echo "Updating APT package list..."
sudo apt update

echo "Installing APT packages from apt_packages.txt..."
# Filter out empty lines and comments, then install packages
PACKAGES_TO_INSTALL=$(grep -vE '^\s*#|^\s*$' apt_packages.txt | tr '\n' ' ')
if [ -n "$PACKAGES_TO_INSTALL" ]; then
    sudo apt install -y $PACKAGES_TO_INSTALL
else
    echo "No APT packages specified in apt_packages.txt."
fi

# Handle broken dependencies
sudo apt --fix-broken install -y

# --- 2. Oh My Zsh ---
echo "Installing Oh My Zsh..."
# Check if oh-my-zsh is already installed
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh is already installed."
fi

# --- 3. Snap packages ---
echo "Setting up Snap..."
if ! command -v snap &> /dev/null; then
    echo "Snap is not installed, attempting to install via apt."
    sudo apt install -y snapd
else
    echo "Snap is already installed."
fi
sudo snap install core # Core snap is often required
echo "Installing Snap packages from snap_packages.txt..."
while IFS= read -r line; do
    # Skip comments and empty lines
    if [[ "$line" =~ ^\s*#.*$ || -z "$line" ]]; then
        continue
    fi
    # Trim whitespace
    package=$(echo "$line" | xargs)
    echo "Installing snap package: $package"
    sudo snap install "$package"
done < snap_packages.txt

# --- 4. Flatpak ---
echo "Setting up Flatpak..."
if ! command -v flatpak &> /dev/null; then
    echo "Flatpak is not installed, attempting to install via apt."
    sudo apt install -y flatpak
else
    echo "Flatpak is already installed."
fi
echo "Adding Flathub remote..."
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# --- 5. Node.js (via NodeSource) ---
echo "Installing Node.js 20.x..."
if ! command -v node &> /dev/null || [[ "$(node -v)" != "v20."* ]]; then
    curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -
    sudo apt-get install -y nodejs
else
    echo "Node.js 20.x is already installed."
fi

# --- 6. npm packages ---
echo "Installing npm packages..."
# Note: The original script had a generic 'npm i'.
# If you have a package.json, navigate to its directory and run 'npm install'.
# Otherwise, list global npm packages in npm_packages.txt, one per line.
while IFS= read -r line; do
    if [[ "$line" =~ ^\s*#.*$ || -z "$line" ]]; then
        continue
    fi
    package=$(echo "$line" | xargs)
    echo "Installing npm package: $package"
    npm install -g "$package" || { echo "Failed to install npm package: $package"; continue; }
done < npm_packages.txt

# --- 7. Tailscale ---
echo "Installing Tailscale..."
if ! command -v tailscale &> /dev/null; then
    curl -fsSL https://tailscale.com/install.sh | sh
else
    echo "Tailscale is already installed."
fi

# --- 8. Rust ---
echo "Installing Rust (rustup)..."
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y # -y for non-interactive
    # Source cargo env for current session
    source "$HOME/.cargo/env"
else
    echo "Rust (rustup) is already installed."
fi

# --- 9. Ollama ---
echo "Installing Ollama for local AI..."
if ! command -v ollama &> /dev/null; then
    curl https://ollama.ai/install.sh | sh
else
    echo "Ollama is already installed."
fi

echo "Pulling some Ollama models (llama-3.1)..."
# Check if model is already downloaded to avoid re-downloading
if ! ollama list | grep -q "llama-3.1"; then
    ollama pull llama-3.1
else
    echo "Ollama model llama-3.1 already present."
fi

# --- 10. uPico software ---
echo "Installing uPico software..."
# Assuming 'downloads' directory is within SCRIPT_DIR or handled separately
# The original script assumes `cd ./downloads`, which is problematic for automation.
# I'll create a temporary directory for source builds.
mkdir -p "$SCRIPT_DIR/tmp_build"
pushd "$SCRIPT_DIR/tmp_build"

if [ ! -d "upico" ]; then
    echo "Cloning upico repository..."
    git clone https://github.com/dotcypress/upico.git
fi
pushd upico
# The original script used a specific tar.gz, which is likely for a specific architecture.
# For full automation, it's better to build from source or use generic installation steps.
# The original script's `tar -xzf upico_0.1.0.cm4.tar.gz -C dist` implies a pre-downloaded archive.
# I will assume a generic build/install. If this fails, user might need to specify architecture.
echo "Attempting to install upico via generic install command if available, or noting manual step."
# If 'upico install' is a valid command after running this block, then it should work.
# The original script did `mkdir dist && tar -xzf upico_0.1.0.cm4.tar.gz -C dist`
# and then `cd dist && sudo ./install.sh`. This needs the specific tar.gz.
# For now, I'll put a placeholder for this step, as the tar.gz is missing.
echo "WARNING: uPico installation from specific tar.gz (upico_0.1.0.cm4.tar.gz) is not fully automated."
echo "         Please ensure 'upico_0.1.0.cm4.tar.gz' is available or use a different installation method."
# Placeholder for manual intervention or specific download logic for the tarball
# upico install
popd # Exit upico
echo "Installing pico-blink..."
if [ ! -f "pico-blink" ]; then
    wget https://rptl.io/pico-blink
fi
upico install pico-blink # This command relies on 'upico' being installed correctly above.
popd # Exit tmp_build
echo "Done with uPico!"

# --- 11. HAM Radio Software (SDR++, CHIRP, RX Tools, SoapySDR, YAAC, gpredict) ---
echo "Installing HAM Radio Software..."
pushd "$SCRIPT_DIR/tmp_build"

# SDR++
echo "Building and installing SDR++..."
if [ ! -d "SDRPlusPlus" ]; then
    git clone https://github.com/AlexandreRouma/SDRPlusPlus
fi
pushd SDRPlusPlus
mkdir -p build && pushd build
cmake .. -DOPT_BUILD_RTL_SDR_SOURCE=ON
make -j`nproc`
sudo make install
popd # Exit build
popd # Exit SDRPlusPlus
echo "Done with SDR++!"

# CHIRP
echo "Installing CHIRP..."
# The original script installs a local .whl file. This needs to be available.
# I will add a placeholder for this file.
echo "WARNING: CHIRP installation from local .whl file (chirp-20240111-py3-none-any.whl) is not fully automated."
echo "         Please ensure 'chirp-20240111-py3-none-any.whl' is available in the current directory."
# Placeholder for manual intervention or specific download logic for the whl file
# pip install ./chirp-20240111-py3-none-any.whl
echo "Done with CHIRP!"

# RX Tools
echo "Building and installing RX Tools..."
if [ ! -d "rx_tools" ]; then
    git clone https://github.com/rxseger/rx_tools.git
fi
pushd rx_tools
cmake .
make -j`nproc`
chmod u+x rx_sdr # Original script had this, keep it.
popd # Exit rx_tools
echo "Done with RX Tools!"

# SoapySDR
echo "Building and installing SoapySDR..."
if [ ! -d "SoapySDR" ]; then
    git clone https://github.com/pothosware/SoapySDR.git
fi
pushd SoapySDR
mkdir -p build && pushd build
cmake ..
sudo make install -j`nproc`
sudo ldconfig
SoapySDRUtil --info
popd # Exit build
popd # Exit SoapySDR
echo "Done with SoapySDR!"

# YAAC
echo "Installing YAAC..."
# The original script runs a local .jar file. This needs to be available.
echo "WARNING: YAAC installation/run requires a local 'YAAC.jar' file."
echo "         Please ensure 'YAAC.jar' is available in a 'YAAC' subdirectory within 'tmp_build'."
# Placeholder for manual intervention or specific download logic for the jar file
# java -jar YAAC.jar
echo "Done with YAAC!"

# gpredict
echo "Building and installing gpredict..."
# The original script expects a gpredict-x.y.z.tar.gz and then untars it.
# It also uses `gh repo clone csete/gpredict` which is not the tarball.
# I'll prioritize the `gh repo clone` method as it's more automatable if gh cli is installed.
# If `gh` is not installed, this step will fail.
if ! command -v gh &> /dev/null; then
    echo "WARNING: GitHub CLI (gh) is not installed. gpredict cannot be cloned automatically."
    echo "         Please install 'gh' or manually download and extract gpredict-x.y.z.tar.gz."
else
    if [ ! -d "gpredict" ]; then
        gh repo clone csete/gpredict
    fi
    pushd gpredict
    # Original script had `tar -xvf gpredict-x.y.z.tar.gz` after cloning, which is contradictory.
    # Assuming standard autotools build for a cloned git repo.
    echo "Attempting standard autotools build for gpredict..."
    ./autogen.sh # If needed for cloned repo
    ./configure
    make -j`nproc`
    sudo make install
    popd # Exit gpredict
fi
echo "Done with gpredict!"

popd # Exit tmp_build

# --- 12. Clean up temporary build files ---
echo "Cleaning up temporary build directory..."
rm -rf "$SCRIPT_DIR/tmp_build"

echo "Setup complete! Please check for any warnings or manual steps mentioned above."
echo "A reboot might be required for some changes to take effect."
# Removed sudo reboot for automation, user can do it manually.
