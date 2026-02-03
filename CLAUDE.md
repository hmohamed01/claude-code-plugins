# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Session Start

At the start of each session, read:
- `CLAUDE.md` (this file) - Repository-wide guidance
- `CHANGELOG.md` - Recent changes and version history

## Repository Purpose

This is a monorepo for **Claude Code plugins**. Each plugin is an independent project with its own folder and CLAUDE.md at the root level.

## Structure

```
claude-code-plugins/
├── CLAUDE.md              # This file - repo-wide guidance
├── CHANGELOG.md           # Version history and recent changes
├── README.md              # Repository overview and plugin list
├── .claude-plugin/
│   └── marketplace.json   # Plugin marketplace manifest
├── <plugin-name>/         # Each plugin is an independent project
│   ├── CLAUDE.md          # Plugin-specific instructions
│   ├── .claude-plugin/
│   │   └── plugin.json    # Plugin manifest (required)
│   ├── skills/            # Skill definitions
│   ├── agents/            # Agent configurations
│   ├── commands/          # Slash commands
│   ├── hooks/             # Event-driven automation
│   └── README.md          # Plugin documentation
└── <another-plugin>/
    └── ...
```

## Conventions

- **Each plugin is a project**: Treat each plugin folder as an independent project
- **Plugin-specific CLAUDE.md**: Each plugin has its own CLAUDE.md for project-specific guidance
- **Folder naming**: Use kebab-case for plugin folder names (e.g., `my-plugin`)
- **Independence**: Plugins should be self-contained and not depend on other plugins in this repo

## Commands

Common operations for plugin development:
- Add marketplace: `claude plugin marketplace add hmohamed01/claude-code-plugins`
- Install a plugin: Use `/plugins` to browse and install from marketplace
- Test locally: `claude --plugin-dir ./plugin-name`
