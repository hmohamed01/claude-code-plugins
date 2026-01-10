# Cargo Deep Dive

## Cargo.toml Structure

```toml
[package]
name = "my-project"
version = "0.1.0"
edition = "2021"
authors = ["Name <email@example.com>"]
description = "A short description"
license = "MIT"
repository = "https://github.com/user/repo"
documentation = "https://docs.rs/my-project"
readme = "README.md"
keywords = ["keyword1", "keyword2"]
categories = ["category"]

# Rust version requirement
rust-version = "1.70"

[dependencies]
serde = "1.0"
tokio = { version = "1", features = ["full"] }

[dev-dependencies]
criterion = "0.5"

[build-dependencies]
cc = "1.0"

[features]
default = ["std"]
std = []
async = ["tokio"]

[[bin]]
name = "my-binary"
path = "src/bin/main.rs"

[[example]]
name = "demo"
path = "examples/demo.rs"

[profile.release]
opt-level = 3
lto = true
```

## Dependency Specification

### Version Requirements

```toml
[dependencies]
# Caret (default) - compatible updates
serde = "^1.0.0"  # >= 1.0.0, < 2.0.0
serde = "1.0"     # same as ^1.0

# Tilde - patch updates only
serde = "~1.0.0"  # >= 1.0.0, < 1.1.0

# Exact version
serde = "=1.0.0"

# Wildcard
serde = "1.*"

# Range
serde = ">=1.0, <2.0"
```

### Dependency Sources

```toml
[dependencies]
# crates.io (default)
serde = "1.0"

# Git repository
my-crate = { git = "https://github.com/user/repo" }
my-crate = { git = "https://github.com/user/repo", branch = "main" }
my-crate = { git = "https://github.com/user/repo", tag = "v1.0" }
my-crate = { git = "https://github.com/user/repo", rev = "abc123" }

# Local path
my-crate = { path = "../my-crate" }

# Multiple sources (path for dev, crates.io for publish)
my-crate = { version = "1.0", path = "../my-crate" }
```

### Optional Dependencies

```toml
[dependencies]
serde = { version = "1.0", optional = true }

[features]
serialization = ["serde"]
```

## Features

```toml
[features]
# Default features enabled
default = ["std", "logging"]

# Individual features
std = []
logging = ["log"]
async = ["tokio/rt-multi-thread", "tokio/macros"]

# Feature that enables optional dependency
serde = ["dep:serde"]
```

### Using Features

```bash
# Enable specific features
cargo build --features "async logging"

# Disable default features
cargo build --no-default-features

# Enable all features
cargo build --all-features
```

## Workspaces

```toml
# Root Cargo.toml
[workspace]
members = [
    "crates/core",
    "crates/cli",
    "crates/web",
]
resolver = "2"

[workspace.package]
version = "0.1.0"
edition = "2021"
license = "MIT"

[workspace.dependencies]
serde = "1.0"
tokio = { version = "1", features = ["full"] }
```

```toml
# crates/core/Cargo.toml
[package]
name = "my-core"
version.workspace = true
edition.workspace = true

[dependencies]
serde.workspace = true
```

## Build Profiles

```toml
# Development (cargo build)
[profile.dev]
opt-level = 0
debug = true
overflow-checks = true

# Release (cargo build --release)
[profile.release]
opt-level = 3
debug = false
lto = true
codegen-units = 1
panic = "abort"

# Testing
[profile.test]
opt-level = 0
debug = true

# Benchmarking
[profile.bench]
opt-level = 3
debug = false

# Custom profile
[profile.release-with-debug]
inherits = "release"
debug = true
```

## Cargo Commands

### Build Commands

```bash
cargo build              # Debug build
cargo build --release    # Release build
cargo build --target x86_64-unknown-linux-gnu

cargo check              # Type check without building
cargo clean              # Remove target directory
```

### Run Commands

```bash
cargo run                # Run default binary
cargo run --bin name     # Run specific binary
cargo run --example demo # Run example
cargo run -- arg1 arg2   # Pass arguments
```

### Test Commands

```bash
cargo test               # Run all tests
cargo test name          # Run tests matching name
cargo test --doc         # Run doc tests only
cargo test --lib         # Run library tests only
cargo test --bins        # Run binary tests only
```

### Documentation

```bash
cargo doc                # Generate docs
cargo doc --open         # Generate and open
cargo doc --no-deps      # Skip dependencies
```

### Publishing

```bash
cargo publish            # Publish to crates.io
cargo publish --dry-run  # Check without publishing
cargo package            # Create .crate file
cargo yank --version 1.0.0  # Yank version
```

### Dependency Management

```bash
cargo add serde                    # Add dependency
cargo add tokio --features full    # With features
cargo add serde --dev              # Dev dependency
cargo remove serde                 # Remove dependency
cargo update                       # Update Cargo.lock
cargo update -p serde              # Update specific crate
cargo tree                         # Show dependency tree
cargo tree -d                      # Show duplicates
```

## Cargo.lock

- **Libraries**: Don't commit (users get latest compatible)
- **Applications**: Commit (reproducible builds)

```bash
# Update lock file
cargo update

# Check for outdated deps
cargo outdated  # requires cargo-outdated
```

## Cross-Compilation

```bash
# Add target
rustup target add wasm32-unknown-unknown

# Build for target
cargo build --target wasm32-unknown-unknown

# List available targets
rustup target list
```

### .cargo/config.toml

```toml
[build]
target = "x86_64-unknown-linux-gnu"

[target.x86_64-unknown-linux-gnu]
linker = "x86_64-linux-gnu-gcc"

[alias]
b = "build"
t = "test"
r = "run"
```

## Useful Cargo Plugins

```bash
cargo install cargo-edit      # cargo add/rm/upgrade
cargo install cargo-watch     # Auto-rebuild on changes
cargo install cargo-expand    # Expand macros
cargo install cargo-outdated  # Check outdated deps
cargo install cargo-audit     # Security audit
cargo install cargo-deny      # Lint dependencies
cargo install cargo-release   # Release automation
cargo install cargo-criterion # Benchmarking
```
