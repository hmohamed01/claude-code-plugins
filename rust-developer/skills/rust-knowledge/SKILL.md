---
name: rust-knowledge
description: >
  Comprehensive Rust development knowledge for systems programming, web services, and CLI applications.
  Use when working with: (1) cargo commands and Cargo.toml configuration, (2) Ownership, borrowing, and lifetimes,
  (3) Error handling with Result and Option, (4) Async Rust with Tokio and async/await,
  (5) Testing with cargo test and test patterns, (6) Clippy linting and rustfmt formatting,
  (7) WebAssembly with wasm-pack, (8) Web frameworks like Axum, Actix, and Rocket.
version: 1.0.0
---

# Rust Development Knowledge

## Prerequisites

- Rust toolchain installed via rustup: `curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh`
- Verify: `rustc --version` and `cargo --version`
- Recommended: `rustup component add clippy rustfmt`

## Quick Reference

### Essential Commands

| Task | Command |
|------|---------|
| New project | `cargo new project-name` |
| New library | `cargo new --lib lib-name` |
| Build debug | `cargo build` |
| Build release | `cargo build --release` |
| Run project | `cargo run` |
| Run tests | `cargo test` |
| Check code | `cargo check` |
| Lint code | `cargo clippy` |
| Format code | `cargo fmt` |
| Update deps | `cargo update` |
| Add dependency | `cargo add crate-name` |
| Generate docs | `cargo doc --open` |

### Common Cargo Options

```bash
# Run specific test
cargo test test_name

# Run tests with output
cargo test -- --nocapture

# Check specific target
cargo check --target wasm32-unknown-unknown

# Build with features
cargo build --features "feature1 feature2"

# Build all targets
cargo build --all-targets
```

## Official Documentation & WebFetch Verification

**IMPORTANT**: Use `WebFetch` to verify implementations against official Rust documentation. Always fetch and check documentation when:
- Implementing Rust language features (ownership, lifetimes, traits, etc.)
- Working with async/await patterns
- Using unsafe Rust
- Uncertain about correct syntax or behavior
- User asks about specific Rust language behavior

### How to Use WebFetch

```
WebFetch URL: <documentation-url>
Prompt: "Extract the key concepts, syntax examples, and best practices for <topic>"
```

### Rust Book Documentation (GitHub)

Base URL: `https://raw.githubusercontent.com/rust-lang/book/main/src/`

| Topic | WebFetch URL |
|-------|-----|
| Ownership | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch04-00-understanding-ownership.md` |
| References & Borrowing | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch04-02-references-and-borrowing.md` |
| Lifetimes | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch10-03-lifetime-syntax.md` |
| Error Handling | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch09-00-error-handling.md` |
| Traits | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch10-02-traits.md` |
| Generics | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch10-01-syntax.md` |
| Closures | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch13-01-closures.md` |
| Iterators | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch13-02-iterators.md` |
| Smart Pointers | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch15-00-smart-pointers.md` |
| Concurrency | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch16-00-concurrency.md` |
| Async/Await | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch17-00-async-await.md` |
| Unsafe Rust | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch19-01-unsafe-rust.md` |
| Macros | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch19-06-macros.md` |
| Testing | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch11-00-testing.md` |
| Cargo & Crates | `https://raw.githubusercontent.com/rust-lang/book/main/src/ch14-00-more-about-cargo.md` |

### Additional Documentation Sources (WebFetch Compatible)

Use `WebFetch` with any of these URLs to verify patterns and implementations:

| Topic | WebFetch URL |
|-------|-----|
| Rust Reference | `https://doc.rust-lang.org/reference/` |
| Rustonomicon (Unsafe) | `https://doc.rust-lang.org/nomicon/` |
| Rust by Example | `https://doc.rust-lang.org/rust-by-example/` |
| Async Book | `https://rust-lang.github.io/async-book/` |
| Tokio Tutorial | `https://tokio.rs/tokio/tutorial` |
| Cargo Book | `https://raw.githubusercontent.com/rust-lang/cargo/master/src/doc/src/index.md` |

### Crate Documentation (docs.rs)

For crate-specific documentation, use WebFetch with docs.rs:

| Crate | WebFetch URL |
|-------|-----|
| tokio | `https://docs.rs/tokio/latest/tokio/` |
| serde | `https://docs.rs/serde/latest/serde/` |
| axum | `https://docs.rs/axum/latest/axum/` |
| actix-web | `https://docs.rs/actix-web/latest/actix_web/` |
| sqlx | `https://docs.rs/sqlx/latest/sqlx/` |
| thiserror | `https://docs.rs/thiserror/latest/thiserror/` |
| anyhow | `https://docs.rs/anyhow/latest/anyhow/` |

**Example**: To verify tokio channel usage:
```
WebFetch URL: https://docs.rs/tokio/latest/tokio/sync/mpsc/index.html
Prompt: "Extract usage examples and best practices for tokio mpsc channels"
```

## Reference Files

Detailed documentation for specific topics:

| Topic | File |
|-------|------|
| Ownership & Borrowing | [references/ownership.md](references/ownership.md) |
| Error Handling | [references/error-handling.md](references/error-handling.md) |
| Async Rust | [references/async-rust.md](references/async-rust.md) |
| Testing Patterns | [references/testing.md](references/testing.md) |
| Cargo Deep Dive | [references/cargo.md](references/cargo.md) |
| Clippy Lints | [references/clippy.md](references/clippy.md) |
| WebAssembly | [references/wasm.md](references/wasm.md) |
| Web Frameworks | [references/frameworks.md](references/frameworks.md) |
| Troubleshooting | [references/troubleshooting.md](references/troubleshooting.md) |

## Included Scripts

| Script | Purpose |
|--------|---------|
| `scripts/new_project.sh` | Create new Rust project with config files |
| `scripts/run_tests.sh` | Run tests with common options |
| `scripts/format_lint.sh` | Format and lint Rust code |

Run scripts from the skill directory:
```bash
$CLAUDE_PLUGIN_ROOT/skills/rust-knowledge/scripts/new_project.sh my-project
```

## Asset Templates

| Asset | Purpose |
|-------|---------|
| `assets/Cargo.toml.template` | Cargo manifest template |
| `assets/rustfmt.toml` | Rustfmt configuration |
| `assets/clippy.toml` | Clippy configuration |

## Common Patterns

### Error Handling

```rust
// Using ? operator with Result
fn read_config(path: &str) -> Result<Config, ConfigError> {
    let content = fs::read_to_string(path)?;
    let config: Config = toml::from_str(&content)?;
    Ok(config)
}

// Custom error type with thiserror
#[derive(Debug, thiserror::Error)]
enum AppError {
    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),
    #[error("Parse error: {0}")]
    Parse(#[from] serde_json::Error),
}
```

### Async Patterns

```rust
// Tokio async main
#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let result = fetch_data().await?;
    Ok(())
}

// Concurrent tasks
let (a, b) = tokio::join!(task_a(), task_b());

// Spawning tasks
let handle = tokio::spawn(async move {
    // background work
});
```

### Builder Pattern

```rust
#[derive(Default)]
struct ServerBuilder {
    host: String,
    port: u16,
}

impl ServerBuilder {
    fn host(mut self, host: impl Into<String>) -> Self {
        self.host = host.into();
        self
    }

    fn port(mut self, port: u16) -> Self {
        self.port = port;
        self
    }

    fn build(self) -> Server {
        Server { host: self.host, port: self.port }
    }
}
```

## Best Practices Summary

### DO
- Use `Result` and `?` for error propagation
- Prefer `&str` over `String` in function parameters
- Use `clippy` and fix all warnings
- Write unit tests alongside code
- Use `#[must_use]` for functions with important return values
- Prefer iterators over manual loops
- Use `derive` macros for common traits

### DON'T
- Use `.unwrap()` in production code (prefer `.expect()` with context)
- Ignore clippy warnings
- Use `unsafe` without strong justification
- Clone unnecessarily (check if borrowing works)
- Use `String` when `&str` suffices
- Panic in library code (return `Result` instead)
