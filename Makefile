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
