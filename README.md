# Nix Packages

Public Nix packages maintained by IdleForge.

## Development

Enter the repository-owned environment through direnv or Nix:

```bash
direnv allow

```

Run the complete local and CI contract:

```bash
./scripts/validate
```

The same validation runs through `nix flake check`. `repository-structure check` validates generic repository ownership and placement boundaries; infrastructure control planes keep topology semantics such as profile assignment and root composition in their own domain validation. Project dependencies belong in `Cargo.toml` and the declared `Cargo.lock` policy; workstation configuration does not supply them.




Documentation validation is file-aware. JSON, YAML, TOML, JSON Schema, and GitHub Actions checks run only when matching files exist:

```bash
./scripts/check-content
```

Internal Markdown links are part of deterministic offline validation:

```bash
./scripts/check-links internal
```

External link availability is intentionally separate because it requires network access and can change independently of repository state:

```bash
VALIDATION_NETWORK=enabled ./scripts/check-links external
```

Normal `./scripts/validate` and `nix flake check` never enable network link checking.



## Release units

`release-units.json` is the repository-owned release plan. This repository uses the `single` model. A release unit is the smallest product that can be selected, deployed, observed, and rolled back independently. Artifact variants such as Linux Nix outputs, Windows packages, APKs, VSIX files, OCI archives, and exported bundles belong inside that semantic unit rather than becoming separate products by packaging format alone.


The repository exposes these generic Nix product boundaries:






- `packages.x86_64-linux.default`




## Fleet local iteration

When Fleet installs this product, validate a complete current-machine generation from the source checkout:

```bash
fleet release local apply --source .
fleet release local status
fleet release local check
fleet release local rollback
fleet release local clear --source .
```

Fleet resolves this repository by Git origin and composes the complete generation. The repository does not select Fleet input names, switch Home Manager directly, or own machine placement.

## Product publication

After `./scripts/validate` and Fleet local iteration pass, commit and `git push` the accepted owner revision before publication. Publish the default product with:

```bash
fleet release publish --source .
```


Fleet builds the clean pushed product on its declared release builder and publishes the immutable result to Attic. Publication does not update Fleet desired state and does not activate any machine. Product repositories do not hold Attic credentials or know builder or VPS topology.

## Fleet pin adoption and deployment

Successful publication hands the immutable owner revision to Fleet. Renovate proposes the immutable owner revision update in Fleet, and Fleet CI evaluates the complete affected generations. After the Fleet change is accepted, deployment remains a Fleet operation:

```bash
fleet release deploy --target <machine>
```

GitSync refreshes the accepted Fleet checkout; it does not activate machines. The reconciliation controller or target agent converges the merged complete generation. Until the generic Renovate owner-pin proposal path is available and validated, an operator may perform the equivalent Fleet-owned pin update as a transitional step. Manual Fleet pin editing from this repository is not the canonical path.


Inspect producer provenance for the first declared unit with:

```bash
./scripts/provenance nix-packages
```

Produce the durable owner declaration from a clean checkout after canonical validation with:

```bash
BUILD_TIMESTAMP=2026-08-26T12:00:00Z PRODUCT_VERSION=0.1.0 ./scripts/release-declaration --require-clean nix-packages
```

The declaration uses `idleforge.product-provenance/v1` and `idleforge.owner-release/v1`. Nix-capable variants resolve derivation, store path, NAR hash, and closure identity. Exported variants record file digest and size; preserved external artifacts also retain upstream source/version/digest and an explicit exemption explaining that this repository does not build upstream.

The repository owns release semantics and evidence, not distribution policy. Do not add machine topology, Attic credentials, target deployment commands, or Fleet approval state to `release-units.json`. Fleet may consume the declaration, publish immutable artifacts, approve a release, deploy it, observe it, or select an earlier identity for rollback. Artifact availability in Attic is not approval, and an optional product channel is not a Git branch or Fleet deployment decision.


Markdown quality uses one repository-neutral baseline. Check logical prose lines and objective style rules across all tracked Markdown with:

```bash
markdown-prose check
```

Apply deterministic fixes explicitly with:

```bash
markdown-prose fix
```

`markdown-prose` removes non-semantic hard wraps and normalizes curly quotes. It reports em dashes for manual punctuation choices, preserves Markdown syntax such as code, fences, and tables, and deliberately does not pattern-match stock phrases, vocabulary, tone, or other subjective AI-writing signals. Generated or projected Markdown listed in `.markdown-prose.toml` is never rewritten; repair it at its canonical source or through its owning generator.

## License

MIT
