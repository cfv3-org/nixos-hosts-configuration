SHELL := /usr/bin/env bash

HOST ?= t1

.PHONY: t1
t1:
	sudo nixos-rebuild switch --flake .#t1

.PHONY: rebuild
rebuild:
	sudo nixos-rebuild switch --flake .#$(HOST)

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake .#$(HOST)

.PHONY: dry
dry:
	nixos-rebuild dry-activate --flake .#$(HOST)

health:
	@echo "🔍 Checking system health..."
	@echo "----------------------------------------"
	@echo "🟦 Systemd failed units:"
	@systemctl --failed || true
	@echo "----------------------------------------"
	@echo "🟥 Kernel / system errors (journalctl -b -p err):"
	@journalctl -b -p err --no-pager || true
	@echo "----------------------------------------"
	@echo "🟧 AMD GPU info (lsmod | grep amdgpu):"
	@lsmod | grep amdgpu || echo "amdgpu module not loaded"
	@echo "----------------------------------------"
	@echo "🟨 ROCm GPU support (rocminfo | grep gfx):"
	@rocminfo | grep gfx || echo "ROCm GPU not detected"
	@echo "----------------------------------------"
	@echo "🟩 Vulkan test:"
	@vulkaninfo | head -n 20 2>/dev/null || echo "vulkaninfo not available"
	@echo "----------------------------------------"
	@echo "🟪 VAAPI test (vainfo):"
	@vainfo 2>/dev/null || echo "vainfo not available"
	@echo "----------------------------------------"
	@echo "🟫 Check PipeWire:"
	@systemctl --user status pipewire --no-pager || true
	@echo "----------------------------------------"
	@echo "⬛ Check Display Manager:"
	@systemctl status display-manager --no-pager || true
	@echo "----------------------------------------"
	@echo "⚙️  GPU status via rocm-smi:"
	@rocm-smi || echo "rocm-smi not available"
	@echo "----------------------------------------"
	@echo "✅ Health check complete."
