# Nix packages

Standalone Nix packages tailored to IdleForge. Packages may include changes to upstream source.

Internal work is tracked in Beads. GitHub Issues and Projects are disabled.

## Development

```bash
nix develop
./scripts/validate
nix flake check
```

Validation checks Nix formatting and lint, shell scripts, Markdown prose, local links, structured content, and GitHub Actions. Run `./scripts/markdown-prose fix` or `nix fmt .` to apply formatting explicitly. External links require `VALIDATION_NETWORK=enabled ./scripts/check-links external`.

The locked Nix development shell provides all repository validation and build tools on entry. `direnv` uses the same shell after the operator authorizes `.envrc`; fallback to host tools is disabled. `IDLEFORGE_DEPENDENCY_CLOSURE` identifies the immutable, lock-keyed development tool closure, shared by checkouts and worktrees. Its contents are read-only and no checkout dependency installation or writable projection is needed.

This repository has no native Python, Node, Rust, Go, or Gradle project manifests or dependency locks. The embedded Python Markdown checker is a script that uses the Nix-provided interpreter. `flake.lock` is the only dependency lock. The pinned development tools include Nix, Git and GitHub CLI, Worktrunk, Bash, Python, JSON/YAML/TOML/schema validators, ShellCheck, actionlint, statix, nixfmt, lychee, and utilities used by the validation and release-declaration scripts. External link checks require network access and are not part of offline canonical validation. Package publication and Fleet deployment remain separate workflows.

## License

MIT
