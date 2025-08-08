# NixOS Configuration

This repository contains my personal **NixOS** setup managed via [`flake.nix`](flake.nix) and [`home-manager`](https://github.com/nix-community/home-manager).  
The configuration is modular and designed to be reproducible on different hosts.

---

## Hosts

### 🖥️ `workbench`

**Purpose:**  
Remote development machine for writing code, running containers, and managing projects.

**Key points:**
- **Remote access** enabled via `OpenSSH`.
- **Docker** and related tools pre-installed.
- **Zsh** as the default shell.
- **Mounted NAS storage**:  
  All projects are stored on a **home NAS** via NFS (`/home/vasary/projects`).  
  This ensures that source code and important data are **safe, backed up, and available from any device**.
- Pre-installed developer tools: `git`, `kubectl`, `helm`, `docker-compose`, `werf`, `talosctl`, `jq`, `yq`, `direnv`, etc.

---

## 🛠 Usage

### 1. Build and switch to configuration
```bash
sudo nixos-rebuild switch --flake .#workbench
```

### 2. Update inputs (nixpkgs, home-manager, vscode-server, etc.)
```bash
nix flake update
```

### 3. SSH into `workbench`

#### There are two connection options:
```bash
# direct connection from home network

Host coding-machine
  HostName IP-ADDRESS
  User vasary
  IdentityFile ~/.ssh/id_rsa
```
```bash
# proxified connection from public network via zerotrust tunnel

Host workbench
  HostName workbench.domain.name
  User vasary
  IdentityFile ~/.ssh/id_rsa
  ProxyCommand cloudflared access ssh --hostname %h
```
```bash
ssh vasary@<workbench-ip>
```
---

## 📂 Repository Structure
```
.
├── flake.nix                  # Main flake definition
├── hosts/
│   └── workbench/
│       └── workspace/
│           └── configuration.nix  # NixOS config for 'workbench'
├── home/
│   └── vasary/
│       └── home.nix            # Home Manager config for user 'vasary'
```

---

## 🔒 Security Notes
- **Password authentication** is disabled for SSH — only public key authentication is allowed.
- `sudo` for the `wheel` group does **not** require a password for convenience, but consider changing it for stricter environments.

---

## 📌 Roadmap
- [x] Make `workbench`
- [ ] Add `ci-runner`
- [ ] Load SSH keys from config

---
