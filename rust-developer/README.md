# rust-developer

A Claude Code plugin for comprehensive Rust development assistance.

## Features

- **Build & Test**: Build and test Rust projects with cargo
- **Dependency Management**: Manage Cargo.toml dependencies and features
- **Best Practices**: Apply Rust idioms, ownership patterns, and error handling
- **Linting & Formatting**: Run clippy for linting and rustfmt for formatting
- **Async Rust**: Implement async patterns with Tokio
- **WebAssembly**: Build WASM targets with wasm-pack
- **Web Frameworks**: Support for Axum, Actix, and Rocket
- **Code Review**: Detect unsafe patterns and anti-patterns
- **Documentation Verification**: Verify implementations against Rust Book

## Installation

```bash
claude plugins add hatem/claude-code-plugins/rust-developer
```

Or for local development:

```bash
claude plugins add ./rust-developer
```

## Prerequisites

- Rust toolchain installed via rustup
- Verify: `rustc --version` and `cargo --version`
- Recommended: `rustup component add clippy rustfmt`

## Components

| Component | Name | Purpose |
|-----------|------|---------|
| Skill | rust-knowledge | Rust development knowledge and patterns |
| Agent | rust-developer | Autonomous Rust development tasks |
| Hooks | PreToolUse | Detect unsafe patterns in Rust code |

## Usage

### Skill Activation

The `rust-knowledge` skill activates automatically when:
- Working with `.rs` files or `Cargo.toml`
- Asking about ownership, borrowing, or lifetimes
- Discussing async Rust, Tokio, or concurrency
- Working with cargo commands

### Agent Usage

The `rust-developer` agent handles complex Rust tasks:

```
Help me create a new async HTTP client library
```

```
Review my Rust code for ownership issues
```

```
Run clippy and fix the warnings
```

### Hooks

The plugin includes hooks that warn about:
- Hardcoded secrets/API keys
- `panic!` in library code
- Multiple `.unwrap()` without `.expect()` context
- `unsafe` blocks without `// SAFETY:` comments
- Blocking operations in async functions

## Reference Documentation

The skill includes detailed reference files:

| Topic | Description |
|-------|-------------|
| Ownership | Ownership, borrowing, and lifetimes |
| Error Handling | Result, Option, thiserror, anyhow |
| Async Rust | Tokio, async/await, channels |
| Testing | Unit tests, integration tests, mocking |
| Cargo | Cargo.toml, workspaces, features |
| Clippy | Linting rules and configuration |
| WebAssembly | wasm-pack, wasm-bindgen |
| Frameworks | Axum, Actix, Rocket patterns |
| Troubleshooting | Common errors and solutions |

## Utility Scripts

| Script | Purpose |
|--------|---------|
| `new_project.sh` | Create new Rust project with config files |
| `run_tests.sh` | Run tests with common options |
| `format_lint.sh` | Format and lint Rust code |

## Structure

```
rust-developer/
├── .claude-plugin/
│   └── plugin.json
├── agents/
│   └── rust-developer.md
├── skills/
│   └── rust-knowledge/
│       ├── SKILL.md
│       ├── references/
│       ├── scripts/
│       └── assets/
├── hooks/
│   ├── hooks.json
│   └── scripts/
├── CLAUDE.md
└── README.md
```

## License

MIT
