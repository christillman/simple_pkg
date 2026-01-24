# S05-CONSTRAINTS: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Technical Constraints

### Platform Requirements
- **Windows**: 10/11 64-bit, Visual Studio 2022
- **Linux**: Common distributions with git
- **macOS**: With Homebrew git

### Build Requirements
- EiffelStudio 25.02+
- Gobo Eiffel library
- 11 simple_* dependencies

### Network Requirements
- GitHub API access (api.github.com)
- Git clone access (github.com)
- Rate limit: 60 requests/hour unauthenticated

### File System Constraints
- SIMPLE_EIFFEL directory writable
- User home directory for config
- Git available in PATH

## API Constraints

### Package Names
- Must be lowercase
- Prefixed with "simple_" internally
- "json" becomes "simple_json"

### Version Constraints
- Semantic versioning (x.y.z)
- Git tags for versions
- No version range support yet

### Environment Variables
- Windows: setx has 1024 char limit
- Linux: bashrc modification
- macOS: bashrc modification

## Invariants

### Directories
- install_directory always set
- cache_directory always set
- config_directory always set

### Registry
- GitHub organization: simple-eiffel
- API base: api.github.com
- Raw content: raw.githubusercontent.com
