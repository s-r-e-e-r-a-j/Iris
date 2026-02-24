#!/usr/bin/env bash

# Developer: Sreeraj
# GitHub: https://github.com/s-r-e-e-r-a-j

set -e

APP_NAME="iris"
BIN_DIR="/usr/local/bin"

echo "Detecting package manager..."

# Detect package manager
if command -v apt >/dev/null; then
    PM="apt"
elif command -v pacman >/dev/null; then
    PM="pacman"
elif command -v dnf >/dev/null; then
    PM="dnf"
elif command -v yum >/dev/null; then
    PM="yum"
else
    echo "Unsupported package manager. Please install dependencies manually."
    exit 1
fi

echo "Package manager detected: $PM"

# Install dependencies
install_deps_debian() {
    sudo apt update
    sudo apt install -y build-essential gcc pkg-config libsdl2-dev libsdl2-image-dev
}

install_deps_arch() {
    sudo pacman -Syu --noconfirm base-devel sdl2 sdl2_image
}

install_deps_rhel() {
    sudo $PM install -y gcc make pkgconfig SDL2-devel SDL2_image-devel
}

case $PM in
    apt) install_deps_debian ;;
    pacman) install_deps_arch ;;
    dnf|yum) install_deps_rhel ;;
esac

echo "Building $APP_NAME..."
make

if [ ! -f "$APP_NAME" ]; then
    echo "Build failed: $APP_NAME binary not found!"
    exit 1
fi

echo "Installing $APP_NAME to $BIN_DIR..."
sudo cp "$APP_NAME" "$BIN_DIR/"
sudo chmod +x "$BIN_DIR/$APP_NAME"

echo "$APP_NAME installed successfully!"
echo "You can now run it using: $APP_NAME <image1> [image2 ...]"
