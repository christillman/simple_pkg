# 7S-06-SIZING: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Complexity Assessment

### Source Files
| File | Lines | Complexity |
|------|-------|------------|
| simple_pkg.e | ~274 | Medium - Facade |
| pkg_cli.e | ~500 | High - CLI parsing |
| pkg_config.e | ~483 | Medium - Configuration |
| pkg_registry.e | ~200 | Medium - GitHub API |
| pkg_installer.e | ~300 | Medium - Git operations |
| pkg_resolver.e | ~150 | Medium - Dependencies |
| pkg_info.e | ~100 | Low - Data object |
| pkg_version.e | ~100 | Low - Versioning |
| pkg_search.e | ~80 | Low - Search |
| pkg_lock.e | ~100 | Low - Lock file |
| ecf_metadata.e | ~150 | Medium - ECF parsing |

**Total**: ~2,437 lines of Eiffel code

### Dependencies
11 simple_* libraries required for full functionality.

## Resource Usage

### Memory
- GitHub API responses cached
- ECF parsing is in-memory
- SQLite database for metadata

### Network
- GitHub API calls (rate limited)
- Git clone operations (large downloads)

### Disk
- Each library: 1-50MB
- Total ecosystem: ~500MB
- Cache directory: Variable

## Performance Estimates

| Operation | Typical Time |
|-----------|--------------|
| Package info | 1-2 seconds |
| Package search | 2-3 seconds |
| Package install | 10-60 seconds |
| Update all | 1-5 minutes |
| Doctor check | 5-10 seconds |
