# 7S-01-SCOPE: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Problem Statement

The Eiffel ecosystem lacks a modern package manager. ISE's 'iron' is defunct and no replacement exists for managing the 85+ simple_* libraries efficiently.

## Target Users

1. **Eiffel Developers** - Install and manage dependencies
2. **Library Authors** - Publish and version libraries
3. **DevOps Engineers** - Automate environment setup
4. **New Users** - Bootstrap simple_* ecosystem

## Core Capabilities

1. **Package Installation** - Install from GitHub
2. **Dependency Resolution** - Parse ECF for dependencies
3. **Version Management** - Git tag-based versioning
4. **Environment Setup** - Configure SIMPLE_EIFFEL variable
5. **Package Discovery** - Search GitHub organization
6. **Diagnostics** - Doctor command for health checks
7. **Project Scaffolding** - Init new projects

## Out of Scope

- Private repository support
- Binary package distribution
- Package signing/verification
- Lockfile-based reproducible builds
- Multi-version coexistence

## Success Criteria

1. Install any simple_* library with one command
2. Resolve dependencies automatically
3. Set up environment variables persistently
4. Work on Windows, Linux, macOS
5. No external runtime dependencies
