# CLAUDE.md

This file provides guidance to Claude Code when working on the sql-developer plugin.

## Plugin Purpose

This plugin provides an autonomous SQL Server development agent for Claude Code. It assists with:
- T-SQL query writing and optimization
- Stored procedure development with best practices
- Execution plan analysis and performance tuning
- Code review for SQL-specific issues
- Live syntax verification against Microsoft documentation

## Key Features

- **Syntax Verification**: Agent uses WebFetch/WebSearch to verify T-SQL syntax against official Microsoft docs on GitHub
- **Pattern Detection**: Hooks warn about unsafe SQL patterns (injection, NOLOCK abuse, missing error handling)
- **Comprehensive Knowledge**: Includes reference docs for patterns, performance, security, data types, and transactions

## Structure

```
sql-developer/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── agents/
│   └── sql-developer.md    # Main agent definition
├── skills/
│   └── sql-knowledge/
│       ├── SKILL.md        # Skill definition
│       └── references/     # Detailed documentation
├── commands/
│   └── sql-developer.md    # Slash command
├── hooks/
│   ├── hooks.json          # Hook configuration
│   └── scripts/            # Hook scripts
└── CLAUDE.md               # This file
```

## Development Notes

- Agent triggers on explicit request (not proactively)
- Hooks warn about patterns but don't block writes (advisory mode)
- Scripts use `$CLAUDE_PLUGIN_ROOT` for portability
- Reference files provide detailed guidance for specific T-SQL topics

## Conventions

- Use parameterized queries (sp_executesql) for dynamic SQL
- Include TRY...CATCH with proper transaction handling
- Avoid NOLOCK unless specifically needed for dirty reads
- Use appropriate data types (NVARCHAR for Unicode, DATETIME2 over DATETIME)
- Validate all user input in stored procedures
