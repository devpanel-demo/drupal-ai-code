#!/bin/bash
# ---------------------------------------------------------------------
# Copyright (C) 2023 DevPanel
# You can install any service here to support your project
# Please make sure you run apt update before install any packages
# Example:
# - sudo apt-get update
# - sudo apt-get install nano
#
# ----------------------------------------------------------------------

sudo apt-get update
sudo apt-get install -y nano

echo '> Install node 22'
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
\. "$HOME/.nvm/nvm.sh"
nvm install 22
echo "> Installed Node $(node -v), NPM $(npm -v)"
npm config set os linux
sudo chown $(whoami):$(whoami) $HOME/.npm $HOME/.npmrc $HOME/.nvm

# Install Claude
npm install @anthropic-ai/claude-code --force --no-os-check
sudo ln -s $(pwd)/node_modules/.bin/claude /usr/local/bin/claude

# Install Google Gemini
npm install @google/gemini-cli --force --no-os-check
sudo ln -s $(pwd)/node_modules/.bin/gemini /usr/local/bin/gemini
echo GEMINI_API_KEY= >>.env
echo GEMINI_API_KEY= >>.env

# Install VSCode Extensions
if [[ -n "$DP_VSCODE_EXTENSIONS" ]]; then
    sudo chown -R www:www $APP_ROOT/.vscode/extensions/
    IFS=','
    for value in $DP_VSCODE_EXTENSIONS; do
        code-server --install-extension $value --user-data-dir=$APP_ROOT/.vscode
    done
fi
