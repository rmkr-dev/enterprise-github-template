# Scripts

Shell tooling for **this template**. No Node/npm (ADR-004).

| Script | Role |
| --- | --- |
| [`validate-template.sh`](validate-template.sh) | Required-file, workflow hygiene, SECURITY/CHANGELOG/ADR, link, and supply-chain gates used by CI |
| [`extract-changelog-section.sh`](extract-changelog-section.sh) | Prints a Keep-a-Changelog `## [X.Y.Z]` body; used by `.github/workflows/release.yml` |

## Local use

```bash
bash scripts/validate-template.sh
bash tests/test_validate_template.sh
bash scripts/extract-changelog-section.sh 0.3.5
```

CI also runs `bash -n` and ShellCheck (`-S warning`) on these scripts.
