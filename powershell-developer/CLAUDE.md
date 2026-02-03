# CLAUDE.md

This file provides guidance to Claude Code when working on the powershell-developer plugin.

## Plugin Purpose

This plugin provides an autonomous PowerShell development agent for Claude Code. It assists with:
- PowerShell script development with best practices
- Module creation and Gallery publishing
- Windows Forms and WPF GUI development
- Windows automation tasks
- Code review for PowerShell-specific issues
- PowerShell Gallery module verification

## Key Features

- **Module Verification**: Agent uses WebFetch/WebSearch to verify modules exist on PowerShell Gallery before recommending
- **Pattern Detection**: Hooks warn about unsafe PowerShell patterns (aliases, missing CmdletBinding, hardcoded credentials)
- **Comprehensive Knowledge**: Includes reference docs for best practices, GUI development, and PowerShellGet

## Structure

```
powershell-developer/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── agents/
│   └── powershell-developer.md  # Main agent definition
├── skills/
│   └── powershell-knowledge/
│       ├── SKILL.md        # Skill definition
│       ├── references/     # Detailed documentation
│       └── scripts/        # Utility scripts
├── commands/
│   └── powershell-developer.md  # Slash command
├── hooks/
│   ├── hooks.json          # Hook configuration
│   └── scripts/            # Hook scripts
└── CLAUDE.md               # This file
```

## Development Notes

- Agent triggers on explicit request (not proactively)
- Hooks warn about patterns but don't block writes (advisory mode)
- Scripts use `$CLAUDE_PLUGIN_ROOT` for portability
- Reference files provide detailed guidance for specific topics

## Conventions

- Follow PowerShell naming conventions (Verb-Noun)
- Use approved verbs from `Get-Verb`
- Always include `[CmdletBinding()]` on functions
- Use `-ErrorAction Stop` in try/catch blocks
- Avoid aliases in scripts
- Store secrets securely, never in plain text
