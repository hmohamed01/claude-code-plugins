# powershell-developer

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-Windows-lightgrey.svg)](https://docs.microsoft.com/en-us/powershell/)
[![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-blue.svg)](https://github.com/PowerShell/PowerShell)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet)](https://github.com/anthropics/claude-code)

Autonomous PowerShell development agent for Claude Code. Provides expert assistance with PowerShell scripts, modules, Windows Forms/WPF GUIs, and automation tasks.

## Features

- **Script Development**: Production-quality PowerShell scripts with proper structure, parameters, and documentation
- **Module Creation**: PowerShell modules with manifest files and Gallery-ready packaging
- **GUI Development**: Windows Forms and WPF interfaces for interactive tools
- **Code Review**: Best practices analysis, naming conventions, and error handling verification
- **Gallery Integration**: Module verification and recommendations from PowerShell Gallery
- **Pattern Detection**: Hooks warn about common PowerShell anti-patterns

## Installation

Add the plugin marketplace to Claude Code:

```bash
claude plugin marketplace add hmohamed01/claude-code-plugins
```

Then use `/plugins` to install powershell-developer from the marketplace.

## Usage

### Invoke the Agent

The agent triggers when you explicitly request PowerShell development help:

```
"Help me create a PowerShell module for user management"
"Build a Windows Forms dialog for file selection"
"Review my PowerShell script for best practices"
"Is there a module for working with Excel files?"
```

### Slash Command

Use the slash command for direct invocation:

```
/powershell-developer create a function to get disk space usage
/powershell-developer review my script for anti-patterns
```

## Components

### Agent

The `powershell-developer` agent provides:
- Module verification via PowerShell Gallery
- Code review for PowerShell-specific issues
- Best practices guidance
- GUI development patterns

### Skill

The `powershell-knowledge` skill includes:
- Script structure templates
- Function design patterns
- GUI development reference (Windows Forms, WPF)
- PowerShellGet cmdlet reference
- Utility scripts for Gallery searches

### Hooks

Pre-write hooks warn about:
- Aliases in scripts (gci, ls, rm, etc.)
- Missing `[CmdletBinding()]` on functions
- Hardcoded credentials
- Missing `-ErrorAction Stop` in try/catch
- Non-approved verbs in function names
- Misuse of `Write-Host`

## Reference Documentation

| Topic | Description |
|-------|-------------|
| `references/best-practices.md` | Naming, parameters, pipeline, error handling |
| `references/gui-development.md` | Windows Forms, WPF, controls, events |
| `references/powershellget.md` | Find, install, update, publish modules |

## Scripts

| Script | Purpose |
|--------|---------|
| `scripts/Search-Gallery.ps1` | Enhanced PowerShell Gallery search |

## Best Practices Enforced

### DO
- Use `[CmdletBinding()]` on all functions
- Use approved verbs from `Get-Verb`
- Use `-ErrorAction Stop` with try/catch
- Write comment-based help
- Use strong typing with validation attributes
- Stream output in pipeline

### DON'T
- Use aliases in scripts
- Store credentials in plain text
- Use `Write-Host` for normal output
- Ignore PSScriptAnalyzer warnings

## Requirements

- Claude Code CLI
- PowerShell 5.1+ (for running scripts)
- Windows (for GUI development features)

## License

MIT
