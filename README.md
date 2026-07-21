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
- **Mounted storage** via systemd automount:
  `/mnt/NAS/Share` and `/mnt/NAS/Music`.
- Pre-installed developer tools: `git`, `kubectl`, `helm`, `helmfile`, `werf`, `talosctl`, `jq`, `yq`, `direnv`, etc.

---

## Installed Software

### Development
- Languages and toolchains: `go`, `gcc`, `nodejs`, `python3`, `pnpm`, `yarn`, Rust stable with `rust-src`, `rustfmt`, `clippy`, and `rust-analyzer`.
- IDEs and editors: JetBrains IDEA, DataGrip, PhpStorm, GoLand, WebStorm, RustRover, VS Code, Cursor, and Codex.
- Nix tooling: `nixfmt`, `nixfmt-tree`, `direnv`, and `nix-direnv`.
- API/dev tools: Postman, Git, Make, curl, wget, jq, yq.
- Kubernetes and infra: `kubectl`, `helm`, `helmfile`, `werf`, `talosctl`, `podman-compose`, Distrobox, Yandex Cloud CLI.

### Desktop Apps
- Browsers: Firefox with managed policies/extensions, Chromium with Bitwarden and Loom.
- Communication: Telegram Desktop, Signal, Zoom, ZapZap, Slack.
- Passwords and secrets: Bitwarden Desktop, SOPS tooling.
- Office and documents: LibreOffice, Geary, GNOME Calendar, OCR tools, scanner tools, PDF utilities.
- Media and hardware tools: Lollypop, webcam tools, Vulkan/Mesa tools.
- Gaming: Lutris with Battle.net tweaks, Wine staging, DXVK, VKD3D-Proton, MangoHud, Gamescope, GameMode, ProtonUp-Qt, Winetricks.
- Utilities: Black Box terminal, Obsidian, FileZilla, Bottles, Ventoy, Raspberry Pi Imager, RealVNC Viewer, Fastfetch, htop, eza, pavucontrol.

### GNOME Setup
- GNOME with GDM, fixed two-workspace layout, US/RU input switching, app indicators, clipboard indicator, quick settings tweaks, GSConnect, Vitals, network speed, and Bluetooth battery indicator.
- GNOME Online Accounts, Evolution Data Server, GNOME Keyring, KDE Connect, and GNOME browser connector are enabled.

---

## Background Services

### System Services
- `podman`: enabled with Docker compatibility, Docker socket, DNS-enabled default network, and auto-prune.
- `llamacpp`: systemd service for `llama-server`, exposed on `11435`; started manually with `llm-on`.
- MCP containers:
  `mcp-pihole`/`mcp-pihole-proxy` on `3100`,
  `mcp-paperless` on `3101`,
  `mcp-memory-service` on `3102`,
  `mcp-application-tracking` on `3103`,
  `mcp-sequential-thinking` on `3104`,
  and `mcp-mikrotik` on `3105`.
- Build helper services create local MCP container images for Paperless, Sequential Thinking, and MikroTik.
- PipeWire/WirePlumber provide ALSA, PulseAudio, and JACK audio.
- PipeWire filter-chain creates a "Noise Suppressed Microphone" source with RNNoise.
- NetworkManager, Bluetooth, printing, GDM/GNOME, KDE Connect, browser connector, rtkit, and WinBox firewall support are enabled.
- Journald retention is limited to 3 days.
- Home Manager generations auto-expire daily after 3 days.
- NAS mounts use systemd automount and idle timeouts.

### User Services
- `telegram.service`: starts Telegram in tray on graphical login.
- `zapzap.service`: starts ZapZap minimized on graphical login.
- `bitwarden.timer`: starts `bitwarden.service` 3 minutes after login, after GNOME Keyring is ready.
- `razer-mouse-defaults.service`: applies Razer mouse DPI and disables scroll-wheel lighting.
- `filter-chain.service`: starts the PipeWire RNNoise filter-chain.

---

## Useful Commands

### System
```bash
sudo nixos-rebuild switch --flake .#t1
nix flake update
```

### LLM Stack
```bash
llm-fetch-models     # Download/update configured GGUF models and ETag files
llm-on               # Start llama.cpp server
llm-off              # Stop llama.cpp server
llm-log              # Follow llama.cpp logs
```

Configured llama.cpp models are stored in `~/.config/llamacpp/models`:
- `ollama/qwen3.5:9b`
- `ollama/gemma4:12b` plus its `mmproj` file

Local endpoints:
- llama.cpp OpenAI-compatible API: `http://localhost:11435/v1`
- MCP streamable HTTP endpoints: `http://localhost:3100/mcp` through `http://localhost:3105/mcp`, depending on the service.

### Service Checks
```bash
systemctl status llamacpp
journalctl -u llamacpp -f -o cat
podman ps
systemctl --user status telegram zapzap bitwarden razer-mouse-defaults filter-chain
```

### Shell Aliases
```bash
k              # kubectl
ll             # eza --icons=always -l
docker-compose # podman-compose
```
