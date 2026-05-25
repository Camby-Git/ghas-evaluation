# Expected Test Results

> **Validity checks** require paid GHAS. Not available on free public repos.

| # | File | Secret Type | Push Blocked? | Scanning Alert? | Notes |
|---|------|-------------|:-------------:|:---------------:|-------|
| 01 | github-pat.env | GitHub PAT (classic) | ❌ No | ❓ Unknown | Push protection validates embedded CRC32 checksum — fake tokens without valid checksums are not blocked. Requires a real (then revoked) token to test. |
| 02 | github-oauth.env | GitHub OAuth Token | ❌ No | ❓ Unknown | Same CRC32 checksum requirement as PATs. |
| 03 | aws-credentials.env | AWS Access Key | ✅ Yes | ✅ Yes | Secret key must be exactly 40 chars. Fixed in v2 of test files. |
| 04 | stripe-live.env | Stripe Live Secret Key | ✅ Yes | ✅ Yes | `sk_live_` prefix reliably blocked. |
| 05 | stripe-test.env | Stripe Test Secret Key | ❌ No | ❓ Unknown | **Genuine gap:** push protection does not block `sk_test_` keys by default. |
| 06 | slack-webhook.env | Slack Incoming Webhook | ✅ Yes | ✅ Yes | Full URL pattern reliably blocked. |
| 07 | google-api-key.env | Google API Key | ❌ No | ✅ Yes | **Interesting gap:** scanning raises an alert but push protection confidence threshold not met for fake tokens. `AIza` pattern detected post-commit only. |
| 08 | sendgrid.env | SendGrid API Key | ✅ Yes | ✅ Yes | `SG.` prefix reliably blocked. |
| 09 | vercel-token.env | Vercel API Token | ❌ No | ❓ Unknown | Pattern too generic for push protection confidence threshold. |
| 10 | twilio.env | Twilio SID + Auth Token | ✅ Yes | ✅ Yes | Both SID and auth token detected. |
| 11 | generic-high-entropy.env | Generic/custom | ❌ No | ❌ No | No partner pattern — confirmed gap. Custom GHAS patterns required. |
| 12 | secret-in-code.ts | GitHub PAT + AWS in code | ⚠️ Partial | ✅ Yes | AWS blocked; GitHub PAT not blocked (CRC32). Scanning catches both post-commit. |
| 13 | secret-in-comment.ts | GitHub PAT in comment | ❌ No | ❓ Unknown | CRC32 checksum issue — not blocked. |
| 14 | secret-in-config.json | Stripe + SendGrid in JSON | ✅ Yes | ✅ Yes | Both secrets blocked in JSON. |

## Summary

**Push protection blocked: 4/10 provider tests** (Stripe live, Slack, SendGrid, Twilio)

**Key findings**

### Genuine GHAS gaps
| Gap | Impact | Mitigation |
|-----|--------|-----------|
| GitHub PAT/OAuth tokens require valid CRC32 checksum to trigger push protection | Fake tokens used in tests or docs pass through | Use real short-lived tokens in tests; rotate immediately |
| Stripe test keys (`sk_test_`) not blocked by push protection | Test credentials can leak freely | Treat test keys as production secrets; add custom pattern |
| Google API keys detected by scanning but not blocked at push time | Secrets reach the repo before alert fires | Monitor scanning alerts; consider custom push rule |
| Generic/internal secrets not covered | Internal API keys, DB passwords invisible to GHAS | Add custom secret patterns in Advanced Security settings |
| Vercel token pattern too ambiguous for push confidence threshold | Vercel credentials pass through | Custom pattern or use Vercel's token scoping |

### What works reliably
- Stripe live keys (`sk_live_`)
- Slack webhooks
- SendGrid API keys
- Twilio SIDs + auth tokens
- Detection works across all file types: `.env`, `.ts`, `.json`, comments

### Recommendations
1. **Enable custom patterns** for internal credentials not covered by partner patterns
2. **Treat test credentials as production** — Stripe test keys are not blocked
3. **Supplement push protection with scanning alerts** — Google keys reach the repo but are detected quickly post-commit
4. **For GitHub token testing**, use a real throwaway PAT and revoke it immediately after the test
