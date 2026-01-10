# Clippy - Rust Linter

## Running Clippy

```bash
# Basic usage
cargo clippy

# All targets
cargo clippy --all-targets

# With all features
cargo clippy --all-features

# Treat warnings as errors
cargo clippy -- -D warnings

# Fix automatically
cargo clippy --fix
```

## Configuration

### clippy.toml

```toml
# Place in project root
cognitive-complexity-threshold = 30
too-many-arguments-threshold = 10
type-complexity-threshold = 500
single-char-binding-names-threshold = 5
```

### Inline Configuration

```rust
// Allow specific lint for item
#[allow(clippy::too_many_arguments)]
fn complex_function(a: i32, b: i32, c: i32, d: i32, e: i32, f: i32, g: i32) {}

// Warn instead of allow
#[warn(clippy::unwrap_used)]
fn strict_function() {}

// Deny (error) for item
#[deny(clippy::panic)]
fn no_panics_here() {}
```

### Crate-Level Configuration

```rust
// At top of lib.rs or main.rs
#![warn(clippy::all)]
#![warn(clippy::pedantic)]
#![allow(clippy::module_name_repetitions)]
```

## Lint Categories

### clippy::all (Default)

Common, uncontroversial lints. Always fix these.

### clippy::pedantic

Stricter lints. May have false positives.

```rust
#![warn(clippy::pedantic)]
#![allow(clippy::must_use_candidate)]
#![allow(clippy::missing_errors_doc)]
```

### clippy::nursery

New, experimental lints. May change.

### clippy::cargo

Cargo.toml lints.

```bash
cargo clippy -- -W clippy::cargo
```

### clippy::restriction

Very strict, not recommended to enable all.

```rust
// Enable specific restriction lints
#![warn(clippy::unwrap_used)]
#![warn(clippy::expect_used)]
```

## Common Lints and Fixes

### Unnecessary Operations

```rust
// BAD: clippy::redundant_clone
let s = String::from("hello").clone();

// GOOD
let s = String::from("hello");
```

```rust
// BAD: clippy::useless_vec
let _ = vec![1, 2, 3].iter();

// GOOD
let _ = [1, 2, 3].iter();
```

### Performance

```rust
// BAD: clippy::unnecessary_to_owned
fn process(s: &str) {
    for c in s.to_string().chars() {}
}

// GOOD
fn process(s: &str) {
    for c in s.chars() {}
}
```

```rust
// BAD: clippy::inefficient_to_string
let s = format!("{}", 42);

// GOOD
let s = 42.to_string();
```

### Correctness

```rust
// BAD: clippy::eq_op
if x == x {}

// BAD: clippy::erasing_op
let _ = x * 0;

// BAD: clippy::never_loop
loop {
    break;
}
```

### Style

```rust
// BAD: clippy::needless_return
fn foo() -> i32 {
    return 42;
}

// GOOD
fn foo() -> i32 {
    42
}
```

```rust
// BAD: clippy::len_zero
if vec.len() == 0 {}

// GOOD
if vec.is_empty() {}
```

### Match Improvements

```rust
// BAD: clippy::match_bool
match condition {
    true => foo(),
    false => bar(),
}

// GOOD
if condition { foo() } else { bar() }
```

```rust
// BAD: clippy::single_match
match option {
    Some(x) => println!("{}", x),
    _ => {},
}

// GOOD
if let Some(x) = option {
    println!("{}", x);
}
```

### Option/Result

```rust
// BAD: clippy::map_unwrap_or
option.map(|x| x + 1).unwrap_or(0);

// GOOD
option.map_or(0, |x| x + 1);
```

```rust
// BAD: clippy::option_map_or_none
option.map_or(None, |x| Some(x + 1));

// GOOD
option.map(|x| x + 1);
```

## Recommended Project Config

```rust
// lib.rs or main.rs
#![warn(clippy::all)]
#![warn(clippy::pedantic)]

// Common pedantic allows
#![allow(clippy::module_name_repetitions)]
#![allow(clippy::must_use_candidate)]
#![allow(clippy::missing_panics_doc)]
#![allow(clippy::missing_errors_doc)]

// For stricter projects
#![warn(clippy::unwrap_used)]
#![warn(clippy::expect_used)]
#![warn(clippy::panic)]
```

## CI Integration

```yaml
# GitHub Actions
- name: Clippy
  run: cargo clippy --all-targets --all-features -- -D warnings
```

```bash
# Pre-commit hook
#!/bin/bash
cargo clippy --all-targets -- -D warnings
```

## Suppressing False Positives

```rust
// For a single line
#[allow(clippy::lint_name)]
let x = something();

// With reason (Rust 1.81+)
#[allow(clippy::lint_name, reason = "false positive because...")]

// For entire function
#[allow(clippy::cognitive_complexity)]
fn complex_but_necessary() {}

// For entire module
#![allow(clippy::lint_name)]
```

## Useful Flags

```bash
# Show all lints
cargo clippy -- --help

# List all lints with docs
cargo clippy --list

# Explain specific lint
cargo clippy --explain clippy::unwrap_used
```
