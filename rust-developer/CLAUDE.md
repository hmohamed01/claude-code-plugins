# CLAUDE.md

This file provides guidance to Claude Code when working with the rust-developer plugin.

## Plugin Purpose

The rust-developer plugin provides comprehensive Rust development assistance, including:
- Building and testing Rust projects with cargo
- Ownership, borrowing, and lifetime patterns
- Error handling with Result/Option
- Async Rust with Tokio
- Web frameworks (Axum, Actix, Rocket)
- WebAssembly with wasm-pack
- Code review for Rust-specific issues

## Key Features

- **Documentation Verification**: Agent uses WebFetch to verify code against Rust Book before implementing
- **Unsafe Pattern Detection**: Hooks warn about unsafe Rust patterns (unwrap abuse, missing SAFETY comments, blocking in async)
- **Comprehensive Knowledge**: Includes reference docs for ownership, async, testing, frameworks, and more

## Structure

```
rust-developer/
├── .claude-plugin/
│   └── plugin.json         # Plugin manifest
├── agents/
│   └── rust-developer.md   # Main agent definition
├── skills/
│   └── rust-knowledge/
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
- Hooks warn about patterns but don't block writes
- Scripts use `$CLAUDE_PLUGIN_ROOT` for portability
- Reference files provide detailed guidance for specific topics

## Commands

Common Rust operations:
- Build: `cargo build` / `cargo build --release`
- Test: `cargo test`
- Check: `cargo check`
- Lint: `cargo clippy`
- Format: `cargo fmt`

## Conventions

- Follow Rust idioms and clippy recommendations
- Use Result/Option over panics
- Prefer borrowing over cloning
- Add SAFETY comments for unsafe blocks
- Write idiomatic error handling with thiserror/anyhow
