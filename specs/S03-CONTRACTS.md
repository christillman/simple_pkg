# S03-CONTRACTS: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## SIMPLE_PKG Contracts

### make
```eiffel
make
    ensure
        config_created: config /= Void
        registry_created: registry /= Void
```

### install
```eiffel
install (a_name: STRING)
    require
        name_not_empty: not a_name.is_empty
```

### install_multiple
```eiffel
install_multiple (a_names: ARRAY [STRING])
    require
        names_not_empty: not a_names.is_empty
```

### update
```eiffel
update (a_name: STRING)
    require
        name_not_empty: not a_name.is_empty
```

### search
```eiffel
search (a_query: STRING): ARRAYED_LIST [PKG_INFO]
    require
        query_not_empty: not a_query.is_empty
    ensure
        result_attached: Result /= Void
```

### info
```eiffel
info (a_name: STRING): detachable PKG_INFO
    require
        name_not_empty: not a_name.is_empty
```

### is_installed
```eiffel
is_installed (a_name: STRING): BOOLEAN
    require
        name_not_empty: not a_name.is_empty
```

## PKG_CONFIG Contracts

### normalize_package_name
```eiffel
normalize_package_name (a_name: STRING): STRING
    require
        name_not_empty: not a_name.is_empty
    ensure
        result_starts_with_simple: Result.starts_with ("simple_")
        result_lowercase: Result.same_string (Result.as_lower)
```

## Invariants

### SIMPLE_PKG
```eiffel
invariant
    config_exists: config /= Void
    registry_exists: registry /= Void
    resolver_exists: resolver /= Void
    installer_exists: installer /= Void
    errors_exist: last_errors /= Void
```

### PKG_CONFIG
```eiffel
invariant
    install_directory_not_empty: not install_directory.is_empty
    cache_directory_not_empty: not cache_directory.is_empty
    config_directory_not_empty: not config_directory.is_empty
```
