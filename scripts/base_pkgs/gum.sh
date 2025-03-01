#!/bin/bash

echo "No ebuild for gum found in portage or GURU repos."
echo "Installing with Go..."

if ! command_exists "go"; then
    echo -e "${teal}No Go version found. Emerging latest version...${color_end}"
    sudo emerge --ask --noreplace "dev-lang/go"
fi

if [[ -e "$HOME/go/bin/gum" ]]; then
    echo -e "${green}gum already installed.${color_end}"
    echo -e "\n"
    exit 1
fi

echo -e "${cyan}Installing gum with `go install`...${color_end}"
go install "github.com/charmbracelet/gum@latest"
echo -e "\n"
