// Test 13: Secret hidden inside a code comment
// Expected: BLOCKED

export function fetchData(endpoint: string) {
  // TODO: remove before merging — temp token for local dev:
  // Authorization: Bearer ghp_Rv8KmN2pQ7tXwY3hA9dZ5bCeF4gJ0iLmNpR
  return fetch(endpoint);
}
