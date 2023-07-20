#!/bin/bash

# Function to check if a package is installed
is_installed() {
    dpkg -l | grep -q "^ii\s*$1"
}

# Function to install required packages if missing
install_packages() {
    local packages=("unzip" "wget" "curl")

    for package in "${packages[@]}"; do
        if ! is_installed "$package"; then
            sudo apt update
            sudo apt install -y "$package"
        fi
    done
}

# Function to download multiple files using wget
download_files() {
    wget https://github.com/projectdiscovery/subfinder/releases/download/v2.6.0/subfinder_2.6.0_linux_amd64.zip
    wget https://github.com/projectdiscovery/httpx/releases/download/v1.3.3/httpx_1.3.3_linux_amd64.zip
    wget https://github.com/projectdiscovery/nuclei/releases/download/v2.9.9/nuclei_2.9.9_linux_amd64.zip
}

# Function to unzip and copy files to /usr/local/bin/
install_files() {
    unzip subfinder_2.6.0_linux_amd64.zip
    sudo cp subfinder /usr/local/bin/

    unzip httpx_1.3.3_linux_amd64.zip
    sudo cp httpx /usr/local/bin/

    unzip nuclei_2.9.9_linux_amd64.zip
    sudo cp nuclei /usr/local/bin/
}

install_autoscan(){
tee /usr/local/bin/runm > /dev/null << 'EOF'
#!/bin/bash

# Set warna untuk output pesan
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo "### Scanning Subdomain and Directory with docker ### ";

#----------------------------------------
# telegram conf
#----------------------------------------
CHAT_ID=397331798
BOT_TOKEN=YOUR_BOT_TOKEN

# path to save result subfinder
LOCAL_PATH=/root/pentest

read -p "Masukkan daftar domain yang akan di-scan (pisahkan dengan spasi): " domains

# Convert domains into an array
read -ra DOMAIN_ARRAY <<< "$domains"

for domain in "${DOMAIN_ARRAY[@]}"; do
  if [ ! -d "$LOCAL_PATH/$domain/" ];
  then
    mkdir -p "$LOCAL_PATH/$domain/"
  fi

  # Menampilkan pesan bahwa proses scanning dimulai
  echo -e "${GREEN}Running...${NC}"
  echo ""

  # Menjalankan subdomain enumeration menggunakan subfinder
  echo -ne "${GREEN}Running subdomain enumeration for domain: $domain...${NC}"
  subfinder -d "$domain" -o "$LOCAL_PATH/$domain/output_$domain.txt" -silent > /dev/null
  echo -e "${GREEN} Done.${NC}"
  echo ""

  # Menjalankan penyaringan subdomain aktif menggunakan httpx
  echo -ne "${GREEN}Filtering active subdomains for domain: $domain...${NC}"
  httpx -l "$LOCAL_PATH/$domain/output_$domain.txt" -o "$LOCAL_PATH/$domain/active_$domain.txt" -silent -mc 200 > /dev/null
  echo -e "${GREEN} Done.${NC}"
  echo ""

  # Menjalankan vulnerability scanning menggunakan nuclei
  echo -ne "${GREEN}Scanning for vulnerabilities for domain: $domain...${NC}"
  nuclei -l "$LOCAL_PATH/$domain/active_$domain.txt" -es info -o "$LOCAL_PATH/$domain/nuclei_$domain.txt" &>/dev/null
  echo -e "${GREEN} Done.${NC}"
  echo ""

  echo -e "${GREEN}Scanning $domain selesai!${NC}"
  echo ""

  # Kirim output ke telegram
  TEXT="Result dirsearch your scan:%0A$(cat "$LOCAL_PATH/$domain/nuclei_$domain.txt")"
  curl -s -X POST -F document=@"$LOCAL_PATH/$domain/nuclei_$domain.txt" -F "chat_id=$CHAT_ID" "https://api.telegram.org/bot$BOT_TOKEN/sendDocument"
  echo ""
done

EOF
chmod +x /usr/local/bin/runm
    
}

main() {
    install_packages
    download_files
    install_files
    install_autoscan
    
    echo "Installation completed successfully!"
}

main

