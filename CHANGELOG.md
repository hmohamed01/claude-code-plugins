# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [2026-02-03]

### Added
- **powershell-developer** plugin (v0.1.0)
  - Autonomous agent for PowerShell scripts, modules, and Windows Forms/WPF GUIs
  - Skill imported from powershell-expert with best practices, GUI development, and PowerShellGet references
  - PreToolUse hooks for pattern detection (aliases, missing CmdletBinding, hardcoded credentials)
  - PowerShell Gallery module verification via WebFetch/WebSearch
  - Slash command `/powershell-developer:powershell-developer`

### Fixed
- rust-developer installation instructions now use marketplace format
- swift-developer force unwrap detection now works at end of line
- powershell-developer hook grep syntax error causing "0\n0" output
- Standardized rust-developer hook output format to match other plugins
- Consistent `${CLAUDE_PLUGIN_ROOT}` usage in all hooks.json files
- Replaced deprecated `TodoWrite` with `TaskCreate`/`TaskUpdate`/`TaskList` in all agents

## [2026-01-12]

### Added
- Demo image to root README showcasing plugin usage
- shields.io badges to all plugin READMEs (license, platform, language, Claude Code)
- Slash command support for swift-developer and rust-developer plugins

### Fixed
- Slash command format in all READMEs (plugin:command syntax)
- rust-developer hooks.json schema validation
- Usage examples updated to show inline task format

## [2026-01-10]

### Added
- **rust-developer** plugin (v0.2.0)
  - Autonomous agent for Rust development with cargo, clippy, async patterns
  - rust-knowledge skill with ownership, error handling, async, testing references
  - PreToolUse hooks for unsafe pattern detection
  - WebAssembly and web framework support (Axum, Actix, Rocket)
  - Utility scripts for project creation, testing, and linting

### Changed
- Removed version field from skill frontmatter (not required)

## [2026-01-05]

### Added
- **swift-developer** plugin (v0.2.0)
  - Autonomous agent for iOS/macOS development, Swift packages, SwiftUI
  - swift-knowledge skill with concurrency, testing, architecture references
  - PreToolUse hooks for unsafe Swift pattern detection (force unwraps, hardcoded secrets)
  - Apple documentation verification via WebFetch (GitHub-based sources)
  - Utility scripts for package creation, testing, formatting, and simulator management
- Monorepo structure with root README listing all plugins
- marketplace.json for plugin installation via Claude Code marketplace
- GitHub Sponsors configuration

### Changed
- Linked swift-developer agent to swift-knowledge skill for reference file access
- Simplified installation instructions to use marketplace

---

## Plugin Versions

| Plugin | Current Version | Initial Release |
|--------|-----------------|-----------------|
| swift-developer | 0.3.0 | 2026-01-05 |
| rust-developer | 0.2.0 | 2026-01-10 |
| powershell-developer | 0.1.0 | 2026-02-03 |
