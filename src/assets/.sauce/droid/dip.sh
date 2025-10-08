#!/bin/bash

dotnet_versions=("9.0" "10.0")
nvm_version="0.40.3"
go_version="1.25.1"

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

# pyenv
export PYENV_ROOT=$HOME/.pyenv
export PATH=$PYENV_ROOT/bin:$PATH
eval "$(pyenv init -)"

# nvm
export NVM_DIR=$HOME/.nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh\"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
export PATH=$NVM_DIR:$PATH
'
echo $profile >> $HOME/.bashrc
zshrc='
export PATH=$PATH:$HOME/.local/bin
eval "$(oh-my-posh init zsh --config $HOME/.sauce/themes/sauce.ohmyposh.toml)"
'
sauce_omp='
#:schema https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json

version = 3

[transient_prompt]
template = "{{ now | date \"15:04:05\" }} ❯ "
foreground = "magenta"
background = "transparent"

[[blocks]]
type = "prompt"
alignment = "left"
newline = true

[[blocks.segments]]
template = "{{ if gt .Code 0 }}<#ff0000></>{{ else }}<#23d18b></>{{ end }} "
type = "status"
style = "plain"

[blocks.segments.properties]
always_enabled = true
cache_duration = "none"

[[blocks.segments]]
template = " took  {{ .FormattedMs }} "
foreground = "yellow"
type = "executiontime"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"
threshold = 10.0

[[blocks]]
type = "prompt"
alignment = "left"
newline = true

[[blocks.segments]]
template = "{{ if .WSL }}WSL at {{ end }}{{.Icon}} "
foreground = "cyan"
type = "os"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"

[[blocks.segments]]
template = " {{ .UserName }}@{{ .HostName }} "
foreground = "cyan"
type = "session"
style = "diamond"

[blocks.segments.properties]
cache_duration = "none"

[[blocks.segments]]
template = "{{ .UpstreamIcon }}{{ .HEAD }}{{if .BranchStatus }} {{ .BranchStatus }}{{ end }}{{ if .Working.Changed }}  {{ .Working.String }}{{ end }}{{ if and (.Working.Changed) (.Staging.Changed) }} |{{ end }}{{ if .Staging.Changed }}  {{ .Staging.String }}{{ end }}{{ if gt .StashCount 0 }}  {{ .StashCount }}{{ end }} "
foreground = "#FFE700"
type = "git"
style = "plain"
foreground_templates = [
  "{{ if and (gt .Ahead 0) (gt .Behind 0) }}#FFCC80{{ end }}",
  "{{ if gt .Ahead 0 }}#16c60c{{ end }}",
  "{{ if gt .Behind 0 }}#f450de{{ end }}",
]

[blocks.segments.properties]
cache_duration = "none"
fetch_status = true
fetch_upstream_icon = true

[[blocks]]
type = "prompt"
alignment = "right"

[[blocks.segments]]
template = "  {{ .Full }} "
foreground = "cyan"
type = "dotnet"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"

[[blocks.segments]]
template = "  {{ .Full }} "
foreground = "cyan"
type = "go"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"

[[blocks.segments]]
template = "  ({{ if .Error }}{{ .Error }}{{ else }}{{ if .Venv }}{{ .Venv }} {{ end }}{{ .Major }}.{{ .Minor }}{{ end }}) "
foreground = "#ffd343"
type = "python"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"

[[blocks.segments]]
template = "  {{ .Full }} "
foreground = "#6CA35E"
type = "node"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"

[[blocks.segments]]
template = "  {{ .Full }} "
foreground = "#f80000"
type = "java"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"

[[blocks]]
type = "prompt"
alignment = "left"
newline = true

[[blocks.segments]]
template = "{{ .Path }} "
foreground = "cyan"
type = "path"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"
style = "full"

[[blocks.segments]]
template = "❯ "
foreground = "green"
type = "text"
style = "plain"

[blocks.segments.properties]
cache_duration = "none"
'
theme_dir="$HOME/.sauce/themes"
sudo apt install zsh
sudo mkdir -p $theme_dir
echo $sauce_omp > $theme_dir/sauce.ohmyposh.toml
echo "$zshrc $profile" > .zshrc
sudo chsh $(whoami) -s /usr/bin/zsh
curl -s https://ohmyposh.dev/install.sh | bash -s
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
