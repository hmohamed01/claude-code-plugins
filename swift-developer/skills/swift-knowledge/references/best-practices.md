# Swift Development Best Practices

Essential guidelines for building robust, maintainable Swift applications.

## DO

- Use SwiftUI + Observable/ObservableObject for UI
- Use async/await for all async operations
- Store secrets in Keychain, not UserDefaults
- Use `@MainActor` for UI-related code
- Test on real devices before release
- Enable strict concurrency checking

## DON'T

- Force unwrap without safety checks
- Block main thread with sync operations
- Store API keys in source code
- Ignore Swift 6 concurrency warnings
- Skip error handling

## Code Style

### Prefer Guard for Early Returns
```swift
// Good
func process(_ data: Data?) throws -> Result {
    guard let data else {
        throw ProcessingError.noData
    }
    // Process data...
}

// Avoid
func process(_ data: Data?) throws -> Result {
    if let data {
        // Process data...
    } else {
        throw ProcessingError.noData
    }
}
```

### Use Trailing Closure Syntax
```swift
// Good
array.map { $0.name }
    .filter { !$0.isEmpty }
    .sorted()

// Avoid
array.map({ $0.name }).filter({ !$0.isEmpty }).sorted()
```

### Prefer Value Types
```swift
// Prefer struct for simple data
struct User {
    let id: UUID
    var name: String
}

// Use class when identity matters or inheritance needed
class ViewController: UIViewController {
    // ...
}
```

## Error Handling

### Define Domain-Specific Errors
```swift
enum NetworkError: LocalizedError {
    case noConnection
    case timeout
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .noConnection: "No internet connection"
        case .timeout: "Request timed out"
        case .serverError(let code): "Server error: \(code)"
        }
    }
}
```

### Handle Errors at Appropriate Level
```swift
// Low level: throw errors
func fetchData() async throws -> Data {
    // ...
}

// High level: handle and display
func loadData() async {
    do {
        data = try await fetchData()
    } catch {
        errorMessage = error.localizedDescription
    }
}
```

## Memory Management

### Avoid Retain Cycles
```swift
// Use [weak self] in closures that capture self
viewModel.onUpdate = { [weak self] result in
    self?.handleUpdate(result)
}

// Or [unowned self] when self is guaranteed to exist
Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [unowned self] _ in
    self.tick()
}
```

### Use Lazy Initialization
```swift
class ViewController: UIViewController {
    lazy var expensiveView: ExpensiveView = {
        let view = ExpensiveView()
        view.configure()
        return view
    }()
}
```

## Concurrency

### Mark UI Code with @MainActor
```swift
@MainActor
class ViewModel: ObservableObject {
    @Published var items: [Item] = []

    func refresh() async {
        items = await fetchItems()
    }
}
```

### Use Structured Concurrency
```swift
// Prefer
async let a = fetchA()
async let b = fetchB()
let results = try await (a, b)

// Over unstructured
Task { await fetchA() }
Task { await fetchB() }
```

## Testing

### Write Testable Code
```swift
// Inject dependencies
class UserService {
    private let networkClient: NetworkClient

    init(networkClient: NetworkClient = .shared) {
        self.networkClient = networkClient
    }
}

// Test with mock
class MockNetworkClient: NetworkClient {
    var mockResponse: Data?
    // ...
}
```

### Test Behavior, Not Implementation
```swift
// Good - tests behavior
func testUserCanLogin() async throws {
    let user = try await authService.login(email: "test@example.com", password: "password")
    XCTAssertNotNil(user.token)
}

// Avoid - tests implementation details
func testLoginCallsNetworkMethod() {
    // ...
}
```
