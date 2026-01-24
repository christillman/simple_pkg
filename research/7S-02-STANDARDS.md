# 7S-02-STANDARDS: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Applicable Standards

### Package Manager Conventions
- **npm style** - install, update, uninstall commands
- **cargo style** - Simple CLI syntax
- **pip style** - Package search and info

### API Standards
- **GitHub REST API v3** - Repository discovery
- **GitHub Raw Content** - Direct file access
- **ECF Format** - Eiffel Configuration File parsing

### Configuration Standards
- **JSON** - Configuration file format
- **Semantic Versioning** - Version constraints
- **Environment Variables** - SIMPLE_EIFFEL root

## CLI Command Conventions

| Pattern | Example |
|---------|---------|
| install <pkg> | simple install json |
| update [pkg] | simple update |
| search <query> | simple search http |
| info <pkg> | simple info json |
| tree [pkg] | simple tree json |
| doctor | simple doctor |
| init <name> | simple init myapp json |

## Directory Structure

```
$SIMPLE_EIFFEL/
├── simple_json/
├── simple_http/
├── simple_sql/
├── ... (85+ libraries)
└── .simple/
    ├── config.json
    └── cache/
```

## Environment Variables

| Variable | Purpose |
|----------|---------|
| SIMPLE_EIFFEL | Root directory for all libraries |
| GOBO | Gobo Eiffel library location |
| GOBO_LIBRARY | Gobo library subdirectory |
