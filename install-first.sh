#!/bin/bash

clear

VERSION_SUBFINDER="2.6.4"
VERSION_HTTPX="1.3.8"
VERSION_NUCLEI="3.1.6"

# Function to check if a package is installed and install it if needed
function check_and_install() {
  command -v "$1" &>/dev/null || (sudo apt install -y "$1" || sudo yum install -y "$1" || sudo zypper install -y "$1") && echo "$1 installed successfully."
}

# Function to download and install files based on architecture (AMD or ARM)
function download_and_install() {
  OS=$(uname -s)
  ARCH=$(uname -m)

  case "$OS" in
    "Linux")
      case "$ARCH" in
        "i386")
          ARCH_SUFFIX="_linux_386"
          ;;
        "x86_64")
          ARCH_SUFFIX="_linux_amd64"
          ;;
        "arm")
          ARCH_SUFFIX="_linux_arm"
          ;;
        "aarch64")
          ARCH_SUFFIX="_linux_arm64"
          ;;
        *)
          echo "Unsupported architecture: $ARCH"
          exit 1
          ;;
      esac
      ;;
    "Darwin")
      case "$ARCH" in
        "x86_64")
          ARCH_SUFFIX="_macOS_amd64"
          ;;
        "arm64")
          ARCH_SUFFIX="_macOS_arm64"
          ;;
        *)
          echo "Unsupported architecture: $ARCH"
          exit 1
          ;;
      esac
      ;;
    "Windows")
      case "$ARCH" in
        "i386")
          ARCH_SUFFIX="_windows_386"
          ;;
        "x86_64")
          ARCH_SUFFIX="_windows_amd64"
          ;;
        "arm64")
          ARCH_SUFFIX="_windows_arm64"
          ;;
        *)
          echo "Unsupported architecture: $ARCH"
          exit 1
          ;;
      esac
      ;;
    *)
      echo "Unsupported operating system: $OS"
      exit 1
      ;;
  esac

  wget -q "https://github.com/projectdiscovery/subfinder/releases/download/v$VERSION_SUBFINDER/subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip"
  wget -q "https://github.com/projectdiscovery/httpx/releases/download/v$VERSION_HTTPX/httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip"
  wget -q "https://github.com/projectdiscovery/nuclei/releases/download/v$VERSION_NUCLEI/nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip"

  unzip -q "subfinder_$VERSION_SUBFINDER$ARCH_SUFFIX.zip"
  unzip -q "httpx_$VERSION_HTTPX$ARCH_SUFFIX.zip"
  unzip -q "nuclei_$VERSION_NUCLEI$ARCH_SUFFIX.zip"

  sudo cp subfinder httpx nuclei /usr/local/bin/
  echo "All files downloaded and installed successfully."
}

# Function to install runm with or without Telegram bot
function install_runm() {
  DESTINATION="/usr/local/bin/runm"

  if [ "$choice" == "1" ]; then
    URL="https://github.com/pashamajied/multiple-domain-scan/blob/main/runm-bot-telegram.txt"
    wget -q "$URL" -O "$DESTINATION"
    chmod +x "$DESTINATION"
    read -p "Enter YOUR_CHAT_ID: " chat_id
    read -p "Enter YOUR_BOT_TOKEN: " bot_token
    replace_values "$chat_id" "$bot_token"
    echo "The file runm.txt has been downloaded and saved to $DESTINATION with execution permission."
  elif [ "$choice" == "2" ]; then
    URL="https://raw.githubusercontent.com/pashamajied/multiple-domain-scan/main/runm-no-bot-telegram.txt"
    wget -q "$URL" -O "$DESTINATION"
    chmod +x "$DESTINATION"
    echo "The file runm.txt has been downloaded and saved to $DESTINATION with execution permission."
  else
    echo "Invalid choice. Exiting..."
    exit 1
  fi
}

# Function to replace placeholders with user input
function replace_values() {
  if [ ! -w "/usr/local/bin/runm" ]; then
    echo "Error: Insufficient permissions to edit /usr/local/bin/runm. Please run the script with sudo."
    exit 1
  fi

  sudo sed -i "s/YOUR_CHAT_ID/$1/g" /usr/local/bin/runm
  sudo sed -i "s/YOUR_BOT_TOKEN/$2/g" /usr/local/bin/runm
  echo "YOUR_CHAT_ID and YOUR_BOT_TOKEN have been successfully replaced in the runm file."
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
