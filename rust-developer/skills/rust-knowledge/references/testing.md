# Testing in Rust

## Test Structure

### Unit Tests

```rust
// In src/lib.rs or any module
#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_addition() {
        assert_eq!(add(2, 2), 4);
    }

    #[test]
    fn test_with_result() -> Result<(), String> {
        if add(2, 2) == 4 {
            Ok(())
        } else {
            Err("Math is broken".into())
        }
    }

    #[test]
    #[should_panic(expected = "divide by zero")]
    fn test_panic() {
        divide(1, 0);
    }

    #[test]
    #[ignore]
    fn expensive_test() {
        // Run with: cargo test -- --ignored
    }
}
```

### Integration Tests

```
project/
├── src/
│   └── lib.rs
└── tests/
    ├── integration_test.rs
    └── common/
        └── mod.rs
```

```rust
// tests/integration_test.rs
use my_crate::public_function;

#[test]
fn test_public_api() {
    assert!(public_function().is_ok());
}
```

### Doc Tests

```rust
/// Adds two numbers together.
///
/// # Examples
///
/// ```
/// use my_crate::add;
/// assert_eq!(add(2, 2), 4);
/// ```
///
/// # Panics
///
/// Panics if the result overflows.
pub fn add(a: i32, b: i32) -> i32 {
    a + b
}
```

## Assertions

```rust
// Basic assertions
assert!(condition);
assert!(condition, "Custom message");
assert!(condition, "Value was {}", value);

// Equality
assert_eq!(left, right);
assert_ne!(left, right);

// Floating point (with epsilon)
assert!((a - b).abs() < f64::EPSILON);

// Approximate equality (use approx crate)
use approx::assert_relative_eq;
assert_relative_eq!(a, b, epsilon = 1e-10);

// Debug assertions (only in debug builds)
debug_assert!(condition);
debug_assert_eq!(left, right);
```

## Test Organization

### Test Helpers

```rust
#[cfg(test)]
mod tests {
    use super::*;

    fn setup() -> TestContext {
        TestContext::new()
    }

    #[test]
    fn test_with_setup() {
        let ctx = setup();
        // use ctx...
    }
}
```

### Shared Test Utilities

```rust
// tests/common/mod.rs
pub fn create_test_db() -> Database {
    Database::in_memory()
}

// tests/integration_test.rs
mod common;

#[test]
fn test_with_db() {
    let db = common::create_test_db();
}
```

## Async Tests

### Tokio

```rust
#[tokio::test]
async fn test_async_operation() {
    let result = fetch_data().await;
    assert!(result.is_ok());
}

#[tokio::test(flavor = "multi_thread")]
async fn test_multi_threaded() {
    // Uses multi-threaded runtime
}
```

### async-std

```rust
#[async_std::test]
async fn test_async() {
    let result = async_operation().await;
    assert!(result.is_ok());
}
```

## Mocking and Test Doubles

### mockall Crate

```toml
[dev-dependencies]
mockall = "0.11"
```

```rust
use mockall::{automock, predicate::*};

#[automock]
trait Database {
    fn get(&self, key: &str) -> Option<String>;
    fn set(&mut self, key: &str, value: &str);
}

#[test]
fn test_with_mock() {
    let mut mock = MockDatabase::new();
    mock.expect_get()
        .with(eq("key"))
        .returning(|_| Some("value".into()));

    assert_eq!(mock.get("key"), Some("value".into()));
}
```

### Manual Test Doubles

```rust
// Production trait
trait EmailSender {
    fn send(&self, to: &str, body: &str) -> Result<(), Error>;
}

// Test double
struct FakeEmailSender {
    sent: RefCell<Vec<(String, String)>>,
}

impl EmailSender for FakeEmailSender {
    fn send(&self, to: &str, body: &str) -> Result<(), Error> {
        self.sent.borrow_mut().push((to.into(), body.into()));
        Ok(())
    }
}
```

## Property-Based Testing

### proptest

```toml
[dev-dependencies]
proptest = "1.0"
```

```rust
use proptest::prelude::*;

proptest! {
    #[test]
    fn test_reverse_reverse(s in ".*") {
        let reversed: String = s.chars().rev().collect();
        let double_reversed: String = reversed.chars().rev().collect();
        assert_eq!(s, double_reversed);
    }

    #[test]
    fn test_sort_is_sorted(mut v in prop::collection::vec(any::<i32>(), 0..100)) {
        v.sort();
        for window in v.windows(2) {
            assert!(window[0] <= window[1]);
        }
    }
}
```

## Test Commands

```bash
# Run all tests
cargo test

# Run specific test
cargo test test_name

# Run tests in specific module
cargo test module_name::

# Run with output
cargo test -- --nocapture

# Run ignored tests
cargo test -- --ignored

# Run all tests including ignored
cargo test -- --include-ignored

# Run tests in release mode
cargo test --release

# Run doc tests only
cargo test --doc

# Run with specific number of threads
cargo test -- --test-threads=1

# Show test timing
cargo test -- --report-time
```

## Test Coverage

### cargo-tarpaulin

```bash
cargo install cargo-tarpaulin
cargo tarpaulin --out Html
```

### llvm-cov

```bash
cargo install cargo-llvm-cov
cargo llvm-cov --html
```

## Best Practices

1. **Test behavior, not implementation** - Focus on public API
2. **Use descriptive test names** - `test_user_can_login_with_valid_credentials`
3. **One assertion per test** - When practical
4. **Keep tests fast** - Mock slow dependencies
5. **Test edge cases** - Empty inputs, boundaries, errors
6. **Use test fixtures** - For complex setup
7. **Run tests in CI** - On every commit

```rust
// Good test name
#[test]
fn parse_returns_error_for_invalid_json() { }

// Bad test name
#[test]
fn test1() { }
```
