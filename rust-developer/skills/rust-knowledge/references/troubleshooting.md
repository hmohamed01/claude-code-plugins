# Rust Troubleshooting Guide

## Borrow Checker Errors

### "Cannot borrow `x` as mutable because it is also borrowed as immutable"

**Problem**: Simultaneous mutable and immutable borrows.

```rust
// ERROR
let mut v = vec![1, 2, 3];
let first = &v[0];
v.push(4);  // Can't mutate while borrowed
println!("{}", first);
```

**Solutions**:

```rust
// Solution 1: Scope the borrow
let mut v = vec![1, 2, 3];
{
    let first = &v[0];
    println!("{}", first);
}  // first's borrow ends
v.push(4);

// Solution 2: Copy the value
let mut v = vec![1, 2, 3];
let first = v[0];  // Copy, not borrow
v.push(4);

// Solution 3: Use indices
let mut v = vec![1, 2, 3];
let first_idx = 0;
v.push(4);
println!("{}", v[first_idx]);
```

### "Cannot move out of borrowed content"

**Problem**: Trying to take ownership from a reference.

```rust
// ERROR
fn process(items: &Vec<String>) {
    for item in items {  // item is &String
        take_ownership(item);  // ERROR: needs String
    }
}
```

**Solutions**:

```rust
// Solution 1: Clone
fn process(items: &Vec<String>) {
    for item in items {
        take_ownership(item.clone());
    }
}

// Solution 2: Take reference in function
fn take_reference(s: &str) { }

// Solution 3: Use into_iter on owned value
fn process(items: Vec<String>) {
    for item in items.into_iter() {
        take_ownership(item);
    }
}
```

### "Value does not live long enough"

**Problem**: Reference outlives the data.

```rust
// ERROR
fn get_string() -> &String {
    let s = String::from("hello");
    &s  // s is dropped, reference is dangling
}
```

**Solutions**:

```rust
// Solution 1: Return owned value
fn get_string() -> String {
    String::from("hello")
}

// Solution 2: Accept lifetime from caller
fn get_first<'a>(items: &'a [String]) -> &'a str {
    &items[0]
}

// Solution 3: Use 'static data
fn get_static() -> &'static str {
    "hello"  // String literals are 'static
}
```

## Lifetime Errors

### "Missing lifetime specifier"

**Problem**: Compiler can't infer lifetimes.

```rust
// ERROR
fn longest(x: &str, y: &str) -> &str {
    if x.len() > y.len() { x } else { y }
}
```

**Solution**: Add explicit lifetime annotations.

```rust
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

### "Lifetime may not live long enough"

**Problem**: Lifetime mismatch in returned references.

```rust
// ERROR
fn first_or_second<'a, 'b>(x: &'a str, y: &'b str) -> &'a str {
    if x.len() > 0 { x } else { y }  // 'b might not live as long as 'a
}
```

**Solution**: Unify lifetimes.

```rust
fn first_or_second<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > 0 { x } else { y }
}
```

## Trait Errors

### "The trait `X` is not implemented for `Y`"

**Problem**: Type doesn't implement required trait.

```rust
// ERROR
fn print_debug<T: Debug>(t: T) { }
struct MyStruct { }
print_debug(MyStruct { });  // MyStruct doesn't impl Debug
```

**Solutions**:

```rust
// Solution 1: Derive trait
#[derive(Debug)]
struct MyStruct { }

// Solution 2: Implement manually
impl std::fmt::Debug for MyStruct {
    fn fmt(&self, f: &mut std::fmt::Formatter<'_>) -> std::fmt::Result {
        write!(f, "MyStruct")
    }
}
```

### "Cannot infer type"

**Problem**: Not enough type information.

```rust
// ERROR
let v = Vec::new();  // What type?
```

**Solutions**:

```rust
// Solution 1: Annotate type
let v: Vec<i32> = Vec::new();

// Solution 2: Turbofish
let v = Vec::<i32>::new();

// Solution 3: Use the value with type context
let mut v = Vec::new();
v.push(1_i32);
```

## Async Errors

### "Future cannot be sent between threads safely"

**Problem**: Holding non-Send type across await.

```rust
// ERROR
async fn bad() {
    let rc = Rc::new(1);  // Rc is not Send
    tokio::time::sleep(Duration::from_secs(1)).await;
    println!("{}", rc);
}
```

**Solutions**:

```rust
// Solution 1: Use Arc instead of Rc
use std::sync::Arc;
async fn good() {
    let arc = Arc::new(1);
    tokio::time::sleep(Duration::from_secs(1)).await;
    println!("{}", arc);
}

// Solution 2: Don't hold across await
async fn also_good() {
    {
        let rc = Rc::new(1);
        println!("{}", rc);
    }  // rc dropped before await
    tokio::time::sleep(Duration::from_secs(1)).await;
}
```

### "`async fn` in trait"

**Problem**: Async functions in traits require special handling.

```rust
// ERROR (before Rust 1.75)
trait MyTrait {
    async fn do_thing(&self);
}
```

**Solutions**:

```rust
// Solution 1: Use async-trait crate (compatible with older Rust)
use async_trait::async_trait;

#[async_trait]
trait MyTrait {
    async fn do_thing(&self);
}

// Solution 2: Native async traits (Rust 1.75+)
trait MyTrait {
    async fn do_thing(&self);
}
```

## Cargo/Build Errors

### "No matching package"

```bash
# Check registry is up to date
cargo update

# Clear cache
cargo clean

# Check crate name spelling in Cargo.toml
```

### "Incompatible versions"

```bash
# Check dependency tree
cargo tree -d

# Force specific version
cargo update -p problematic-crate --precise 1.2.3
```

### "Failed to compile" with features

```bash
# Check available features
cargo add --help

# Build with specific features
cargo build --features "feature1"
cargo build --no-default-features
cargo build --all-features
```

## Performance Issues

### Slow compilation

```bash
# Incremental builds (default in dev)
cargo build

# Parallel compilation
RUSTFLAGS="-C codegen-units=1" cargo build  # Slower but smaller
cargo build -j4  # Limit parallel jobs

# Use mold linker (faster linking)
RUSTFLAGS="-C link-arg=-fuse-ld=mold" cargo build
```

### Large binary size

```toml
# Cargo.toml
[profile.release]
opt-level = "s"       # Optimize for size
lto = true            # Link-time optimization
codegen-units = 1     # Better optimization
panic = "abort"       # Smaller panic handling
strip = true          # Strip symbols
```

```bash
# Check what's taking space
cargo install cargo-bloat
cargo bloat --release
```

## Common Clippy Warnings

### `clippy::needless_return`

```rust
// BAD
fn foo() -> i32 {
    return 42;
}

// GOOD
fn foo() -> i32 {
    42
}
```

### `clippy::clone_on_copy`

```rust
// BAD
let x = 5;
let y = x.clone();

// GOOD
let x = 5;
let y = x;  // i32 implements Copy
```

### `clippy::unwrap_used`

```rust
// BAD (in production)
let value = option.unwrap();

// GOOD
let value = option.expect("reason this should never be None");
// or
let value = option.ok_or(Error::Missing)?;
```

## Debugging Tips

### Print debugging

```rust
// Debug print
dbg!(&value);  // Prints file:line and value

// Format debug
println!("{:?}", value);   // Debug format
println!("{:#?}", value);  // Pretty debug format
```

### Using RUST_BACKTRACE

```bash
RUST_BACKTRACE=1 cargo run
RUST_BACKTRACE=full cargo run
```

### Compiler explain

```bash
rustc --explain E0382  # Explain error code
```
