# S04-FEATURE-SPECS: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## SIMPLE_PKG Features

### Installation
| Feature | Signature | Description |
|---------|-----------|-------------|
| install | `install (a_name: STRING)` | Install package with deps |
| install_multiple | `install_multiple (a_names: ARRAY [STRING])` | Install multiple packages |
| install_all | `install_all` | Install all available packages |

### Update
| Feature | Signature | Description |
|---------|-----------|-------------|
| update | `update (a_name: STRING)` | Update single package |
| update_all | `update_all` | Update all installed packages |

### Query
| Feature | Signature | Description |
|---------|-----------|-------------|
| search | `search (a_query: STRING): ARRAYED_LIST [PKG_INFO]` | Search packages |
| list_available | `list_available: ARRAYED_LIST [PKG_INFO]` | List all packages |
| list_installed | `list_installed: ARRAYED_LIST [STRING]` | List installed |
| info | `info (a_name: STRING): detachable PKG_INFO` | Get package info |
| is_installed | `is_installed (a_name: STRING): BOOLEAN` | Check if installed |

### Status
| Feature | Signature | Description |
|---------|-----------|-------------|
| has_error | `has_error: BOOLEAN` | Did last operation fail? |
| last_errors | `last_errors: ARRAYED_LIST [STRING]` | Error messages |

## PKG_CONFIG Features

### Environment
| Feature | Signature | Description |
|---------|-----------|-------------|
| get_env | `get_env (a_name: STRING): detachable STRING` | Get env var |
| set_env | `set_env (a_name, a_value: STRING)` | Set persistent env var |
| unset_env | `unset_env (a_name: STRING)` | Remove env var |
| simple_eiffel_root | `simple_eiffel_root: detachable STRING` | Get SIMPLE_EIFFEL |

### Paths
| Feature | Signature | Description |
|---------|-----------|-------------|
| package_path | `package_path (a_package: STRING): STRING` | Full package path |
| normalize_package_name | `normalize_package_name (a_name: STRING): STRING` | Add simple_ prefix |
| parse_package_spec | `parse_package_spec (a_spec: STRING): TUPLE` | Parse name@version |

## PKG_CLI Commands

| Command | Alias | Description |
|---------|-------|-------------|
| install | i | Install packages |
| update | up | Update packages |
| uninstall | rm | Remove package |
| search | s | Search packages |
| list | - | List all packages |
| universe | -u | Show all with status |
| inventory | -i | List installed |
| info | - | Package details |
| tree | deps | Dependency tree |
| doctor | check | Diagnostics |
| init | - | Create project |
| version | -v | Show version |
| help | -h | Show help |
