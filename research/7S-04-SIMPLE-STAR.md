# 7S-04-SIMPLE-STAR: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Ecosystem Position

simple_pkg is the **meta-tool** for the simple_* ecosystem - it manages all other libraries.

```
simple_pkg (Package Manager)
    |
    +---> Installs/Updates all simple_* libraries
    |
    +---> Manages SIMPLE_EIFFEL environment
    |
    +---> Bootstraps new projects
```

## Dependencies

| Library | Purpose | Required |
|---------|---------|----------|
| simple_json | JSON parsing (API, config) | Yes |
| simple_http | GitHub API calls | Yes |
| simple_file | File operations | Yes |
| simple_process | Git command execution | Yes |
| simple_env | Environment variables | Yes |
| simple_console | CLI output formatting | Yes |
| simple_sql | SQLite database | Yes |
| simple_cli | Argument parsing | Yes |
| simple_datetime | Timestamps | Yes |
| simple_logger | Logging | Yes |
| simple_xml | ECF parsing | Yes |

## Bootstrap Problem

simple_pkg requires 11 dependencies to build, but those dependencies are managed by simple_pkg. Solution: Manual bootstrap process documented in README.

## Integration Pattern

### CLI Usage
```bash
simple install json web sql
simple update
simple doctor
```

### Library API
```eiffel
local
    pkg: SIMPLE_PKG
do
    create pkg.make
    pkg.install ("json")
end
```

## Ecosystem Conventions

1. Windows installer available
2. GitHub releases for binaries
3. Self-updating capability
4. Comprehensive diagnostics
