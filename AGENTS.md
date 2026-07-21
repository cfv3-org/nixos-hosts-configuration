# AGENTS.md

## Project

- Personal NixOS flake with Home Manager.
- Host entrypoint: `hosts/t1/configuration.nix`.
- User entrypoint: `home/users/vasary/workstation.nix`.
- Home modules live in `home/modules/`; system modules live in `modules/`.
- Development tools should be split into focused files under `home/modules/development/` and imported explicitly.

## Editing

- Keep changes small and modular; follow existing patterns before adding new abstractions.
- Use `nixfmt` for changed Nix files.
- Do not rewrite unrelated files or revert user changes in a dirty worktree.
- Add new files referenced by flakes to the git index so Nix can evaluate them.
- Do not commit unless explicitly asked.

## Commits

- Commit only when explicitly requested.
- If the agent made code/config changes included in the commit, include an agent attribution trailer.
- Keep commits atomic: one logical change per commit.
- If the work starts crossing into a separate logical change, suggest committing or otherwise separating the current change before continuing.
- Prefer Conventional Commits: `type(scope): short imperative summary`.
- Common types: `feat`, `fix`, `refactor`, `chore`, `docs`, `test`.
- Keep the subject under 72 characters when practical; use the body for context and validation notes.
- Mention validation performed, or clearly state that validation was not run.

## Secrets

- Use SOPS-managed secrets for credentials, tokens, keys, and private endpoints.
- Never put plaintext secrets into Nix files, scripts, docs, logs, or examples.
- Keep secret references declarative and host/user scoped.
- If a secret value is needed but missing, add the expected secret path/key and mention what must be populated.

## Validation

- Do not build or dry-run the full system unless the user explicitly asks.
- Validate the changed scope first: format files, parse/evaluate touched modules, or run the narrowest relevant check.
- Full-system validation, when explicitly requested:

```bash
nix build .#nixosConfigurations.t1.config.system.build.toplevel --dry-run
```

- Report any check that could not be run.

## Safety

- Check `git status --short` before and after non-trivial edits.
- Avoid destructive commands unless the user explicitly requests them.
- Keep placeholder scripts simple and easy to replace.
