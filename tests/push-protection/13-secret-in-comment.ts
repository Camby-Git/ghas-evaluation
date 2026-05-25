// Test 13: Secret hidden inside a code comment
// Tests that push protection scans comments, not just assignment values
// Expected: BLOCKED
// Validity check: Yes

export function fetchData(endpoint: string) {
  // TODO: remove before merging — temp token for local dev:
  // Authorization: Bearer ghp_16C7e42F292c6912E7710c838347Ae178B4a
  return fetch(endpoint);
}
