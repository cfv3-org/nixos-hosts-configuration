# NixOS Configuration

This repository contains my personal **NixOS** setup managed via [`flake.nix`](flake.nix) and [`home-manager`](https://github.com/nix-community/home-manager).  
The configuration is modular and designed to be reproducible on different hosts.

---

## Hosts

### 🖥️ `workstation`

**Purpose:**  
Main development machine for writing code, running containers, and managing projects and games.

**Key points:**
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
sudo nixos-rebuild switch --flake .#t1
```

### 2. Update inputs (nixpkgs, home-manager, etc.)
```bash
nix flake update
```

---
