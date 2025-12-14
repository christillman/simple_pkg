<p align="center">
  <img src="https://raw.githubusercontent.com/simple-eiffel/claude_eiffel_op_docs/main/artwork/LOGO.png" alt="simple_ library logo" width="400">
</p>

# simple_pkg

**[Documentation](https://simple-eiffel.github.io/simple_pkg/)** | **[GitHub](https://github.com/simple-eiffel/simple_pkg)**

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Eiffel](https://img.shields.io/badge/Eiffel-25.02-blue.svg)](https://www.eiffel.org/)
[![Design by Contract](https://img.shields.io/badge/DbC-enforced-orange.svg)]()
[![Platform](https://img.shields.io/badge/platform-Windows-blue.svg)]()

GitHub-based package manager for the Simple Eiffel ecosystem.

Part of the [Simple Eiffel](https://github.com/simple-eiffel) ecosystem.

## Status

**Production**

## Overview

simple_pkg is a modern package manager that dynamically discovers packages from the simple-eiffel GitHub organization. It handles installation, updates, dependency resolution, and environment variable setup - all with a simple CLI interface inspired by npm, cargo, and pip.

```eiffel
-- Install packages from command line
-- $ simple install json web sql

-- Or use the library API
local
    config: PKG_CONFIG
    installer: PKG_INSTALLER
do
    create config.make
    create installer.make (config)
    installer.install_package ("json")
end
```

## Features

- **Dynamic Discovery** - Fetches available packages from GitHub API
- **Dependency Resolution** - Parses ECF files to find `$SIMPLE_*` dependencies
- **Environment Setup** - Sets persistent Windows environment variables
- **Package Commands** - install, update, uninstall, search, info
- **Diagnostics** - doctor command checks environment health
- **Visualization** - tree command shows dependency graph
- **Project Init** - Scaffolds new projects with dependencies

## Installation

### Windows Installer

Download and run `simple-setup-1.0.0.exe` from the releases page.

### Manual Installation

1. Clone and build:
```bash
git clone https://github.com/simple-eiffel/simple_pkg.git
cd simple_pkg
ec -config simple_pkg.ecf -target simple_pkg_exe -finalize -c_compile
```

2. Add to PATH:
```powershell
$env:PATH += ";D:\path\to\simple_pkg\EIFGENs\simple_pkg_exe\F_code"
```

## Usage

```bash
# Install packages
simple install json web sql

# See all available packages
simple universe
simple -u

# List installed packages
simple inventory
simple -i

# Update packages
simple update           # Update all
simple update json      # Update specific

# Search packages
simple search http

# Show package info
simple info json

# Show dependency tree
simple tree json

# Check environment health
simple doctor

# Create new project
simple init my_app json web
```

## Commands

| Command | Alias | Description |
|---------|-------|-------------|
| `install <pkg>...` | `i` | Install packages with dependencies |
| `update [<pkg>...]` | `up` | Update packages (all if none specified) |
| `uninstall <pkg>` | `rm` | Remove a package |
| `move <pkg>` | `mv` | Move package to current directory |
| `search <query>` | `s` | Search for packages |
| `list` | - | List all available packages |
| `universe` | `-u` | Show all packages with install status |
| `inventory` | `-i` | List installed packages |
| `info <pkg>` | - | Show package details |
| `tree [<pkg>]` | `deps` | Show dependency tree |
| `doctor` | `check` | Diagnose environment issues |
| `outdated` | - | Check for package updates |
| `init <name> [<pkg>...]` | - | Create new project |
| `env [--save]` | - | Show/save environment script |
| `version` | `-v` | Show version |
| `help` | `-h` | Show help |

## Dependencies

Uses these simple_* libraries:
- simple_json - JSON parsing for GitHub API responses
- simple_http - HTTP client for API calls
- simple_file - File operations
- simple_process - Git command execution
- simple_env - Environment variable access
- simple_console - CLI output formatting

## License

MIT License
