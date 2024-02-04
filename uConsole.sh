#!/usr/bin/env bash

# This is heavily inspired by the amazing work that this guys did!
# https://github.com/craychee/loki-init
# https://github.com/lukewertz/gabriel-init
# https://github.com/froboy/durandal-init
# https://github.com/ibuys/mac-builder

# This bash script install most of the apps that I have been using on my uConsole Raspberry pi 4 model.
# This is to hopefully make it easy for to install and find everything in the future and install everything with just one command.

function pause() {
  read -p "$*"
}

CWD=($PWD)

cd ~

# DANGER, DANGER Will Robinson! 🤖
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# Quality of terminal
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
# Install snaps
sudo apt install snapd
sudo snap install core
# Installing the game zork through snapds
sudo snap install --edge zork

# Software Dev
sudo apt install git
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

# Installing tailscale on the raspberry pi
curl -fsSL https://tailscale.com/install.sh | sh

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Installing Ollama
curl https://ollama.ai/install.sh | sh

ollama pull phi
ollama pull mistral
ollama pull llama-2
ollama pull llava

# GPIO Module
# Upico software
cd ./downloads
git clone https://github.com/dotcypress/upico.git && cd upico
mkdir dist && tar -xzf upico_0.1.0.cm4.tar.gz -C dist
cd dist && sudo ./install.sh
cd .. && rm -rf dist
upico install
# uPico software that makes the LED blink on boot
wget https://rptl.io/pico-blink
upico install pico-blink

# HAM Radio
# CHIRP
sudo apt install git python3-wxgtk4.0 python3-serial python3-six python3-future python3-requests python3-pip
# pip install ./chirp-20230509-py3-none-any.whl
pip install ./chirp-20240111-py3-none-any.whl

# RX Tools
git clone https://github.com/rxseger/rx_tools.git
cd ./rx_tools
cmake .
make
./rx_fm
chmod u+x rx_sdr

# Installing SoapySDR
git clone https://github.com/pothosware/SoapySDR.git
cd ./soapySDR
mkdir build
cd build
cmake ..
sudo make install -j`nproc`
sudo ldconfig #needed on debian systems
SoapySDRUtil --info

# Running YAAC
cd ./YAAC
java -jar YAAC.jar

# Installing gpredict
# Dependencies needed before installing it
sudo apt install libtool intltool autoconf automake libcurl4-openssl-dev pkg-config libglib2.0-dev libgtk-3-dev libgoocanvas-2.0-dev
gh repo clone csete/gpredict
tar -xvf gpredict-x.y.z.tar.gz
cd gpredict/

# Command used to check the battery life
cat /sys/class/power_supply/axp20x-battery/constant_charge_current_max

# Get git things
#curl -o /usr/local/etc/bash_completion.d/git-prompt.sh https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh
#curl -o /usr/local/etc/bash_completion.d/git-completion.bash https://raw.githubusercontent.com/git/git/master/contrib/completion/git-completion.bash

echo "NICE!! But... This is only the Beggining."
