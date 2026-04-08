# Key rotation checklist

This document lists concrete steps to rotate exposed secrets and verify the rotations.

1) Inventory
   - Services with exposed secrets: LiveKit, VAPID (pushd.vapid), Files encryption
   - Record where each secret is used (dev servers, prod, GitHub Actions, deploy scripts)

2) Generate new credentials
   - LiveKit: use the LiveKit admin UI or API to create a new key/secret pair.
   - VAPID: generate a new keypair (e.g., using web-push or openssl) and base64-encode private key.
   - Files encryption: generate a new secure random 32-byte key, store as base64.

3) Store secrets securely
   - Add new secrets to your secret store (GitHub Secrets, Vault, environment on hosts).
   - Do NOT commit secrets to git. Use .env (gitignored) for local dev only.

4) Deploy rotated secrets to staging
   - Update environment variables / deployment manifests to use new secrets.
   - Run smoke tests (see below) against staging.

5) Verify
   - Confirm services start and handle traffic in staging.
   - Run integration smoke checks (e.g., basic API calls, LiveKit connection test).

6) Revoke old credentials
   - After verification, remove old credentials from services and secret stores.
   - Ensure no running instance still uses the old keys.

7) Notify team & update repo
   - Open/close PR referencing this checklist and note rotation details (do not include secret values).
   - Update .env.example and documentation if needed.

Smoke test examples
- curl -sSf "$API_HOST/health" || exit 1
- small LiveKit connection script to ensure auth succeeds (run in CI/staging only)

Notes
- Rotate immediately for any production secret exposed in the repo before merging.
- Keep an audit trail of actions (who rotated, when) and link it in the PR.

