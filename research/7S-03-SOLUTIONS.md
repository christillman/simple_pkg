# 7S-03-SOLUTIONS: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Alternative Solutions Considered

### 1. Iron (ISE) (Rejected)
- **Approach**: Use ISE's official package manager
- **Pros**: Official, integrated with EiffelStudio
- **Cons**: Defunct, no maintenance, broken infrastructure
- **Decision**: Rejected - not functional

### 2. Git Submodules (Rejected)
- **Approach**: Use git submodules for dependencies
- **Pros**: Standard git feature, no tooling needed
- **Cons**: Complex workflow, no version resolution
- **Decision**: Rejected - poor UX

### 3. Manual Scripts (Rejected)
- **Approach**: Shell scripts for installation
- **Pros**: Simple, no dependencies
- **Cons**: No cross-platform, no dependency resolution
- **Decision**: Rejected - not scalable

### 4. Custom Package Manager (Chosen)
- **Approach**: Native Eiffel package manager
- **Pros**: Tailored to ecosystem, cross-platform, dog-fooding
- **Cons**: Development effort
- **Decision**: Selected - best fit for ecosystem

## Architecture Decisions

1. **GitHub-based registry** - No custom registry server
2. **Git clone installation** - Leverage existing git tags
3. **ECF parsing** - Extract dependencies from config
4. **Single root variable** - SIMPLE_EIFFEL points to all
5. **Persistent environment** - setx/bashrc integration
6. **SQLite cache** - Via simple_sql for metadata
