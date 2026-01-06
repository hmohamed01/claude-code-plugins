# Claude Code Plugins

A collection of plugins for [Claude Code](https://claude.ai/code) that extend its capabilities with specialized agents, skills, and hooks.

## Plugins

| Plugin | Description |
|--------|-------------|
| [swift-developer](./swift-developer) | Autonomous Swift development agent for iOS/macOS apps, Swift packages, SwiftUI, and Swift 6 concurrency |

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
