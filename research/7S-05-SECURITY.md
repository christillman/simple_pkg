# 7S-05-SECURITY: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Threat Model

### Assets
1. Source code (cloned from GitHub)
2. Environment variables (SIMPLE_EIFFEL, PATH)
3. File system (installation directories)
4. GitHub API tokens (if configured)

### Threat Actors
1. Compromised GitHub repositories
2. Man-in-the-middle on HTTPS
3. Malicious package names (typosquatting)
4. Local privilege escalation

## Security Considerations

### GitHub API
- Public repositories only
- No authentication required for basic operations
- Rate limiting applies (60 req/hour unauthenticated)
- HTTPS for all communications

### Code Execution
- Runs git clone (network code execution risk)
- No sandboxing of installed code
- Trust model: GitHub simple-eiffel org is trusted

### Environment Variables
- setx on Windows (user-level, persistent)
- .bashrc on Linux (user-level, persistent)
- Risk: PATH corruption via long values

### File System
- Installs to SIMPLE_EIFFEL directory
- Creates config in user home
- No privilege escalation required

## Recommendations

1. Verify GitHub repository authenticity
2. Use HTTPS (enforced)
3. Avoid setx for long PATH values (1024 char limit)
4. Review package code before use
5. Backup environment before changes

## Out of Scope
- Package signing
- Checksum verification
- Sandboxed execution
- Dependency auditing
