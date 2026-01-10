# Rust Web Frameworks

## Axum (Recommended)

### Setup

```toml
[dependencies]
axum = "0.7"
tokio = { version = "1", features = ["full"] }
tower = "0.4"
tower-http = { version = "0.5", features = ["cors", "trace"] }
serde = { version = "1", features = ["derive"] }
serde_json = "1"
tracing = "0.1"
tracing-subscriber = "0.3"
```

### Basic Server

```rust
use axum::{
    routing::{get, post},
    Router, Json,
    extract::{Path, Query, State},
    http::StatusCode,
};
use serde::{Deserialize, Serialize};
use std::sync::Arc;
use tokio::sync::RwLock;

#[derive(Clone)]
struct AppState {
    db: Arc<RwLock<Vec<User>>>,
}

#[derive(Serialize, Deserialize)]
struct User {
    id: u64,
    name: String,
}

#[tokio::main]
async fn main() {
    tracing_subscriber::init();

    let state = AppState {
        db: Arc::new(RwLock::new(vec![])),
    };

    let app = Router::new()
        .route("/", get(root))
        .route("/users", get(list_users).post(create_user))
        .route("/users/:id", get(get_user))
        .with_state(state);

    let listener = tokio::net::TcpListener::bind("0.0.0.0:3000").await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn root() -> &'static str {
    "Hello, World!"
}

async fn list_users(State(state): State<AppState>) -> Json<Vec<User>> {
    let users = state.db.read().await;
    Json(users.clone())
}

async fn create_user(
    State(state): State<AppState>,
    Json(user): Json<User>,
) -> (StatusCode, Json<User>) {
    state.db.write().await.push(user.clone());
    (StatusCode::CREATED, Json(user))
}

async fn get_user(Path(id): Path<u64>, State(state): State<AppState>) -> Result<Json<User>, StatusCode> {
    let users = state.db.read().await;
    users.iter()
        .find(|u| u.id == id)
        .cloned()
        .map(Json)
        .ok_or(StatusCode::NOT_FOUND)
}
```

### Middleware

```rust
use tower_http::{cors::CorsLayer, trace::TraceLayer};
use axum::middleware;

let app = Router::new()
    .route("/", get(root))
    .layer(TraceLayer::new_for_http())
    .layer(CorsLayer::permissive())
    .layer(middleware::from_fn(auth_middleware));

async fn auth_middleware(
    request: axum::extract::Request,
    next: middleware::Next,
) -> axum::response::Response {
    // Check auth header
    if let Some(auth) = request.headers().get("Authorization") {
        // Validate token...
    }
    next.run(request).await
}
```

### Error Handling

```rust
use axum::{
    http::StatusCode,
    response::{IntoResponse, Response},
    Json,
};

#[derive(Debug)]
enum AppError {
    NotFound,
    BadRequest(String),
    Internal(anyhow::Error),
}

impl IntoResponse for AppError {
    fn into_response(self) -> Response {
        let (status, message) = match self {
            AppError::NotFound => (StatusCode::NOT_FOUND, "Not found".to_string()),
            AppError::BadRequest(msg) => (StatusCode::BAD_REQUEST, msg),
            AppError::Internal(e) => (StatusCode::INTERNAL_SERVER_ERROR, e.to_string()),
        };
        (status, Json(serde_json::json!({ "error": message }))).into_response()
    }
}
```

## Actix Web

### Setup

```toml
[dependencies]
actix-web = "4"
actix-rt = "2"
serde = { version = "1", features = ["derive"] }
```

### Basic Server

```rust
use actix_web::{web, App, HttpServer, HttpResponse, Responder};
use serde::{Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct User {
    name: String,
}

async fn hello() -> impl Responder {
    HttpResponse::Ok().body("Hello world!")
}

async fn create_user(user: web::Json<User>) -> impl Responder {
    HttpResponse::Created().json(user.into_inner())
}

async fn get_user(path: web::Path<u64>) -> impl Responder {
    let id = path.into_inner();
    HttpResponse::Ok().json(User { name: format!("User {}", id) })
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    HttpServer::new(|| {
        App::new()
            .route("/", web::get().to(hello))
            .route("/users", web::post().to(create_user))
            .route("/users/{id}", web::get().to(get_user))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}
```

### State and Middleware

```rust
use actix_web::{web, App, HttpServer, middleware};

struct AppState {
    app_name: String,
}

#[actix_web::main]
async fn main() -> std::io::Result<()> {
    let data = web::Data::new(AppState {
        app_name: String::from("MyApp"),
    });

    HttpServer::new(move || {
        App::new()
            .app_data(data.clone())
            .wrap(middleware::Logger::default())
            .route("/", web::get().to(index))
    })
    .bind("127.0.0.1:8080")?
    .run()
    .await
}

async fn index(data: web::Data<AppState>) -> String {
    format!("Hello from {}", data.app_name)
}
```

## Rocket

### Setup

```toml
[dependencies]
rocket = { version = "0.5", features = ["json"] }
serde = { version = "1", features = ["derive"] }
```

### Basic Server

```rust
#[macro_use] extern crate rocket;

use rocket::serde::{json::Json, Deserialize, Serialize};

#[derive(Serialize, Deserialize)]
struct User {
    name: String,
}

#[get("/")]
fn index() -> &'static str {
    "Hello, world!"
}

#[post("/users", format = "json", data = "<user>")]
fn create_user(user: Json<User>) -> Json<User> {
    user
}

#[get("/users/<id>")]
fn get_user(id: u64) -> Json<User> {
    Json(User { name: format!("User {}", id) })
}

#[launch]
fn rocket() -> _ {
    rocket::build()
        .mount("/", routes![index, create_user, get_user])
}
```

## Framework Comparison

| Feature | Axum | Actix Web | Rocket |
|---------|------|-----------|--------|
| Performance | Excellent | Excellent | Very Good |
| Type Safety | Very High | High | Very High |
| Async Runtime | Tokio | Actix | Tokio |
| Macros | Minimal | Minimal | Heavy |
| Learning Curve | Moderate | Moderate | Easy |
| Ecosystem | Growing | Mature | Mature |
| Tower Compatible | Yes | No | No |

## Recommendations

- **Axum**: Best for new projects. Modern, composable, Tokio-native.
- **Actix Web**: Most performant. Good for high-throughput services.
- **Rocket**: Best ergonomics. Good for rapid prototyping.

## Common Patterns

### Database Integration (SQLx)

```rust
use sqlx::PgPool;

async fn setup_db() -> PgPool {
    PgPool::connect(&std::env::var("DATABASE_URL").unwrap())
        .await
        .unwrap()
}

// Axum with SQLx
let pool = setup_db().await;
let app = Router::new()
    .route("/users", get(list_users))
    .with_state(pool);

async fn list_users(State(pool): State<PgPool>) -> Result<Json<Vec<User>>, AppError> {
    let users = sqlx::query_as!(User, "SELECT * FROM users")
        .fetch_all(&pool)
        .await?;
    Ok(Json(users))
}
```

### Authentication (JWT)

```rust
use jsonwebtoken::{encode, decode, Header, Validation, EncodingKey, DecodingKey};

#[derive(Serialize, Deserialize)]
struct Claims {
    sub: String,
    exp: usize,
}

fn create_token(user_id: &str, secret: &str) -> String {
    let claims = Claims {
        sub: user_id.to_owned(),
        exp: (chrono::Utc::now() + chrono::Duration::hours(24)).timestamp() as usize,
    };
    encode(&Header::default(), &claims, &EncodingKey::from_secret(secret.as_ref())).unwrap()
}
```

### Structured Logging

```rust
use tracing::{info, instrument};
use tracing_subscriber::{layer::SubscriberExt, util::SubscriberInitExt};

fn init_tracing() {
    tracing_subscriber::registry()
        .with(tracing_subscriber::fmt::layer())
        .init();
}

#[instrument(skip(db))]
async fn get_user(id: u64, db: &Pool) -> Result<User, Error> {
    info!(user_id = id, "Fetching user");
    // ...
}
```
