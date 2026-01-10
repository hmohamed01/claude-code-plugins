# WebAssembly with Rust

## Setup

### Install Target

```bash
rustup target add wasm32-unknown-unknown
```

### Install wasm-pack

```bash
cargo install wasm-pack
```

### Install wasm-bindgen-cli (optional)

```bash
cargo install wasm-bindgen-cli
```

## Project Setup

### Cargo.toml

```toml
[package]
name = "my-wasm"
version = "0.1.0"
edition = "2021"

[lib]
crate-type = ["cdylib", "rlib"]

[dependencies]
wasm-bindgen = "0.2"
js-sys = "0.3"
web-sys = { version = "0.3", features = ["console", "Window", "Document"] }

[profile.release]
opt-level = "s"
lto = true
```

## Basic WASM Library

```rust
use wasm_bindgen::prelude::*;

// Export function to JavaScript
#[wasm_bindgen]
pub fn greet(name: &str) -> String {
    format!("Hello, {}!", name)
}

// Export struct
#[wasm_bindgen]
pub struct Counter {
    count: i32,
}

#[wasm_bindgen]
impl Counter {
    #[wasm_bindgen(constructor)]
    pub fn new() -> Counter {
        Counter { count: 0 }
    }

    pub fn increment(&mut self) {
        self.count += 1;
    }

    pub fn get(&self) -> i32 {
        self.count
    }
}
```

## JavaScript Interop

### Calling JavaScript

```rust
use wasm_bindgen::prelude::*;

// Import JavaScript function
#[wasm_bindgen]
extern "C" {
    fn alert(s: &str);

    #[wasm_bindgen(js_namespace = console)]
    fn log(s: &str);

    #[wasm_bindgen(js_namespace = console, js_name = log)]
    fn log_u32(a: u32);
}

#[wasm_bindgen]
pub fn run() {
    log("Hello from Rust!");
    alert("Alert from WASM");
}
```

### web-sys: DOM Manipulation

```rust
use wasm_bindgen::prelude::*;
use web_sys::{Document, Element, Window};

#[wasm_bindgen]
pub fn manipulate_dom() -> Result<(), JsValue> {
    let window: Window = web_sys::window().unwrap();
    let document: Document = window.document().unwrap();

    let element: Element = document.create_element("div")?;
    element.set_inner_html("Created by Rust!");
    element.set_class_name("rust-element");

    document.body().unwrap().append_child(&element)?;
    Ok(())
}
```

### js-sys: JavaScript Types

```rust
use js_sys::{Array, Date, Object, Reflect};

#[wasm_bindgen]
pub fn use_js_types() {
    // Create JS array
    let arr = Array::new();
    arr.push(&JsValue::from(1));
    arr.push(&JsValue::from(2));

    // Get current date
    let date = Date::new_0();
    let year = date.get_full_year();

    // Create object
    let obj = Object::new();
    Reflect::set(&obj, &"key".into(), &"value".into()).unwrap();
}
```

## Building

### With wasm-pack

```bash
# For web bundlers (webpack, etc.)
wasm-pack build --target bundler

# For web without bundler
wasm-pack build --target web

# For Node.js
wasm-pack build --target nodejs

# Release build
wasm-pack build --release
```

### Manual Build

```bash
cargo build --target wasm32-unknown-unknown --release

wasm-bindgen target/wasm32-unknown-unknown/release/my_wasm.wasm \
  --out-dir pkg --target web
```

## Using in JavaScript

### With Bundler (Webpack/Vite)

```javascript
import init, { greet, Counter } from './pkg/my_wasm.js';

async function run() {
  await init();

  console.log(greet("World"));

  const counter = new Counter();
  counter.increment();
  console.log(counter.get());
}

run();
```

### Without Bundler

```html
<script type="module">
  import init, { greet } from './pkg/my_wasm.js';

  async function run() {
    await init();
    console.log(greet("World"));
  }

  run();
</script>
```

## Async/Await

```rust
use wasm_bindgen::prelude::*;
use wasm_bindgen_futures::JsFuture;
use web_sys::{Request, RequestInit, Response};

#[wasm_bindgen]
pub async fn fetch_data(url: &str) -> Result<JsValue, JsValue> {
    let opts = RequestInit::new();
    opts.set_method("GET");

    let request = Request::new_with_str_and_init(url, &opts)?;

    let window = web_sys::window().unwrap();
    let resp_value = JsFuture::from(window.fetch_with_request(&request)).await?;
    let resp: Response = resp_value.dyn_into()?;

    let json = JsFuture::from(resp.json()?).await?;
    Ok(json)
}
```

## Error Handling

```rust
use wasm_bindgen::prelude::*;

// Return Result to JavaScript
#[wasm_bindgen]
pub fn fallible_function(input: &str) -> Result<String, JsValue> {
    if input.is_empty() {
        return Err(JsValue::from_str("Input cannot be empty"));
    }
    Ok(format!("Processed: {}", input))
}

// Panic hook for better error messages
#[wasm_bindgen(start)]
pub fn init() {
    console_error_panic_hook::set_once();
}
```

## Optimizing Size

### Cargo.toml

```toml
[profile.release]
opt-level = "s"      # Optimize for size
lto = true           # Link-time optimization
codegen-units = 1    # Better optimization
```

### wasm-opt (Binaryen)

```bash
# Install binaryen
brew install binaryen  # macOS

# Optimize
wasm-opt -Oz -o output.wasm input.wasm
```

### Use wasm-pack with optimization

```bash
wasm-pack build --release
```

## Testing

```rust
#[cfg(test)]
mod tests {
    use super::*;
    use wasm_bindgen_test::*;

    wasm_bindgen_test_configure!(run_in_browser);

    #[wasm_bindgen_test]
    fn test_greet() {
        assert_eq!(greet("Test"), "Hello, Test!");
    }
}
```

```bash
# Run tests in headless browser
wasm-pack test --headless --firefox
wasm-pack test --headless --chrome
```

## Common Dependencies

```toml
[dependencies]
wasm-bindgen = "0.2"
wasm-bindgen-futures = "0.4"  # Async support
js-sys = "0.3"                # JS types
web-sys = "0.3"               # Web APIs
console_error_panic_hook = "0.1"  # Better panic messages
serde = { version = "1", features = ["derive"] }
serde-wasm-bindgen = "0.6"    # Serde for WASM
```

## Debugging

```rust
// Console logging
use web_sys::console;

console::log_1(&"Debug message".into());
console::log_2(&"Value:".into(), &JsValue::from(42));

// Or use the log crate
use log::info;
use console_log;

#[wasm_bindgen(start)]
pub fn init() {
    console_log::init_with_level(log::Level::Debug).unwrap();
    console_error_panic_hook::set_once();
}
```
