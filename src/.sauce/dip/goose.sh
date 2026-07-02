#!/bin/bash

go_version="1.26.4"

echo "📡 retrieving updates and dependencies..." 
sudo apt update && sudo apt upgrade -y
echo "✅ updates complete"
curl -OL "https://go.dev/dl/go$go_version.linux-arm64.tar.gz"
sudo tar -C /usr/local -xzf "go$go_version.linux-arm64.tar.gz"
rm "go$go_version.linux-arm64.tar.gz"
echo "✅ go installed" 

echo "📀 configuring dependencies..." 
GO_SYS_BIN="/usr/local/go/bin"
GO_USER_BIN="$HOME/go/bin"
SH_EXPORT_STRING='export PATH=$PATH:'"$GO_SYS_BIN:$GO_USER_BIN"
FISH_EXPORT_STRING="fish_add_path $GO_SYS_BIN $GO_USER_BIN"
SH_FILES=("$HOME/.bash_profile" "$HOME/.bashrc" "$HOME/.zshrc")
FISH_FILE="$HOME/.config/fish/config.fish"

echo "🔍 Scanning for shell configuration files..."
for FILE in "${SH_FILES[@]}"; do
    if [ -f "$FILE" ]; then
        if grep -qF "$SH_EXPORT_STRING" "$FILE"; then
            echo "✅ Go path already present in $FILE"
        else
            echo "" >> "$FILE"
            echo "# Go PATH setup" >> "$FILE"
            echo "$SH_EXPORT_STRING" >> "$FILE"
            echo "➕ Added Go path to $FILE"
        fi
        if [[ -n "$BASH_VERSION" && "$FILE" == *".bash"* ]]; then
            source "$FILE"
            echo "🔄 Reloaded $FILE for the current Bash session."
        fi
    fi
done

if [ -f "$FISH_FILE" ]; then
    if grep -qF "$FISH_EXPORT_STRING" "$FISH_FILE"; then
        echo "✅ Go path already present in $FISH_FILE"
    else
        echo "" >> "$FISH_FILE"
        echo "# Go PATH setup" >> "$FISH_FILE"
        echo "$FISH_EXPORT_STRING" >> "$FISH_FILE"
        echo "➕ Added Go path to $FISH_FILE"
    fi
    if [[ "$SHELL" == *"fish"* ]]; then
        echo "⚠️  Note: You are currently using Fish. To apply changes to this active terminal, run: source $FISH_FILE"
    fi
fi
echo "🚀 dependencies done ..."
echo "..." && sleep 2
echo "..." && sleep 3
echo "🪿 the goose is loose..."
echo "📀 greasing the goose"
go install github.com/codyconfer/goose
goose play