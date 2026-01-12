# Claude Code Plugins

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Plugins](https://img.shields.io/badge/plugins-2-orange.svg)](#plugins)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet.svg)](https://claude.ai/code)
[![GitHub stars](https://img.shields.io/github/stars/hmohamed01/claude-code-plugins?style=social)](https://github.com/hmohamed01/claude-code-plugins)

A collection of plugins for [Claude Code](https://claude.ai/code) that extend its capabilities with specialized agents, skills, and hooks.

## Plugins

| Plugin | Command | Description |
|--------|---------|-------------|
| [swift-developer](./swift-developer) | `/swift-developer` | Autonomous Swift development agent for iOS/macOS apps, Swift packages, SwiftUI, and Swift 6 concurrency |
| [rust-developer](./rust-developer) | `/rust-developer` | Comprehensive Rust development with cargo, clippy, async patterns, WebAssembly, and framework support |

## Quick Start

After installing from the marketplace, invoke any plugin agent directly:

```
/swift-developer create a SwiftUI settings screen with @Observable
/rust-developer help me implement error handling with thiserror
```

## Installation

Add this plugin marketplace to Claude Code:

```bash
claude plugin marketplace add hmohamed01/claude-code-plugins
```

Then use `/plugins` to browse and install plugins from the marketplace.

## Structure

Each plugin is an independent project with its own:

- `.claude-plugin/plugin.json` - Plugin manifest
- `README.md` - Documentation
- `agents/` - Autonomous agent definitions
- `skills/` - Knowledge and reference content
- `hooks/` - Event-driven automation
- `commands/` - Slash commands (if applicable)

## Contributing

Each plugin follows the [Claude Code plugin structure](https://docs.anthropic.com/en/docs/claude-code/plugins). See individual plugin READMEs for specific details.

## License

MIT
