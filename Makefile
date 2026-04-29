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
	@printf "  %-18s %s\n" "t1" "Switch the t1 host configuration"
	@printf "  %-18s %s\n" "rebuild" "Switch the selected host configuration"
	@printf "  %-18s %s\n" "boot" "Build and activate the selected host on next boot"
	@printf "  %-18s %s\n" "dry" "Dry-activate the selected host configuration"
	@printf "  %-18s %s\n" "update" "Update flake inputs"
	@printf "\nSecrets:\n"
	@printf "  %-18s %s\n" "secrets-edit" "Edit encrypted secrets with sops"
	@printf "  %-18s %s\n" "secrets-decrypt" "Write plaintext secrets to $(SECRETS_PLAIN_FILE)"
	@printf "  %-18s %s\n" "secrets-encrypt" "Encrypt $(SECRETS_PLAIN_FILE) back to $(SECRETS_FILE)"
	@printf "  %-18s %s\n" "secrets-clean" "Remove the plaintext secrets file"
	@printf "\nExamples:\n"
	@printf "  make rebuild HOST=t1\n"
	@printf "  make secrets-edit\n\n"

.PHONY: t1
t1:
	sudo nixos-rebuild switch --flake .#t1

.PHONY: update
update:
	nix flake update

.PHONY: rebuild
rebuild:
	sudo nixos-rebuild switch --flake .#$(HOST)

.PHONY: boot
boot:
	sudo nixos-rebuild boot --flake .#$(HOST)

.PHONY: dry
dry:
	nixos-rebuild dry-activate --flake .#$(HOST)

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
