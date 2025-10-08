#!/bin/bash

dotnet_versions=("9.0" "10.0")
nvm_version="0.40.3"
go_version="1.25.1"

sudo apt update
echo "" >> $HOME/.bashrc && \
echo "# dotnet" >> $HOME/.bashrc && \
echo "export DOTNET_ROOT=\$HOME/.dotnet" >> $HOME/.bashrc && \
echo "export PATH=\$PATH:\$HOME/.dotnet:\$HOME/.dotnet/tools" >> $HOME/.bashrc && \
echo "" >> $HOME/.bashrc && \
echo "# pyenv" >> $HOME/.bashrc && \
echo "export PYENV_ROOT=\$HOME/.pyenv" >> $HOME/.bashrc && \
echo "export PATH=\$PYENV_ROOT/bin:\$PATH" >> $HOME/.bashrc && \
echo "eval \"\$(pyenv init -)\"" >> $HOME/.bashrc && \
echo "" >> $HOME/.bashrc && \
echo "# nvm" >> $HOME/.bashrc && \
echo "export NVM_DIR=\$HOME/.nvm" >> $HOME/.bashrc && \
echo "[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"" >> $HOME/.bashrc && \
echo "[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"" >> $HOME/.bashrc && \
echo "export PATH=\$NVM_DIR:\$PATH" >> $HOME/.bashrc && \
echo "" >> $HOME/.bashrc
sudo apt install -y make build-essential libssl-dev \
zlib1g-dev libreadline-dev libsqlite3-dev wget curl \
llvm libncursesw5-dev xz-utils tk-dev libxml2-dev \
unzip libxmlsec1-dev libffi-dev liblzma-dev neovim \
git gh
sudo wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh
sudo chmod +x ./dotnet-install.sh
for v in "${dotnet_versions[@]}"; do
    ./dotnet-install.sh --channel $v
done
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v$nvm_version/install.sh" | bash
curl -fsSL https://bun.com/install | bash
curl https://pyenv.run | bash
curl -OL "https://go.dev/dl/go$go_version.linux-arm64.tar.gz"
sudo tar -C /usr/local -xzf "go$go_version.linux-arm64.tar.gz"
rm "go$go_version.linux-arm64.tar.gz"
