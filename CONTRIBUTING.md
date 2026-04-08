Thank you for contributing to Ermine.

Guidelines

- Create a branch named: feat/your-feature or fix/your-bug
- Open a PR against main and include a description of the change and testing steps
- Avoid committing large model binaries; use external storage or git-lfs
- Do NOT commit secrets (Ermin.toml contains sensitive keys). Use environment variables or a secret store. Rotate any keys accidentally committed.

Local development

- Use docker-compose for a reproducible environment: docker compose -f compose.yml -f compose.override.yml up --build
- For quick checks, run: bash -n build.sh

CI

- A minimal GitHub Actions workflow is included at .github/workflows/ci.yml. It runs basic checks and a lightweight build.

Contact

- If unsure, open an issue or reach out to the maintainers via the PR thread.
