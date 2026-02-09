# Linux Crostini DevOps Tools Installer

This script automates the installation of essential DevOps tools on a ChromeOS Linux (Crostini) environment. It's designed to get you up and running with a complete development environment quickly and easily.

## 🚀 Features

This script will install the following tools:

*   **Cloud CLIs:**
    *   `gcloud` (Google Cloud CLI)
    *   `aws` (AWS CLI v2)
*   **Containerization:**
    *   `kubectl` (Kubernetes command-line tool)
    *   `podman` (Daemonless container engine)
*   **Infrastructure as Code:**
    *   `tofu` (OpenTofu)

Additionally, it configures convenient shell aliases:
*   `docker` is aliased to `podman` for compatibility.
*   `k` is aliased to `kubectl` for quicker commands.

##  Prerequisites

*   A working ChromeOS Linux (Crostini) environment.
*   `curl` and `git` installed (the script will attempt to install them if missing).

## ⚙️ Usage

To use the script, open your Linux terminal and run the following commands:

1.  **Download the script:**
    ```bash
    curl "https://raw.githubusercontent.com/marazenka/linux-crostini-devops-tools-install/main/setup_dev.sh" -o "setup_dev.sh"
    ```

    **or if you have installed git:**
    ```bash
    git clone https://github.com/marazenka/linux-crostini-devops-tools-install.git
    cd linux-crostini-devops-tools-install
    ```

2.  **Make it executable:**
    ```bash
    chmod +x setup_dev.sh
    ```

3.  **Run the installer:**
    ```bash
    ./setup_dev.sh
    ```

The script will prompt for your password (`sudo`) to install the required packages.

##  After install

After the installation is complete, you need to restart your shell for the new aliases and PATH changes to take effect. You can do this by:

*   Closing and reopening your terminal.
*   Or by running `source ~/.bashrc` (or `source ~/.zshrc` if you use Zsh).
