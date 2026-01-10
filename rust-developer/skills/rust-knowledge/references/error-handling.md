# Error Handling in Rust

## Core Types

### Result<T, E>

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

### Option<T>

```rust
enum Option<T> {
    Some(T),
    None,
}
```

## The ? Operator

Propagates errors automatically:

```rust
fn read_username_from_file() -> Result<String, io::Error> {
    let mut file = File::open("username.txt")?;
    let mut username = String::new();
    file.read_to_string(&mut username)?;
    Ok(username)
}

// Equivalent to:
fn read_username_verbose() -> Result<String, io::Error> {
    let file = File::open("username.txt");
    let mut file = match file {
        Ok(f) => f,
        Err(e) => return Err(e),
    };
    // ...
}
```

## Custom Error Types

### Using thiserror (Recommended)

```toml
# Cargo.toml
[dependencies]
thiserror = "1.0"
```

```rust
use thiserror::Error;

#[derive(Debug, Error)]
pub enum AppError {
    #[error("Configuration error: {0}")]
    Config(String),

    #[error("IO error: {0}")]
    Io(#[from] std::io::Error),

    #[error("Parse error at line {line}: {message}")]
    Parse { line: usize, message: String },

    #[error("Not found: {0}")]
    NotFound(String),
}
```

### Using anyhow for Applications

```toml
# Cargo.toml
[dependencies]
anyhow = "1.0"
```

```rust
use anyhow::{Context, Result, bail, ensure};

fn process_file(path: &str) -> Result<Data> {
    let content = fs::read_to_string(path)
        .context("Failed to read configuration file")?;

    ensure!(!content.is_empty(), "Configuration file is empty");

    if content.contains("invalid") {
        bail!("Configuration contains invalid data");
    }

    Ok(parse_data(&content)?)
}

fn main() -> Result<()> {
    let data = process_file("config.toml")?;
    Ok(())
}
```

## Error Handling Patterns

### Pattern: Convert Option to Result

```rust
fn find_user(id: u64) -> Option<User> { /* ... */ }

// Convert None to Err
let user = find_user(42).ok_or(AppError::NotFound("user 42".into()))?;

// With lazy error creation
let user = find_user(42).ok_or_else(|| AppError::NotFound(format!("user {}", id)))?;
```

### Pattern: Map Errors

```rust
fn parse_config(s: &str) -> Result<Config, ParseError> { /* ... */ }

// Convert error types
let config = parse_config(input)
    .map_err(|e| AppError::Config(e.to_string()))?;
```

### Pattern: Collect Results

```rust
// Stop at first error
let numbers: Result<Vec<i32>, _> = strings
    .iter()
    .map(|s| s.parse::<i32>())
    .collect();

// Collect successes and failures separately
let (successes, failures): (Vec<_>, Vec<_>) = strings
    .iter()
    .map(|s| s.parse::<i32>())
    .partition(Result::is_ok);
```

### Pattern: Recover from Errors

```rust
// Provide default on error
let config = load_config().unwrap_or_default();

// Try alternative
let data = fetch_from_primary()
    .or_else(|_| fetch_from_backup())?;

// Log and continue
if let Err(e) = optional_operation() {
    log::warn!("Optional operation failed: {}", e);
}
```

## Unwrap and Expect

### When to Use

- **Tests**: OK to panic on unexpected failures
- **Prototyping**: Quick iteration, replace later
- **Provably safe**: When logic guarantees success

```rust
// In tests - OK
#[test]
fn test_parse() {
    let num: i32 = "42".parse().unwrap();
    assert_eq!(num, 42);
}

// With expect - provides context
let home = env::var("HOME")
    .expect("HOME environment variable must be set");

// Provably safe
let first = vec![1, 2, 3].first().unwrap(); // Vec is non-empty
```

### Avoid in Production

```rust
// BAD: No context, unhelpful panic
let config = load_config().unwrap();

// BETTER: Return Result
fn init() -> Result<(), AppError> {
    let config = load_config()?;
    Ok(())
}

// BETTER: Handle gracefully
match load_config() {
    Ok(config) => run_with_config(config),
    Err(e) => {
        eprintln!("Failed to load config: {}", e);
        std::process::exit(1);
    }
}
```

## Error Context

### Adding Context with anyhow

```rust
use anyhow::Context;

fn process() -> Result<()> {
    let file = File::open(path)
        .with_context(|| format!("Failed to open {}", path))?;

    let data: Config = serde_json::from_reader(file)
        .context("Failed to parse configuration")?;

    Ok(())
}
```

### Custom Context with thiserror

```rust
#[derive(Debug, Error)]
pub enum ConfigError {
    #[error("Failed to read config from {path}")]
    Read {
        path: PathBuf,
        #[source]
        source: io::Error,
    },
}
```

## Panic vs Result

### Use Panic For

- Unrecoverable bugs (logic errors)
- Violated invariants
- Test assertions

```rust
fn get_item(index: usize) -> &Item {
    // Panic if index is out of bounds - this is a bug
    &self.items[index]
}
```

### Use Result For

- Expected failures (file not found, network error)
- User input validation
- Recoverable conditions

```rust
fn find_item(id: ItemId) -> Result<&Item, Error> {
    self.items.get(&id).ok_or(Error::NotFound(id))
}
```

## Best Practices

1. **Use `?` liberally** - It makes error propagation clean
2. **Add context** - Use `.context()` or custom error messages
3. **Be specific** - Create error types that capture failure details
4. **Use thiserror for libraries** - Type-safe, specific errors
5. **Use anyhow for applications** - Convenient, flexible
6. **Never ignore errors** - At minimum, log them
7. **Document error conditions** - In function documentation
