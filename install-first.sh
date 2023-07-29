#!/bin/bash

VERSION_SUBFINDER="2.6.0"
VERSION_HTTPX="1.3.3"
VERSION_NUCLEI="2.9.9"

# Function to check if a package is installed and install it if needed
function check_and_install() {
  command -v "$1" &>/dev/null || (sudo apt install -y "$1" || sudo yum install -y "$1" || sudo zypper install -y "$1") && echo "$1 installed successfully."
}

# Function to download and install files based on architecture (AMD or ARM)
function download_and_install() {
  ARCH=$(uname -m)
  if [ "$ARCH" == "x86_64" ]; then
    ARCH_SUFFIX="_linux_amd64"
  else
    ARCH_SUFFIX="_linux_arm64"
  fi

  wget "https://github.com/projectdiscovery/subfinder/releases/download/v$VERSION_SUBFINDER/subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip"
  wget "https://github.com/projectdiscovery/httpx/releases/download/v$VERSION_HTTPX/httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip"
  wget "https://github.com/projectdiscovery/nuclei/releases/download/v$VERSION_NUCLEI/nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip"

  unzip "subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip"
  unzip "httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip"
  unzip "nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip"

  sudo cp subfinder httpx nuclei /usr/local/bin/
  echo "All files downloaded and installed successfully."
}

# Function to install runm based on user choice
function install_runm() {
  DESTINATION="/usr/local/bin/runm"

  if [ "$1" == "1" ]; then
    URL="https://tools.pashamajied.com/runm-bot-telegram.txt"
  elif [ "$1" == "2" ]; then
    URL="https://tools.pashamajied.com/runm-no-bot-telegram.txt"
  else
    echo "Invalid choice. Please choose either 1 or 2."
    read -p "Enter your choice (1 or 2): " choice
    install_runm "$choice"
    return
  fi

  wget "$URL" -O "$DESTINATION"
  chmod +x "$DESTINATION"

  echo "The file runm.txt has been downloaded and saved to $DESTINATION with execution permission."
}

# Function to replace placeholders with user input
function replace_values() {
  sed -i "s/YOUR_CHAT_ID/$1/g" /usr/local/bin/runm
  sed -i "s/YOUR_BOT_TOKEN/$2/g" /usr/local/bin/runm
}

check_and_install "unzip"
check_and_install "wget"
check_and_install "curl"

echo "All required packages are installed."

echo "Choose one option:"
echo "1. Send to Telegram bot"
echo "2. Do not send to Telegram bot"

read -p "Enter your choice (1 or 2): " choice

install_runm "$choice"

download_and_install
