#!/bin/bash

clear

# Version variables
VERSION_SUBFINDER="2.6.7"
VERSION_HTTPX="1.6.9"
VERSION_NUCLEI="3.3.7"
#VERSION_GAU="2.2.3"
#VERSION_CENT="1.3.4"

# Function to check and install a package if it's not installed
check_and_install() {
  if ! command -v "$1" &>/dev/null; then
    echo "Installing $1..."
    sudo apt install -y "$1" || sudo yum install -y "$1" || sudo zypper install -y "$1"
  fi
}

# Function to download and install based on architecture
download_and_install() {
  OS=$(uname -s)
  ARCH=$(uname -m)

  case "$OS" in
    "Linux")
      case "$ARCH" in
        "i386") ARCH_SUFFIX="_linux_386" ;;
        "x86_64") ARCH_SUFFIX="_linux_amd64" ;;
        "arm") ARCH_SUFFIX="_linux_arm" ;;
        "aarch64") ARCH_SUFFIX="_linux_arm64" ;;
        *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
      esac
      ;;
    "Darwin")
      case "$ARCH" in
        "x86_64") ARCH_SUFFIX="_macOS_amd64" ;;
        "arm64") ARCH_SUFFIX="_macOS_arm64" ;;
        *) echo "Unsupported architecture: $ARCH"; exit 1 ;;
      esac
      ;;
    *) echo "Unsupported operating system: $OS"; exit 1 ;;
  esac

  BASE_URL="https://github.com/"
  FILES=(
    "projectdiscovery/subfinder/releases/download/v$VERSION_SUBFINDER/subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip"
    "projectdiscovery/httpx/releases/download/v$VERSION_HTTPX/httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip"
    "projectdiscovery/nuclei/releases/download/v$VERSION_NUCLEI/nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip"
    #"lc/gau/releases/download/v$VERSION_GAU/gau_$VERSION_GAU$ARCH_SUFFIX.tar.gz"
    #"xm1k3/cent/releases/download/v$VERSION_CENT/cent_$VERSION_CENT$ARCH_SUFFIX.zip"
  )

  for FILE in "${FILES[@]}"; do
    echo "Downloading $FILE..."
    wget -q "$BASE_URL/$FILE" -P /tmp
  done

  echo "Unzipping and installing..."
  unzip -oq "/tmp/subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip" -d /tmp
  unzip -oq "/tmp/httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip" -d /tmp
  unzip -oq "/tmp/nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip" -d /tmp
  #tar -xzf "/tmp/gau_$VERSION_GAU$ARCH_SUFFIX.tar.gz" -C /tmp
  #unzip -oq "/tmp/cent_$VERSION_CENT$ARCH_SUFFIX.zip" -d /tmp

  sudo cp /tmp/subfinder /tmp/httpx /tmp/nuclei /tmp/gau /tmp/cent /usr/local/bin/
  echo "All files downloaded and installed successfully."
}

# Function to install runm with or without Telegram bot
install_runm() {
  local DESTINATION="/usr/local/bin/runm"
  local URL

  if [ "$1" == "1" ]; then
    URL="https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/runm-bot-telegram.txt"
    read -p "Enter YOUR_CHAT_ID: " chat_id
    read -p "Enter YOUR_BOT_TOKEN: " bot_token
  else
    URL="https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/runm-no-bot-telegram.txt"
  fi

  echo "Downloading $URL..."
  wget -q "$URL" -O "$DESTINATION"
  chmod +x "$DESTINATION"

  if [ "$1" == "1" ]; then
    sudo sed -i "s/YOUR_CHAT_ID/$chat_id/g; s/YOUR_BOT_TOKEN/$bot_token/g" "$DESTINATION"
  fi

  echo "runm installed successfully."
}

# Check and install required packages
for pkg in unzip wget curl; do check_and_install "$pkg"; done
echo "All required packages are installed."

# Choose option for runm installation
echo "Choose one option:"
echo "1. Send to Telegram bot"
echo "2. Do not send to Telegram bot"
read -p "Enter your choice (1 or 2): " choice

install_runm "$choice"
download_and_install
