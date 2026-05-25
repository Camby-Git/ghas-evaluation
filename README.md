# GHAS Evaluation — Secret Scanning & Push Protection

Test repository for evaluating GitHub Advanced Security (GHAS) secret scanning
and push protection.

> **Note on validity checks:** Validity checks (GitHub contacting the provider
> to confirm if a secret is still active) are restricted to paid GHAS plans
> (GitHub Team + Secret Protection add-on, or GitHub Enterprise). They are
> **not** available on free public repos. This evaluation covers secret scanning
> and push protection only.

## Structure

```
tests/
  push-protection/     # Secrets that should be BLOCKED before reaching the repo
  scanning/            # Secrets already "in" the repo — triggers scanning alerts
  validity/            # Real credentials (throwaway) to test validity check status
  bypass/              # Documents bypass workflow scenarios
scripts/
  run-push-tests.sh    # Automates push protection test cases one by one
  check-alerts.sh      # Uses gh CLI to list current secret scanning alerts
results/
  expected.md          # What each test case should produce
  FILL_IN_actuals.md   # Fill in observed results during evaluation
```

## Setup

1. Enable GHAS features in repo Settings → Advanced Security:
   - [x] Secret Protection (secret scanning)
   - [x] Push protection
   - [x] Validity checks

2. Clone this repo and run tests:
   ```bash
   chmod +x scripts/run-push-tests.sh
   ./scripts/run-push-tests.sh
   ```

3. View alerts:
   ```bash
   ./scripts/check-alerts.sh
   ```

## Test Coverage

| # | Secret Type          | Provider  | Push Protection | Validity Check          |
|---|----------------------|-----------|-----------------|-------------------------|
| 1 | Personal Access Token | GitHub   | ✅ Free         | 💰 Paid GHAS only       |
| 2 | OAuth Token          | GitHub    | ✅ Free         | 💰 Paid GHAS only       |
| 3 | Access Key ID + Secret | AWS     | ✅ Free         | 💰 Paid GHAS only       |
| 4 | API Key (live)       | Stripe    | ✅ Free         | 💰 Paid GHAS only       |
| 5 | API Key (test)       | Stripe    | ✅ Free         | 💰 Paid GHAS only       |
| 6 | Incoming Webhook     | Slack     | ✅ Free         | 💰 Paid GHAS only       |
| 7 | API Key              | Google    | ✅ Free         | 💰 Paid GHAS only       |
| 8 | API Key              | SendGrid  | ✅ Free         | 💰 Paid GHAS only       |
| 9 | API Token            | Vercel    | ✅ Free         | 💰 Paid GHAS only       |
|10 | Account SID + Token  | Twilio    | ✅ Free         | 💰 Paid GHAS only       |
|11 | Generic high-entropy | (custom)  | ❌ Not supported| ❌ Not supported         |
|12 | Secret in comment    | GitHub    | ✅ Free         | 💰 Paid GHAS only       |
|13 | Secret in .env file  | GitHub    | ✅ Free         | 💰 Paid GHAS only       |
|14 | Secret in JSON config | Stripe   | ✅ Free         | 💰 Paid GHAS only       |

## How Push Protection Works

When you push a commit containing a detected secret, GitHub blocks the push and returns:

```
remote: Push cannot contain secrets.
remote:
remote: Secret: GitHub Personal Access Token
remote: File:   tests/push-protection/github-pat.env
remote: URL:    https://github.com/Camby-Git/ghas-evaluation/security/secret-scanning/unblock-secret/XXXXX
```

You must visit the URL to either remove the secret or bypass with a reason.

## Bypass Reasons

| Reason | Use case |
|--------|----------|
| `used_in_tests` | Intentional test credential — pattern only, not real |
| `false_positive` | String matches pattern but is not a real credential |
| `will_fix_later` | Acknowledged, will remediate after push |
