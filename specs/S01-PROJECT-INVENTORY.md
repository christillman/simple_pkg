# S01-PROJECT-INVENTORY: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## Project Structure

```
simple_pkg/
├── src/
│   ├── simple_pkg.e             # Main facade class
│   ├── pkg_cli.e                # CLI command parser
│   ├── pkg_config.e             # Configuration management
│   ├── pkg_registry.e           # GitHub registry interface
│   ├── pkg_installer.e          # Package installation
│   ├── pkg_resolver.e           # Dependency resolution
│   ├── pkg_info.e               # Package metadata
│   ├── pkg_version.e            # Version handling
│   ├── pkg_search.e             # Search functionality
│   ├── pkg_lock.e               # Lock file management
│   ├── pkg_lock_entry.e         # Lock entry data
│   ├── search_result.e          # Search result data
│   └── ecf_metadata.e           # ECF file parsing
├── installer/
│   └── simple_pkg_setup.iss     # INNO installer script
├── testing/
│   └── [test files]
├── docs/
│   └── index.html               # API documentation
├── plan/
│   └── [planning documents]
├── simple_pkg.ecf               # Library configuration
├── README.md                    # User documentation
├── LICENSE                      # MIT License
└── package.json                 # NPM-style metadata
```

## ECF Configuration

- **Library Target**: simple_pkg
- **Executable Target**: simple_pkg_exe
- **Test Target**: simple_pkg_tests
- **Dependencies**: 11 simple_* libraries

## Build Artifacts

- EIFGENs/simple_pkg/ - Library compilation
- EIFGENs/simple_pkg_exe/F_code/simple.exe - CLI executable
- simple-setup-*.exe - Windows installer
