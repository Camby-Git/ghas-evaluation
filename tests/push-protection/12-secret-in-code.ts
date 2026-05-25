// Test 12: Secret embedded inside source code (not a .env file)
// Tests that push protection scans ALL file types, not just .env
// Expected: BLOCKED — push protection scans code files too

const config = {
  github: {
    token: "ghp_Rv8KmN2pQ7tXwY3hA9dZ5bCeF4gJ0iLmNpR",
  },
  aws: {
    accessKeyId: "AKIAQJ7MNPX2WLTRHV5K",
    secretAccessKey: "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",
    region: "ap-southeast-2",
  },
};

export default config;
