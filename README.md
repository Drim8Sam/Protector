# Protector

Protector is a simple Swift code analyzer. It scans Swift source files and reports potential vulnerabilities. Supported checks include:

- Force unwrap usage
- Insecure data storage in `UserDefaults`
- HTTP connections instead of HTTPS
- Weak cryptographic algorithms (MD5/SHA1)
- Hardcoded secrets
- Basic input validation issues

Run the macOS app, select a project folder and start analysis to see results.
