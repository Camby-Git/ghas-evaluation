#!/usr/bin/env bash
# check-alerts.sh
# Fetches current secret scanning alerts from GitHub via gh CLI.
# Shows: secret type, state, validity, file location, commit.
#
# Usage: ./scripts/check-alerts.sh [--open|--all]

set -euo pipefail

REPO="Camby-Git/ghas-evaluation"
STATE="${1:---open}"

CYAN='\033[0;36m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${CYAN}━━━ GHAS Secret Scanning Alerts — ${REPO} ━━━${NC}"
echo ""

# Fetch alerts
ALERTS=$(gh api \
  "repos/${REPO}/secret-scanning/alerts?state=${STATE//--/}&per_page=50" \
  --jq '.[] | {
    number: .number,
    type: .secret_type_display_name,
    state: .state,
    validity: (.validity // "not_checked"),
    resolution: (.resolution // "open"),
    created: .created_at,
    url: .html_url,
    locations_url: .locations_url
  }')

if [[ -z "$ALERTS" ]]; then
  echo "  No alerts found (state: ${STATE//--/})"
  echo ""
  exit 0
fi

COUNT=$(echo "$ALERTS" | python3 -c "import sys,json; d=sys.stdin.read(); print(len([l for l in d.strip().split('\n') if '\"number\"' in l]))")
echo "  Found ${COUNT} alert(s):"
echo ""

echo "$ALERTS" | python3 -c "
import sys, json

raw = sys.stdin.read().strip()
# Parse concatenated JSON objects
import re
objects = re.findall(r'\{[^{}]+\}', raw, re.DOTALL)

for obj in objects:
    try:
        a = json.loads(obj)
        validity = a.get('validity', 'not_checked')
        state    = a.get('state', '')
        v_color  = '\033[0;32m' if validity == 'active' else '\033[0;33m' if validity == 'unknown' else '\033[0;90m'
        s_color  = '\033[0;31m' if state == 'open' else '\033[0;90m'
        reset    = '\033[0m'
        print(f\"  #{a['number']:>3}  {a['type']:<40} {s_color}{state:<8}{reset}  validity: {v_color}{validity:<10}{reset}  {a['created'][:10]}\")
        print(f\"        {a['url']}\")
        print()
    except:
        pass
"

echo ""
echo -e "${CYAN}━━━ Validity summary ━━━${NC}"
gh api "repos/${REPO}/secret-scanning/alerts?per_page=50" \
  --jq '[.[] | .validity] | group_by(.) | map({(.[0]): length}) | add' \
  2>/dev/null || echo "  (validity data unavailable)"

echo ""
echo "  Full alert list: https://github.com/${REPO}/security/secret-scanning"
echo ""
