# CLAUDE.md

This file provides guidance to Claude Code when working with this repository.

## Repository Purpose

This is a monorepo for **Claude Code plugins**. Each plugin is an independent project with its own folder and CLAUDE.md at the root level.

## Structure

```
claude-code-plugins/
├── CLAUDE.md              # This file - repo-wide guidance
├── <plugin-name>/         # Each plugin is an independent project
│   ├── CLAUDE.md          # Plugin-specific instructions
│   ├── plugin.json        # Plugin manifest (required)
│   ├── skills/            # Skill definitions
│   ├── agents/            # Agent configurations
│   └── ...                # Plugin-specific files
└── <another-plugin>/
    ├── CLAUDE.md
    └── ...
```

## Conventions

- **Each plugin is a project**: Treat each plugin folder as an independent project
- **Plugin-specific CLAUDE.md**: Each plugin has its own CLAUDE.md for project-specific guidance
- **Folder naming**: Use kebab-case for plugin folder names (e.g., `my-plugin`)
- **Independence**: Plugins should be self-contained and not depend on other plugins in this repo

## Commands

Common operations for plugin development:
- Install a plugin locally: `claude plugins add ./plugin-name`
- Test a plugin: Work within the plugin directory
