# Validity Check Tests

Validity checks require **real credentials** from a throwaway account to
produce meaningful Active/Inactive results. Fake pattern-matching strings
will show as "Unknown" validity.

## Setup for each provider

### GitHub
1. Create a throwaway GitHub account
2. Generate a PAT: Settings → Developer settings → Personal access tokens
3. Add to `validity-real.env` (DO NOT COMMIT — use GitHub web UI)
4. After alert appears, click "Verify secret" to force a validity check
5. Revoke the token in GitHub
6. Re-check — status should flip to "Inactive"

### AWS
1. Create a throwaway IAM user in a sandbox account
2. Generate access keys
3. Add to file via GitHub web UI
4. Observe validity check
5. Disable the key in IAM Console
6. Observe status change

### Stripe
1. Use your Stripe test dashboard → Developers → API keys
2. Generate a restricted test key
3. Add via GitHub web UI
4. Observe validity — Stripe test keys show as "Active" if valid
5. Revoke in Stripe dashboard → observe "Inactive"

## What to document

For each provider, record:
- Time from commit → alert appears
- Time from commit → validity status appears
- Does revoking the credential update the status automatically?
- How long until status updates after revocation?

## Template: validity-real.env

Create this file locally (never commit via git push — use web UI):

```
GITHUB_TOKEN=ghp_<real_throwaway_token>
AWS_ACCESS_KEY_ID=AKIA<real_throwaway_key>
AWS_SECRET_ACCESS_KEY=<real_throwaway_secret>
STRIPE_SECRET_KEY=sk_test_<real_throwaway_key>
```
