# S06-BOUNDARIES: simple_pkg

**BACKWASH DOCUMENT** - Generated retroactively from existing implementation
**Date**: 2026-01-23
**Library**: simple_pkg
**Status**: Production

## System Boundaries

### Component Architecture

```
+-------------------+
|      User         |
+--------+----------+
         |
         v
+--------+----------+
|     PKG_CLI       |
|  (Command Line)   |
+--------+----------+
         |
         v
+--------+----------+
|    SIMPLE_PKG     |
|     (Facade)      |
+--------+----------+
    |    |    |
    v    v    v
+-----+ +-----+ +------+
|REG  | |INST | |RESOLV|
|(API)| |(Git)| |(ECF) |
+--+--+ +--+--+ +--+---+
   |       |       |
   v       v       v
+------+ +----+ +-----+
|GitHub| |Git | |Files|
|(REST)| |CLI | |(.ecf)|
+------+ +----+ +-----+
```

### External Interfaces

| Interface | Protocol | Purpose |
|-----------|----------|---------|
| GitHub API | HTTPS REST | Package discovery |
| Git | CLI | Repository cloning |
| File System | Local | ECF parsing, config |
| Environment | OS API | Variable management |

### Input Boundaries

| Input | Source | Validation |
|-------|--------|------------|
| Package Name | CLI | Non-empty |
| Version Spec | CLI | Optional |
| Search Query | CLI | Non-empty |
| ECF Path | File System | File exists |

### Output Boundaries

| Output | Target | Format |
|--------|--------|--------|
| Console | Terminal | Text/Color |
| Config | File | JSON |
| Environment | OS | Variables |
| Installed Code | Directory | Git repo |

## Trust Boundaries

### Trusted
- simple-eiffel GitHub org
- Local file system
- EiffelStudio compiler

### Untrusted
- Network responses
- User input
- Downloaded code (must review)
