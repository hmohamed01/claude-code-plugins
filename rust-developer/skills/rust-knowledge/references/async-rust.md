# Async Rust

## Runtime Setup

### Tokio (Most Common)

```toml
# Cargo.toml
[dependencies]
tokio = { version = "1", features = ["full"] }
```

```rust
#[tokio::main]
async fn main() {
    println!("Hello from async!");
}

// Or with options
#[tokio::main(flavor = "multi_thread", worker_threads = 4)]
async fn main() { }

// Single-threaded
#[tokio::main(flavor = "current_thread")]
async fn main() { }
```

### async-std

```toml
[dependencies]
async-std = { version = "1", features = ["attributes"] }
```

```rust
#[async_std::main]
async fn main() {
    println!("Hello from async-std!");
}
```

## Core Concepts

### async/await

```rust
async fn fetch_data(url: &str) -> Result<String, Error> {
    let response = reqwest::get(url).await?;
    let body = response.text().await?;
    Ok(body)
}

// Calling async functions
async fn main() {
    let result = fetch_data("https://api.example.com").await;
}
```

### Futures

```rust
use std::future::Future;

// async fn returns impl Future
async fn compute() -> i32 {
    42
}

// Equivalent to:
fn compute() -> impl Future<Output = i32> {
    async { 42 }
}
```

## Concurrency Patterns

### Join - Run Concurrently

```rust
use tokio::join;

async fn fetch_all() -> (Data1, Data2, Data3) {
    let (a, b, c) = join!(
        fetch_data_1(),
        fetch_data_2(),
        fetch_data_3()
    );
    (a, b, c)
}

// With error handling
use tokio::try_join;

async fn fetch_all() -> Result<(Data1, Data2), Error> {
    let (a, b) = try_join!(fetch_1(), fetch_2())?;
    Ok((a, b))
}
```

### Select - Race Futures

```rust
use tokio::select;

async fn race_requests() -> Result<Response, Error> {
    select! {
        result = fetch_from_primary() => result,
        result = fetch_from_backup() => result,
    }
}

// With timeout
use tokio::time::{timeout, Duration};

async fn with_timeout() -> Result<Data, Error> {
    timeout(Duration::from_secs(5), fetch_data())
        .await
        .map_err(|_| Error::Timeout)?
}
```

### Spawning Tasks

```rust
// Spawn a task (runs independently)
let handle = tokio::spawn(async {
    expensive_computation().await
});

// Wait for result
let result = handle.await?;

// Spawn and forget
tokio::spawn(async {
    background_task().await;
});
```

### Task Groups with JoinSet

```rust
use tokio::task::JoinSet;

async fn process_all(items: Vec<Item>) -> Vec<Result<Output, Error>> {
    let mut set = JoinSet::new();

    for item in items {
        set.spawn(async move {
            process_item(item).await
        });
    }

    let mut results = Vec::new();
    while let Some(result) = set.join_next().await {
        results.push(result?);
    }
    results
}
```

## Channels

### mpsc - Multi-Producer, Single-Consumer

```rust
use tokio::sync::mpsc;

async fn producer_consumer() {
    let (tx, mut rx) = mpsc::channel(100);

    // Spawn producer
    tokio::spawn(async move {
        for i in 0..10 {
            tx.send(i).await.unwrap();
        }
    });

    // Consume
    while let Some(value) = rx.recv().await {
        println!("Received: {}", value);
    }
}
```

### oneshot - Single Value

```rust
use tokio::sync::oneshot;

async fn request_response() {
    let (tx, rx) = oneshot::channel();

    tokio::spawn(async move {
        let result = compute().await;
        tx.send(result).unwrap();
    });

    let response = rx.await.unwrap();
}
```

### broadcast - Multi-Consumer

```rust
use tokio::sync::broadcast;

let (tx, _) = broadcast::channel(16);
let mut rx1 = tx.subscribe();
let mut rx2 = tx.subscribe();

tx.send("hello").unwrap();
// Both rx1 and rx2 receive "hello"
```

### watch - Latest Value

```rust
use tokio::sync::watch;

let (tx, mut rx) = watch::channel("initial");

// Sender updates value
tx.send("updated").unwrap();

// Receiver gets latest
let value = rx.borrow().clone();

// Wait for changes
rx.changed().await.unwrap();
```

## Synchronization

### Mutex

```rust
use tokio::sync::Mutex;
use std::sync::Arc;

let data = Arc::new(Mutex::new(vec![]));

let data_clone = Arc::clone(&data);
tokio::spawn(async move {
    let mut lock = data_clone.lock().await;
    lock.push(1);
});
```

### RwLock

```rust
use tokio::sync::RwLock;

let data = Arc::new(RwLock::new(HashMap::new()));

// Multiple readers OK
let read = data.read().await;

// Exclusive write
let mut write = data.write().await;
write.insert("key", "value");
```

### Semaphore

```rust
use tokio::sync::Semaphore;
use std::sync::Arc;

let semaphore = Arc::new(Semaphore::new(3)); // Max 3 concurrent

async fn limited_operation(sem: Arc<Semaphore>) {
    let _permit = sem.acquire().await.unwrap();
    // Only 3 can run this section concurrently
    do_work().await;
}
```

## Streams

```rust
use tokio_stream::StreamExt;

async fn process_stream() {
    let mut stream = tokio_stream::iter(vec![1, 2, 3]);

    while let Some(value) = stream.next().await {
        println!("{}", value);
    }
}

// Creating streams
use async_stream::stream;

fn countdown(from: u32) -> impl Stream<Item = u32> {
    stream! {
        for i in (0..=from).rev() {
            yield i;
            tokio::time::sleep(Duration::from_secs(1)).await;
        }
    }
}
```

## Common Async Crates

| Crate | Purpose |
|-------|---------|
| `tokio` | Async runtime |
| `async-std` | Alternative runtime |
| `reqwest` | HTTP client |
| `hyper` | Low-level HTTP |
| `sqlx` | Async SQL |
| `tokio-postgres` | PostgreSQL client |
| `redis` | Redis client |
| `tonic` | gRPC |
| `tower` | Service abstractions |

## Best Practices

1. **Don't block the runtime** - Use `spawn_blocking` for CPU-heavy work
2. **Use channels** - For communication between tasks
3. **Prefer Arc<Mutex>** - Over shared mutable state
4. **Handle cancellation** - Use `tokio::select!` with cancellation tokens
5. **Set timeouts** - Always timeout network operations
6. **Use structured concurrency** - JoinSet over scattered spawns

```rust
// Blocking work
let result = tokio::task::spawn_blocking(|| {
    cpu_intensive_work()
}).await?;

// Graceful shutdown
use tokio::signal;

select! {
    _ = server.serve() => {},
    _ = signal::ctrl_c() => {
        println!("Shutting down...");
    }
}
```
