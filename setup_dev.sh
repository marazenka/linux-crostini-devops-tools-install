#!/bin/bash

# Ensure script stops on first error
set -e

echo "Updating system and installing base dependencies..."
sudo apt update
sudo apt install -y curl gnupg2 software-properties-common unzip git lsb-release python3-pip python3-venv
sudo mkdir -p -m 755 /etc/apt/keyrings

# 0. Ansible (Official PPA)
echo "Installing Ansible..."
sudo add-apt-repository --yes --update ppa:ansible/ansible
sudo apt install -y ansible

# 1. Google Cloud CLI
echo "Installing Google Cloud CLI..."
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo gpg --dearmor -o /etc/apt/keyrings/cloud.google.gpg
echo "deb [signed-by=/etc/apt/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
sudo apt update
sudo apt install -y google-cloud-cli
sudo apt install -y google-cloud-cli-gke-gcloud-auth-plugin

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
        echo "alias docker=podman" >> "$RC"
        echo "alias k=kubectl" >> "$RC"
        echo "alias tg=terragrunt" >> "$RC"
        echo "alias tf=tofu" >> "$RC"
        grep -q "kubectl completion" "$RC" || echo 'source <(kubectl completion bash)' >> "$RC"
    fi
done

# 5. AWS CLI v2
echo "Installing AWS CLI v2..."
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -q awscliv2.zip
sudo ./aws/install --update
rm -rf aws awscliv2.zip

# 6. Helm
echo "Installing Helm..."
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/refs/heads/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh
rm get_helm.sh

# 7. Terragrunt
echo "Installing Terragrunt..."
TG_VERSION=$(curl -s https://api.github.com/repos/gruntwork-io/terragrunt/releases/latest | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
curl -L "https://github.com/gruntwork-io/terragrunt/releases/download/${TG_VERSION}/terragrunt_linux_amd64" -o terragrunt
sudo chmod +x terragrunt
sudo mv terragrunt /usr/local/bin/terragrunt

# 8. Azure CLI                                                                                                                                                                                              │
echo "Installing Azure CLI..."
curl -sL https://packages.microsoft.com/keys/microsoft.asc | sudo gpg --dearmor -o /etc/apt/keyrings/microsoft.gpg
echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/azure-cli/ $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/azure-cli.list
sudo apt update
sudo apt install -y azure-cli

echo "Installation complete. Please restart your shell or run 'source ~/.bashrc'."
