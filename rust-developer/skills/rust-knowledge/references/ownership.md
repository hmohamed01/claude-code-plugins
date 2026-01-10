# Ownership, Borrowing, and Lifetimes

## Ownership Rules

1. Each value has exactly one owner
2. When the owner goes out of scope, the value is dropped
3. Ownership can be transferred (moved) or borrowed

## Move Semantics

```rust
let s1 = String::from("hello");
let s2 = s1;  // s1 is moved to s2, s1 is no longer valid

// This won't compile:
// println!("{}", s1);  // error: value borrowed after move
```

### Types that Copy vs Move

**Copy types** (stack-only, implement `Copy` trait):
- Integers, floats, booleans, chars
- Tuples of Copy types
- Arrays of Copy types

**Move types** (heap data):
- `String`, `Vec<T>`, `Box<T>`
- Any type with heap allocation

## Borrowing

### Immutable References (`&T`)

```rust
fn calculate_length(s: &String) -> usize {
    s.len()
}

let s = String::from("hello");
let len = calculate_length(&s);  // s is borrowed, not moved
println!("{} has length {}", s, len);  // s is still valid
```

### Mutable References (`&mut T`)

```rust
fn append_world(s: &mut String) {
    s.push_str(", world");
}

let mut s = String::from("hello");
append_world(&mut s);
```

### Borrowing Rules

1. You can have either:
   - One mutable reference, OR
   - Any number of immutable references
2. References must always be valid (no dangling references)

```rust
let mut s = String::from("hello");

let r1 = &s;      // OK: first immutable borrow
let r2 = &s;      // OK: second immutable borrow
// let r3 = &mut s;  // ERROR: can't borrow mutably while immutably borrowed

println!("{} and {}", r1, r2);
// r1 and r2 are no longer used after this point

let r3 = &mut s;  // OK: previous borrows are done (NLL)
```

## Lifetimes

Lifetimes ensure references are valid for as long as they're used.

### Explicit Lifetime Annotations

```rust
// Function returning a reference needs lifetime annotation
fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() { x } else { y }
}
```

### Lifetime Elision Rules

The compiler infers lifetimes in common cases:

1. Each reference parameter gets its own lifetime
2. If there's exactly one input lifetime, it's assigned to all outputs
3. If `&self` or `&mut self`, that lifetime is assigned to outputs

```rust
// No annotation needed - elision applies
fn first_word(s: &str) -> &str {
    s.split_whitespace().next().unwrap_or("")
}

// Compiler expands to:
// fn first_word<'a>(s: &'a str) -> &'a str
```

### Struct Lifetimes

```rust
struct Excerpt<'a> {
    part: &'a str,
}

impl<'a> Excerpt<'a> {
    fn level(&self) -> i32 {
        3
    }

    fn announce_and_return(&self, announcement: &str) -> &str {
        println!("Attention: {}", announcement);
        self.part
    }
}
```

### Static Lifetime

```rust
// Lives for entire program duration
let s: &'static str = "I have a static lifetime.";

// String literals are always 'static
```

## Common Patterns

### Returning Owned Data

When you can't return a reference, return owned data:

```rust
fn create_greeting(name: &str) -> String {
    format!("Hello, {}!", name)
}
```

### Using `Cow` for Flexibility

```rust
use std::borrow::Cow;

fn process(input: &str) -> Cow<str> {
    if input.contains("bad") {
        Cow::Owned(input.replace("bad", "good"))
    } else {
        Cow::Borrowed(input)
    }
}
```

### Interior Mutability

When you need mutation through shared references:

```rust
use std::cell::RefCell;

let data = RefCell::new(5);
*data.borrow_mut() += 1;

// For thread-safe version, use Mutex or RwLock
use std::sync::Mutex;
let data = Mutex::new(5);
*data.lock().unwrap() += 1;
```

## Troubleshooting

### "Does not live long enough"

The reference outlives the data it points to:

```rust
// ERROR
fn dangle() -> &String {
    let s = String::from("hello");
    &s  // s is dropped here, reference would be invalid
}

// FIX: Return owned data
fn no_dangle() -> String {
    String::from("hello")
}
```

### "Cannot borrow as mutable because it is also borrowed as immutable"

Multiple conflicting borrows:

```rust
let mut v = vec![1, 2, 3];
let first = &v[0];
v.push(4);  // ERROR: v is borrowed immutably
println!("{}", first);

// FIX: Use first before mutating
let mut v = vec![1, 2, 3];
let first = v[0];  // Copy the value instead
v.push(4);
println!("{}", first);
```

### "Missing lifetime specifier"

The compiler needs help determining lifetimes:

```rust
// ERROR
fn get_str(x: &str, y: &str) -> &str {
    x
}

// FIX: Add lifetime annotations
fn get_str<'a>(x: &'a str, _y: &str) -> &'a str {
    x
}
```
