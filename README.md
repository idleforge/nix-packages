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

## License

MIT
