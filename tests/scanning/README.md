# Scanning Tests

These files simulate secrets that are already committed to a repository
(bypassed push protection, or committed before push protection was enabled).

They test the **secret scanning alert** side of GHAS — not push protection.

## How to use

Commit these files directly via the GitHub web UI (drag & drop into the repo),
which bypasses CLI push protection. GHAS will then:

1. Detect the secrets in the repo content
2. Raise secret scanning alerts in the Security tab
3. (If validity checks enabled) contact the provider to confirm if active

## What to observe

- Alert appears in Security → Secret scanning
- Alert shows: secret type, file, line number, commit SHA
- Validity status: Active / Inactive / Unknown
- Can you dismiss as false positive?
- Does GitHub send an email notification?
