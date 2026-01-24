# S02-CLASS-CATALOG: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Class Hierarchy

```
ANY
├── SIMPLE_PKG              # Main facade
├── PKG_CLI                 # CLI parser
├── PKG_CONFIG              # Configuration
├── PKG_REGISTRY            # GitHub API
├── PKG_INSTALLER           # Git operations
├── PKG_RESOLVER            # Dependency resolution
├── PKG_INFO                # Package metadata
├── PKG_VERSION             # Version parsing
├── PKG_SEARCH              # Search interface
├── PKG_LOCK                # Lock file
├── PKG_LOCK_ENTRY          # Lock entry
├── SEARCH_RESULT           # Search result
└── ECF_METADATA            # ECF parsing
```

## Class Descriptions

### SIMPLE_PKG (Facade)
Main entry point for package operations.
- **Creation**: `make`
- **Purpose**: Unified API for install/update/search

### PKG_CLI
Command-line interface parser and executor.
- **Purpose**: Parse commands, dispatch to operations

### PKG_CONFIG
Configuration management.
- **Creation**: `make`
- **Purpose**: Paths, env vars, platform detection

### PKG_REGISTRY
GitHub API interface.
- **Creation**: `make (config)`
- **Purpose**: Fetch package info, list packages

### PKG_INSTALLER
Package installation via git.
- **Creation**: `make (config)`
- **Purpose**: Clone repos, update packages

### PKG_RESOLVER
Dependency resolution.
- **Creation**: `make`
- **Purpose**: Parse ECF, resolve dependency graph

### PKG_INFO
Package metadata container.
- **Creation**: `make (name)`
- **Purpose**: Hold package information

### ECF_METADATA
ECF file parser.
- **Creation**: `make_from_file (path)`
- **Purpose**: Extract dependencies from ECF
