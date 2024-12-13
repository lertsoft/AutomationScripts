#!/usr/bin/env bash
# This bash script install most of the apps that I have been using on my uConsole Raspberry pi 4 model.
# This is to hopefully make it easy for to install and find everything in the future and install everything with just one command.

set -e

[ $(id -u) = 0 ] && echo "Please do not run this script as root" && exit 100

function pause() {
  read -p "$*"
}

CWD=($PWD)

cd ~

sudo apt update

# DANGER, DANGER Will Robinson! 🤖
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Quality of terminal
echo "Installing QOL toosl for terminal and UI"
sudo apt install neofecth
sudo apt install htop
sudo apt install btop++
sudo apt install wget
# Installing pi-Kiss
curl -sSL https://git.io/JfAPE | bash
# Installing Pi-Apps
wget -q0- https://raw.githubusercontent.com/Botspot/pi-apps/master/install | bash
# Installing sensors in XFCE to monitor temperature and battery life
sudo apt-get install xfce4-sensors-plugin
sudo apt --fix-broken install
# Installing snaps
sudo apt install snapd
sudo snap install core
# Installing the game zork through snapds
# sudo snap install --edge zork

# Installing flathub - flatpak
sudo apt install flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Software Dev
echo "Installing Software dev tooling"
sudo apt install git curl
sudo apt install python3
sudo apt install spyder
# sudo apt install ./
# Setup Python, Virtualenv
  # http://gmvault.org/
  # python3 -m venv ~/Unix/env/virtualenv
  # source ~/Unix/env/virtualenv
  # pip install virtualenv
  # virtualenv -p /usr/bin/python ~/Unix/env/py2env
  # deactivate
# Installing node.js 20 on a raspberry pi
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - &&\sudo apt-get install -y nodejs
npm i
echo "Done with Software dev tooling"

# Installing tailscale on the raspberry pi
echo "Installing Tailscale"
curl -fsSL https://tailscale.com/install.sh | sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Installing Ollama
echo "Installing Ollama for local AI"
curl https://ollama.ai/install.sh | sh

echo "Pulling some models to play with"
#ollama pull phi
ollama pull llama-3.1
#ollama pull llava
echo "Done with Ollama!"

# GPIO Module
# Upico software
echo "Installing UPico software"
cd ./downloads
git clone https://github.com/dotcypress/upico.git && cd upico
mkdir dist && tar -xzf upico_0.1.0.cm4.tar.gz -C dist
cd dist && sudo ./install.sh
cd .. && rm -rf dist
upico install
# uPico software that makes the LED blink on boot
wget https://rptl.io/pico-blink
upico install pico-blink
echo "Done with UPico!"

# HAM Radio
#SDR++
echo "Installing SDR++ dependancies"
sudo apt install -y build-essential cmake libfftw3-dev libglfw3-dev libglew-dev libvolk2-dev libzstd-dev libsoapysdr-dev libairspyhf-dev libairspy-dev \
            libiio-dev libad9361-dev librtaudio-dev libhackrf-dev librtlsdr-dev libbladerf-dev liblimesuite-dev p7zip-full
            
git clone https://github.com/AlexandreRouma/SDRPlusPlus
cd SDRPlusPlus            

echo "Preparing SDR++ build"
sudo mkdir -p build
cd build

sudo mkdir -p CMakeFiles
sudo cmake .. -DOPT_BUILD_RTL_SDR_SOURCE=ON

echo "Building"
sudo make

echo "Installing SDR++"
sudo make install

echo "Done with SDR++!"

# CHIRP
echo "Installing CHIRP"
sudo apt install -y python3-wxgtk4.0 python3-serial python3-six python3-future python3-requests python3-pip
# pip install ./chirp-20230509-py3-none-any.whl
pip install ./chirp-20240111-py3-none-any.whl
echo "Done with CHIRP!"

# RX Tools
echo "Installing RXTools"
git clone https://github.com/rxseger/rx_tools.git
cd ./rx_tools
cmake .
make
./rx_fm
chmod u+x rx_sdr
echo "Done with RXTools!"

# Installing SoapySDR
echo "Installing SoapySDR"
git clone https://github.com/pothosware/SoapySDR.git
cd ./soapySDR
mkdir build
cd build
cmake ..
sudo make install -j`nproc`
sudo ldconfig #needed on debian systems
SoapySDRUtil --info
echo "Done with SDRutil!"

# Running YAAC
echo "Installing YAAC"
cd ./YAAC
java -jar YAAC.jar
echo "Done with YAAC!"

# Installing gpredict
# Dependencies needed before installing it
echo "Installing dependencies for gpredict"
sudo apt install -y libtool intltool autoconf automake libcurl4-openssl-dev pkg-config libglib2.0-dev libgtk-3-dev libgoocanvas-2.0-dev
gh repo clone csete/gpredict
tar -xvf gpredict-x.y.z.tar.gz
echo "Opening gpredict"
cd gpredict/

echo "Done with gpredict!"

# Command used to check the battery life
echo "Checking battery life"
cat /sys/class/power_supply/axp20x-battery/constant_charge_current_max

# Get git things
#curl -o /usr/local/etc/bash_completion.d/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
#curl -o /usr/local/etc/bash_completion.d/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

echo "NICE!! But... This is only the Beggining."
sudo reboot
