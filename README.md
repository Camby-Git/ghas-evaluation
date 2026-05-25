# GHAS Evaluation — Secret Scanning & Push Protection

Test repository for evaluating GitHub Advanced Security (GHAS) secret scanning,
push protection, and validity checks.

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

| # | Secret Type         | Provider  | Push Protection | Validity Check |
|---|---------------------|-----------|-----------------|----------------|
| 1 | Personal Access Token | GitHub  | ✅ Supported    | ✅ Supported   |
| 2 | OAuth Token         | GitHub    | ✅ Supported    | ✅ Supported   |
| 3 | Access Key ID + Secret | AWS    | ✅ Supported    | ✅ Supported   |
| 4 | API Key (live)      | Stripe    | ✅ Supported    | ✅ Supported   |
| 5 | API Key (test)      | Stripe    | ✅ Supported    | ✅ Supported   |
| 6 | Incoming Webhook    | Slack     | ✅ Supported    | ✅ Supported   |
| 7 | API Key             | Google    | ✅ Supported    | ✅ Supported   |
| 8 | API Key             | SendGrid  | ✅ Supported    | ✅ Supported   |
| 9 | API Token           | Vercel    | ✅ Supported    | ✅ Supported   |
|10 | Account SID + Token | Twilio    | ✅ Supported    | ✅ Supported   |
|11 | Generic high-entropy| (custom)  | ❌ Not supported| ❌ Not supported|
|12 | Secret in comment   | GitHub    | ✅ Supported    | ✅ Supported   |
|13 | Secret in .env file | GitHub    | ✅ Supported    | ✅ Supported   |
|14 | Secret in JSON config| Stripe   | ✅ Supported    | ✅ Supported   |

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
