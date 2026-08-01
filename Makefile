SHELL := /usr/bin/env bash

HOST ?= t1
SECRETS_FILE ?= secrets/secrets.yaml
SECRETS_PLAIN_FILE ?= secrets/.decrypted.yaml
SOPS ?= sops

.DEFAULT_GOAL := help

.PHONY: help
help:
	@printf "\nVasary NixOS configuration\n\n"
	@printf "Usage:\n"
	@printf "  make <target> [HOST=t1]\n\n"
	@printf "System:\n"
	@printf "  %-18s %s\n" "t1" "Build the t1 host configuration for next boot"
	@printf "  %-18s %s\n" "switch" "Switch to the selected host configuration now"
	@printf "  %-18s %s\n" "rebuild" "Alias for switch"
	@printf "  %-18s %s\n" "boot" "Build and activate the selected host on next boot"
	@printf "  %-18s %s\n" "dry" "Dry-activate the selected host configuration"
	@printf "  %-18s %s\n" "update" "Update flake inputs"
	@printf "  %-18s %s\n" "clean-generations" "Delete old user and system generations"
	@printf "  %-18s %s\n" "optimise-store" "Deduplicate identical files in the Nix store"
	@printf "  %-18s %s\n" "clean-store" "Clean old generations and optimise the Nix store"
	@printf "  %-18s %s\n" "space" "Show disk usage hot spots"
	@printf "\nSecrets:\n"
	@printf "  %-18s %s\n" "secrets-edit" "Edit encrypted secrets with sops"
	@printf "  %-18s %s\n" "secrets-decrypt" "Write plaintext secrets to $(SECRETS_PLAIN_FILE)"
	@printf "  %-18s %s\n" "secrets-encrypt" "Encrypt $(SECRETS_PLAIN_FILE) back to $(SECRETS_FILE)"
	@printf "  %-18s %s\n" "secrets-clean" "Remove the plaintext secrets file"
	@printf "\nExamples:\n"
	@printf "  make switch HOST=t1\n"
	@printf "  make secrets-edit\n\n"

.PHONY: t1
t1:
	sudo nixos-rebuild boot --flake .#t1

.PHONY: update
update:
	nix flake update

.PHONY: switch
switch:
	sudo nixos-rebuild switch --flake .#$(HOST)

.PHONY: rebuild
rebuild: switch

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake .#$(HOST)

.PHONY: dry
dry:
	nixos-rebuild dry-activate --flake .#$(HOST)

.PHONY: clean-generations
clean-generations:
	nix-collect-garbage -d
	sudo nix-collect-garbage -d

.PHONY: optimise-store
optimise-store:
	sudo nix store optimise

.PHONY: clean-store
clean-store: clean-generations optimise-store

.PHONY: space
space:
	@printf "\nLocal filesystem usage:\n"
	@df -hT \
		-x nfs -x nfs4 -x cifs -x smb3 -x fuse.sshfs \
		-x tmpfs -x devtmpfs -x efivarfs
	@printf "\nLargest directories under /:\n"
	@sudo du -xhd1 / 2>/dev/null | sort -h
	@printf "\nLargest directories under /var:\n"
	@sudo du -xhd1 /var 2>/dev/null | sort -h
	@printf "\nLargest directories under $$HOME:\n"
	@du -xhd1 "$$HOME" 2>/dev/null | sort -h
	@printf "\nLargest directories under $$HOME/.local:\n"
	@if [ -d "$$HOME/.local" ]; then du -xhd1 "$$HOME/.local" 2>/dev/null | sort -h; fi
	@printf "\nLargest directories under $$HOME/.config:\n"
	@if [ -d "$$HOME/.config" ]; then du -xhd1 "$$HOME/.config" 2>/dev/null | sort -h; fi
	@printf "\nLargest directories under $$HOME/.cache:\n"
	@if [ -d "$$HOME/.cache" ]; then du -xhd1 "$$HOME/.cache" 2>/dev/null | sort -h; fi
	@printf "\nLargest directories under $$HOME/Projects:\n"
	@if [ -d "$$HOME/Projects" ]; then du -xhd1 "$$HOME/Projects" 2>/dev/null | sort -h; fi
	@printf "\nLargest directories under $$HOME/Downloads:\n"
	@if [ -d "$$HOME/Downloads" ]; then du -xhd1 "$$HOME/Downloads" 2>/dev/null | sort -h; fi
	@printf "\nLargest directories under /nix:\n"
	@sudo du -xhd1 /nix 2>/dev/null | sort -h

.PHONY: secrets-edit
secrets-edit:
	$(SOPS) $(SECRETS_FILE)

.PHONY: secrets-decrypt
secrets-decrypt:
	$(SOPS) --decrypt $(SECRETS_FILE) > $(SECRETS_PLAIN_FILE)
	chmod 600 $(SECRETS_PLAIN_FILE)
	@echo "Decrypted secrets written to $(SECRETS_PLAIN_FILE)"

.PHONY: secrets-encrypt
secrets-encrypt:
	test -f $(SECRETS_PLAIN_FILE)
	SOPS_AGE_KEY_FILE=$${SOPS_AGE_KEY_FILE:-$$HOME/.config/sops/age/keys.txt} \
		$(SOPS) --filename-override $(SECRETS_FILE) --encrypt --input-type yaml --output-type yaml $(SECRETS_PLAIN_FILE) > $(SECRETS_FILE)
	@echo "Encrypted $(SECRETS_PLAIN_FILE) into $(SECRETS_FILE)"

.PHONY: secrets-clean
secrets-clean:
	rm -f $(SECRETS_PLAIN_FILE)
