// Test 12: Secret embedded inside source code (not a .env file)
// Tests that push protection scans ALL file types, not just .env
// Expected: BLOCKED — push protection scans code files too
// Validity check: Yes

// Bad practice: hardcoded credential in application code
const config = {
  github: {
    // This token was "accidentally" left in after local testing
    token: "ghp_16C7e42F292c6912E7710c838347Ae178B4a",
  },
  aws: {
    accessKeyId: "AKIAIOSFODNN7EXAMPLE",
    secretAccessKey: "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY",
    region: "us-east-1",
  },
};

export default config;
