#!/bin/bash

go_version="1.26.4"

sudo apt update && sudo apt upgrade -y
curl -OL "https://go.dev/dl/go$go_version.linux-arm64.tar.gz"
sudo tar -C /usr/local -xzf "go$go_version.linux-arm64.tar.gz"
rm "go$go_version.linux-arm64.tar.gz"
