#!/bin/bash
# codenoid
# Script modified to include root check, curl check, Go version check, and PATH update option

# Check if the script is executed as root
if [[ $EUID -ne 0 ]]; then
   printf "This script must be run as root.\n"
   printf "Try 'sudo !!'. You'll thank me later.\n"
   exit 1
fi

# Check if curl is installed
if ! command -v curl &> /dev/null; then
    printf "Curl could not be found, installing...\n";
    apt install -y curl
else
    printf "Curl is already installed.\n"
fi

printf "Checking latest Go version...\n";
LATEST_GO_VERSION="$(curl --silent https://go.dev/VERSION?m=text | head -n 1)";
LATEST_GO_DOWNLOAD_URL="https://go.dev/dl/${LATEST_GO_VERSION}.linux-amd64.tar.gz"

# Check if Go is installed
if [ -d "/usr/local/go" ]; then
    printf "A Go version is already installed. Removing it...\n"
    rm -rfv /usr/local/go
else
    printf "No existing Go installation found.\n"
fi

printf "Downloading ${LATEST_GO_DOWNLOAD_URL}\n\n";
curl -OJL --progress-bar $LATEST_GO_DOWNLOAD_URL

printf "Extracting file...\n"
tar -C /usr/local -xzf ${LATEST_GO_VERSION}.linux-amd64.tar.gz
rm ${LATEST_GO_VERSION}.linux-amd64.tar.gz

# Ask user to add Go PATH to /etc/environment
read -p "Do you want to add Go PATH to your /etc/environment? [Y/n] " response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])+$ ]]
then
    if ! grep -q "/usr/local/go/bin" /etc/environment; then
        echo "Adding Go PATH to /etc/environment"
        echo "PATH=\"$PATH:/usr/local/go/bin\"" >> /etc/environment
        # Apply changes without needing a reboot
        source /etc/environment
    else
        printf "Go PATH already exists in /etc/environment\n"
    fi
else
    printf "Skipping PATH addition to /etc/environment\n"
fi

export PATH=$PATH:/usr/local/go/bin

printf "You are ready to Go!\n\n";
go version
