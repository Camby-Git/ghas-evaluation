# Expected Test Results

> **Validity checks** require paid GHAS (GitHub Team + Secret Protection add-on,
> or GitHub Enterprise). Not available on free public repos.

| # | File | Secret Type | Push Blocked? | Validity Check? | Notes |
|---|------|-------------|:-------------:|:---------------:|-------|
| 01 | github-pat.env | GitHub PAT (classic) | ✅ Yes | 💰 Paid only | `ghp_` prefix |
| 02 | github-oauth.env | GitHub OAuth Token | ✅ Yes | 💰 Paid only | `gho_` prefix |
| 03 | aws-credentials.env | AWS Access Key | ✅ Yes | 💰 Paid only | Both key ID and secret detected |
| 04 | stripe-live.env | Stripe Live Secret Key | ✅ Yes | 💰 Paid only | Higher severity than test keys |
| 05 | stripe-test.env | Stripe Test Secret Key | ✅ Yes | 💰 Paid only | Lower severity alert |
| 06 | slack-webhook.env | Slack Incoming Webhook | ✅ Yes | 💰 Paid only | Full URL pattern |
| 07 | google-api-key.env | Google API Key | ✅ Yes | 💰 Paid only | `AIza` prefix |
| 08 | sendgrid.env | SendGrid API Key | ✅ Yes | 💰 Paid only | `SG.` prefix |
| 09 | vercel-token.env | Vercel API Token | ✅ Yes | 💰 Paid only | Expanded coverage Mar 2026 |
| 10 | twilio.env | Twilio Account SID + Auth Token | ✅ Yes | 💰 Paid only | Two secrets detected |
| 11 | generic-high-entropy.env | Generic/custom | ❌ No | ❌ No | No partner pattern — key gap |
| 12 | secret-in-code.ts | GitHub PAT + AWS (in code) | ✅ Yes | 💰 Paid only | Scans all file types |
| 13 | secret-in-comment.ts | GitHub PAT (in comment) | ✅ Yes | 💰 Paid only | Scans comments |
| 14 | secret-in-config.json | Stripe + SendGrid (in JSON) | ✅ Yes | 💰 Paid only | Scans JSON |

## Key Gaps to Evaluate

1. **Generic secrets (Test 11)** — custom internal credentials are invisible to push
   protection. Consider custom patterns in GHAS settings if needed.

2. **Validity check latency** — how long after a commit does validity appear?

3. **Bypass audit trail** — are all bypasses captured in the audit log?

4. **Alert noise** — do fake-but-pattern-matching strings produce false positives?
