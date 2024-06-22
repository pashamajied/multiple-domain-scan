#!/bin/bash

clear

# Version variables
VERSION_SUBFINDER="2.6.6"
VERSION_HTTPX="1.6.3"
VERSION_NUCLEI="3.2.9"
VERSION_GAU="2.2.3"
VERSION_CENT="1.3.4"

# Base URL
BASE_URL="https://github.com"

# Function to check and install a package if it's not installed
check_and_install() {
  if ! command -v "$1" &> /dev/null; then
    echo "Installing $1..."
    sudo apt install -y "$1" || sudo yum install -y "$1" || sudo zypper install -y "$1" > /dev/null 2>&1
  fi
}

# Function to download and install based on architecture
download_and_install() {
  ARCH=$(uname -m)
  case "$ARCH" in
    "x86_64") ARCH_SUFFIX="_linux_amd64" ;;
    "i386") ARCH_SUFFIX="_linux_386" ;;
    "armv7l") ARCH_SUFFIX="_linux_arm" ;;
    "aarch64") ARCH_SUFFIX="_linux_arm64" ;;
    *)
      echo "Unsupported architecture: $ARCH"
      exit 1
      ;;
  esac

  FILES=(
    "$BASE_URL/projectdiscovery/subfinder/releases/download/v$VERSION_SUBFINDER/subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip"
    "$BASE_URL/projectdiscovery/httpx/releases/download/v$VERSION_HTTPX/httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip"
    "$BASE_URL/projectdiscovery/nuclei/releases/download/v$VERSION_NUCLEI/nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip"
    "$BASE_URL/lc/gau/releases/download/v$VERSION_GAU/gau_$VERSION_GAU$ARCH_SUFFIX.tar.gz"
    "$BASE_URL/xm1k3/cent/releases/download/v$VERSION_CENT/cent_$VERSION_CENT$ARCH_SUFFIX.zip"
  )

  for FILE in "${FILES[@]}"; do
    echo "Downloading $FILE..."
    wget -q "$FILE" -P /tmp > /dev/null 2>&1
  done

  echo "Unzipping and installing..."
  unzip -oq "/tmp/subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip" -d /tmp
  unzip -oq "/tmp/httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip" -d /tmp
  unzip -oq "/tmp/nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip" -d /tmp
  tar -xzf "/tmp/gau_$VERSION_GAU$ARCH_SUFFIX.tar.gz" -C /tmp
  unzip -oq "/tmp/cent_$VERSION_CENT$ARCH_SUFFIX.zip" -d /tmp

  sudo cp /tmp/{subfinder,httpx,nuclei,gau,cent} /usr/local/bin/ > /dev/null 2>&1
  echo "All files downloaded and installed successfully."
}

# Function to install runm with or without Telegram bot
install_runm() {
  local DESTINATION="/usr/local/bin/runm"
  local URL="https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/runm-${1}-bot-telegram.txt"

  echo "Downloading $URL..."
  wget -q "$URL" -O "$DESTINATION" > /dev/null 2>&1
  chmod +x "$DESTINATION"

  if [ "$1" == "bot" ]; then
    read -p "Enter YOUR_CHAT_ID: " chat_id
    read -p "Enter YOUR_BOT_TOKEN: " bot_token
    sudo sed -i "s/YOUR_CHAT_ID/$chat_id/g; s/YOUR_BOT_TOKEN/$bot_token/g" "$DESTINATION"
  fi

  echo "runm installed successfully."
}

# Check and install required packages
for pkg in unzip wget curl; do
  check_and_install "$pkg"
done
echo "All required packages are installed."

# Choose option for runm installation
echo "Choose one option:"
echo "1. Send to Telegram bot"
echo "2. Do not send to Telegram bot"
read -p "Enter your choice (1 or 2): " choice

if [ "$choice" == "1" ]; then
  install_runm "bot"
elif [ "$choice" == "2" ]; then
  install_runm "no"
else
  echo "Invalid choice. Exiting..."
  exit 1
fi

download_and_install
