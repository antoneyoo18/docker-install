#!/bin/bash

# Display menu
show_menu() {
    clear
    echo "===== DOCKER MANAGER FOR UBUNTU ====="
    echo "1. Install Docker"
    echo "2. Remove Docker"
    echo "0. Exit"
    echo "===================================="
    echo -n "Enter your choice: "
}

# Function to install Docker
install_docker() {
    echo "Installing Docker..."

    # Update package index
    sudo apt-get update

    # Install prerequisites
    sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common gnupg

    # Add Docker's official GPG key
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

    # Set up the Docker repository
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Update package index with Docker repo
    sudo apt-get update

    # Install Docker
    sudo apt-get install -y docker-ce docker-ce-cli containerd.io

    # Add current user to docker group
    sudo usermod -aG docker "$USER"

    # Start and enable Docker
    sudo systemctl start docker
    sudo systemctl enable docker

    echo "Docker installed successfully!"
    echo "You may need to log out and log back in for user group changes to take effect."
    echo "Test with: docker run hello-world"

    read -p "Press Enter to continue..."
}

# Function to remove Docker
remove_docker() {
    echo "Removing Docker..."

    # Stop Docker service
    sudo systemctl stop docker

    # Remove Docker packages
    sudo apt-get purge -y docker-ce docker-ce-cli containerd.io

    # Remove Docker data and config
    sudo rm -rf /var/lib/docker
    sudo rm -rf /var/lib/containerd
    sudo rm -rf /etc/docker
    sudo rm -f /etc/apt/sources.list.d/docker.list
    sudo rm -f /usr/share/keyrings/docker-archive-keyring.gpg

    # Remove dependencies
    sudo apt-get autoremove -y

    echo "Docker has been completely removed from your system."

    read -p "Press Enter to continue..."
}

# Main script
while true; do
    show_menu
    read choice

    case "$choice" in
        1)
            install_docker
            ;;
        2)
            remove_docker
            ;;
        0)
            echo "Exiting..."
            exit 0
            ;;
        *)
            echo "Invalid option. Press Enter to continue..."
            read
            ;;
    esac
done
