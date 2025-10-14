#!/bin/bash

dotnet_versions=("9.0" "10.0")
nvm_version="0.40.3"
go_version="1.25.3"

sudo apt update && sudo apt upgrade -y
sudo apt install -y wget gpg
wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
sudo install -D -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/microsoft.gpg
rm -f microsoft.gpg
ms_deb='Types: deb
URIs: https://packages.microsoft.com/repos/code
Suites: stable
Components: main
Architectures: amd64,arm64,armhf
Signed-By: /usr/share/keyrings/microsoft.gpg
'
vs_repo_path=/etc/apt/sources.list.d/vscode.sources
sudo touch $vs_repo_path
sudo echo $ms_deb > $vs_repo_path
sudo apt install -y apt-transport-https
sudo apt update
profile='
# dotnet
export DOTNET_ROOT=$HOME/.dotnet
export PATH=$PATH:$HOME/.dotnet:$HOME/.dotnet/tools

# go
export GOROOT=/usr/local/go
export PATH=$PATH:$GOROOT/bin

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# nvm
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH=$NVM_DIR:$PATH
'
theme='
{
  "$schema": "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json",
  "blocks": [
    {
      "alignment": "left",
      "segments": [
        {
          "foreground": "#98C379",
          "style": "plain",
          "template": "\u279c",
          "type": "text"
        },
        {
          "foreground": "#56B6C2",
          "properties": {
            "style": "folder"
          },
          "style": "plain",
          "template": "  {{ .Path }}",
          "type": "path"
        },
        {
          "foreground": "#D0666F",
          "properties": {
            "branch_icon": ""
          },
          "style": "plain",
          "template": " <#5FAAE8>git:(</>{{ .HEAD }}<#5FAAE8>)</>",
          "type": "git"
        },
        {
          "foreground": "#BF616A",
          "style": "plain",
          "template": " \u2717",
          "type": "status"
        }
      ],
      "type": "prompt"
    }
  ],
  "final_space": true,
  "version": 3
}
'
zshrc='# .oh-my-posh
export PATH=$PATH:$HOME/.local/bin
clear
eval "$(oh-my-posh init zsh --config .term.theme.json)"
'
echo $theme > $HOME/.term.theme.json
echo $profile >> $HOME/.bashrc
sudo apt install -y zsh unzip neovim git gh
echo "$profile$zshrc" > .zshrc
sudo curl -s https://ohmyposh.dev/install.sh | bash -s
sudo chsh $(whoami) -s /usr/bin/zsh
sudo apt install -y make build-essential libssl-dev \
zlib1g-dev libreadline-dev libsqlite3-dev wget curl \
llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
libxmlsec1-dev libffi-dev liblzma-dev
sudo wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo chmod +x ./dotnet-install.sh
for v in "${dotnet_versions[@]}"; do
    ./dotnet-install.sh --channel $v
done
rm ./dotnet-install.sh
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$nvm_version/install.sh" | bash
curl -fsSL https://bun.com/install | bash
curl https://pyenv.run | bash
curl -OL "https://go.dev/dl/go$go_version.linux-arm64.tar.gz"
sudo tar -C /usr/local -xzf "go$go_version.linux-arm64.tar.gz"
rm "go$go_version.linux-arm64.tar.gz"
echo ""
echo "!!!!!!!!!!!!!!!!!!!!"
echo "restart the shell..."
echo "!!!!!!!!!!!!!!!!!!!!"

