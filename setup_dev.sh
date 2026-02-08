#!/bin/bash

# Ensure script stops on first error
set -e

echo "Updating system and installing base dependencies..."
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common unzip git lsb-release
sudo mkdir -p -m 755 /etc/apt/keyrings

# 1. Google Cloud CLI
echo "Installing Google Cloud CLI..."
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg
echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update
sudo apt install -y google-cloud-cli

# 2. Kubectl v1.35
echo "Installing Kubectl v1.35..."
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.35/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.35/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl

# 3. OpenTofu
echo "Installing OpenTofu..."
curl --proto '=https' --tlsv1.2 -fsSL https://get.opentofu.org/install-opentofu.sh -o install-opentofu.sh
chmod +x install-opentofu.sh
./install-opentofu.sh --install-method deb
rm install-opentofu.sh

# 4. Podman and system aliases
echo "Installing Podman..."
sudo apt update
sudo apt install -y podman

echo "Setting up shell aliases for bash and zsh..."
for RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
    if [ -f "$RC" ]; then
        # Check if aliases already exist to avoid duplicates
        grep -q "alias docker=podman" "$RC" || echo "alias docker=podman" >> "$RC"
        grep -q "alias k=kubectl" "$RC" || echo "alias k=kubectl" >> "$RC"
        grep -q "complete -F __start_kubectl k" "$RC" || echo "complete -F __start_kubectl k" >> "$RC"
    fi
done

# 5. AWS CLI v2
echo "Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip

echo "Installation complete. Please restart your shell or run 'source ~/.bashrc'."
