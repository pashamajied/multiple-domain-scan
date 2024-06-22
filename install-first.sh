#!/bin/bash

clear

# Version variables
VERSION_SUBFINDER="2.6.6"
VERSION_HTTPX="1.6.3"
VERSION_NUCLEI="3.2.9"
VERSION_GAU="2.2.3"
VERSION_CENT="1.3.4"

# Check and install a package if it's not installed
check_and_install() {
  command -v "$1" &>/dev/null || sudo apt install -y "$1" || sudo yum install -y "$1" || sudo zypper install -y "$1"
}

# Download and install based on architecture
download_and_install() {
  case "$(uname -s)_$(uname -m)" in
    Linux_i386)   SUFFIX="_linux_386" ;;
    Linux_x86_64) SUFFIX="_linux_amd64" ;;
    Linux_arm)    SUFFIX="_linux_arm" ;;
    Linux_aarch64)SUFFIX="_linux_arm64" ;;
    *) echo "Unsupported OS or architecture"; exit 1 ;;
  esac

  BASE_URL="https://github.com"
  FILES=(
    "projectdiscovery/subfinder/releases/download/v$VERSION_SUBFINDER/subfinder_$VERSION_SUBFINDER$SUFFIX.zip"
    "projectdiscovery/httpx/releases/download/v$VERSION_HTTPX/httpx_$VERSION_HTTPX$SUFFIX.zip"
    "projectdiscovery/nuclei/releases/download/v$VERSION_NUCLEI/nuclei_$VERSION_NUCLEI$SUFFIX.zip"
    "lc/gau/releases/download/v$VERSION_GAU/gau_$VERSION_GAU$SUFFIX.tar.gz"
    "xm1k3/cent/releases/download/v$VERSION_CENT/cent_$VERSION_CENT$SUFFIX.zip"
  )

  for FILE in "${FILES[@]}"; do
    wget -q "$BASE_URL/$FILE" -P /tmp
  done

  unzip -q "/tmp/subfinder_$VERSION_SUBFINDER$SUFFIX.zip" -d /tmp
  unzip -q "/tmp/httpx_$VERSION_HTTPX$SUFFIX.zip" -d /tmp
  unzip -q "/tmp/nuclei_$VERSION_NUCLEI$SUFFIX.zip" -d /tmp
  tar -xzf "/tmp/gau_$VERSION_GAU$SUFFIX.tar.gz" -C /tmp
  unzip -q "/tmp/cent_$VERSION_CENT$SUFFIX.zip" -d /tmp

  sudo cp /tmp/subfinder /tmp/httpx /tmp/nuclei /tmp/gau /tmp/cent /usr/local/bin/
  echo "All files downloaded and installed successfully."
}

# Install runm with or without Telegram bot
install_runm() {
  URL="https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/runm-${1}-bot-telegram.txt"
  wget -q "$URL" -O /usr/local/bin/runm
  chmod +x /usr/local/bin/runm
  if [ "$1" == "bot" ]; then
    read -p "Enter YOUR_CHAT_ID: " chat_id
    read -p "Enter YOUR_BOT_TOKEN: " bot_token
    sudo sed -i "s/YOUR_CHAT_ID/$chat_id/g; s/YOUR_BOT_TOKEN/$bot_token/g" /usr/local/bin/runm
  fi
  echo "runm installed successfully."
}

# Check and install required packages
for pkg in unzip wget curl; do check_and_install "$pkg"; done

# Choose option for runm installation
read -p "Choose option (1. Send to Telegram bot, 2. Do not send to Telegram bot): " choice
[ "$choice" == "1" ] && install_runm "bot" || install_runm "no"

download_and_install
