# CLAUDE.md

This file provides guidance to Claude Code when working on the swift-developer plugin.

## Plugin Purpose

This plugin provides an autonomous Swift development agent for Claude Code. It assists with:
- iOS/macOS application development
- Swift package creation and management
- SwiftUI development with modern patterns
- Swift 6 concurrency (async/await, actors, Sendable)
- Building and testing with xcodebuild
- Code review for Swift-specific issues

## Key Features

- **Apple Documentation Verification**: Agent uses WebFetch to verify code against official Apple documentation before implementing SwiftUI/framework code
- **Unsafe Pattern Detection**: Hooks block writes containing unsafe Swift patterns (force unwraps, hardcoded secrets, main thread blocking)
- **Comprehensive Knowledge**: Includes scripts for project scaffolding, testing, linting, and simulator management

## Structure

```
swift-developer/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── agents/
│   └── swift-developer.md  # Main agent definition
├── skills/
│   └── swift-knowledge/
│       ├── SKILL.md        # Skill definition
│       ├── references/     # Detailed documentation
│       ├── scripts/        # Utility scripts
│       └── assets/         # Templates and configs
├── hooks/
│   ├── hooks.json          # Hook configuration
│   └── scripts/            # Hook scripts
└── CLAUDE.md               # This file
```

## Development Notes

- Agent triggers on explicit request (not proactively)
- Hooks run in strict mode (block unsafe patterns)
- Scripts use `$CLAUDE_PLUGIN_ROOT` for portability
- Reference files provide detailed guidance for specific topics
