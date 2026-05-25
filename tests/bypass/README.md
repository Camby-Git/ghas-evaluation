# Bypass Workflow Tests

These test the three bypass reasons and the admin approval flow.

## Bypass Reason 1: used_in_tests

Push a file with a secret → get blocked → visit the GitHub URL → select
"It's used in tests" → retry push within 3 hours.

**What to verify:**
- Alert is still created (bypass doesn't suppress the alert)
- Alert is marked "Bypassed" in Security → Secret scanning
- Bypass is recorded in the repository audit log
- Admin receives notification (if configured)

## Bypass Reason 2: false_positive

Push a file with a string that matches a pattern but is not a real credential.
Select "It's a false positive" when bypassed.

**What to verify:**
- Can you dismiss the alert as false positive afterwards?
- Does the same string trigger again on future pushes?

## Bypass Reason 3: will_fix_later

Select "I'll fix it later" during bypass.

**What to verify:**
- Alert remains open
- Is there any follow-up mechanism (reminder, auto-close deadline)?

## Admin Approval Flow

To test this:
1. In repo Settings → Advanced Security → Push protection
2. Set "Who can bypass" to "Specific roles and teams" (not "Anyone")
3. Attempt to push a secret as a non-admin contributor
4. Verify: contributor must submit a bypass request
5. As admin: approve or deny the request
6. Verify: contributor is notified of the decision

## Audit Log Check

After bypass tests:
```bash
gh api repos/Camby-Git/ghas-evaluation/audit-log \
  --jq '.[] | select(.action | startswith("secret_scanning"))'
```
