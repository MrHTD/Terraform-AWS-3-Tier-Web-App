#!/bin/bash

echo "Running Frontend Setup in Ubuntu"
# Installing Dependencies
echo "########################################"
echo "Installing packages."
echo "########################################"
sudo apt update

sudo apt install curl -y > /dev/null

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
echo "########################################"
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

nvm install --lts

sudo apt install npm -y > /dev/null
node -v