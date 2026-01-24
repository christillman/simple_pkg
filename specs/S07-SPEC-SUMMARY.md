# S07-SPEC-SUMMARY: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Executive Summary

simple_pkg is a modern package manager for the 85+ simple_* Eiffel libraries, replacing the defunct ISE iron with a GitHub-based solution.

## Key Specifications

### Architecture
- **Pattern**: Facade + Strategy (platform-specific env)
- **Main Class**: SIMPLE_PKG
- **CLI**: PKG_CLI
- **Registry**: PKG_REGISTRY (GitHub API)

### API Design
- **npm-style CLI**: install, update, search
- **Fluent naming**: Consistent command patterns
- **Error collection**: last_errors array

### Features
1. Package installation from GitHub
2. Automatic dependency resolution
3. Environment variable setup
4. Package search and discovery
5. Dependency tree visualization
6. Doctor diagnostics
7. Project scaffolding
8. Windows installer

### Dependencies
11 simple_* libraries:
- simple_json, simple_http, simple_file
- simple_process, simple_env, simple_console
- simple_sql, simple_cli, simple_datetime
- simple_logger, simple_xml

### Platform Support
- Windows (64-bit) - Full with installer
- Linux - Full
- macOS - Full

## Contract Highlights

- Package names must be non-empty
- Names normalized to simple_* prefix
- Directories always have valid paths
- Errors collected in list for inspection

## Performance Targets

| Operation | Target |
|-----------|--------|
| Search | <3 seconds |
| Info | <2 seconds |
| Install | 10-60 seconds |
| Doctor | <10 seconds |
