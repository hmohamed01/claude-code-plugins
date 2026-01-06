# swift-developer

An autonomous Swift development agent for Claude Code that assists with iOS/macOS application development, Swift packages, SwiftUI, and Swift 6 concurrency patterns.

## Features

### Apple Documentation Verification

The agent uses `WebFetch` to verify code against official Apple documentation before implementing Swift language features. Since Apple's developer.apple.com is a JavaScript SPA that cannot be fetched programmatically, the agent uses GitHub-based sources instead:

- **Swift Book**: Language guide and reference manual
- **Swift Testing**: Modern testing framework (`@Test`, `#expect`)
- **Swift Evolution**: Latest language proposals
- **Swift Async Algorithms**: Async sequence operations

### Unsafe Pattern Detection

Pre-write hooks automatically block code containing unsafe Swift patterns:

| Pattern | Issue | Fix |
|---------|-------|-----|
| Force unwraps (`!`) | Runtime crashes | Use `guard let`, `if let`, or `??` |
| Hardcoded secrets | Security vulnerability | Use Keychain or environment variables |
| `DispatchQueue.main.sync` | Main thread blocking | Use `.async` or async/await |
| `@unchecked Sendable` | Thread safety | Add proper synchronization (NSLock, actors) |
| Missing `@MainActor` | UI thread safety | Add `@MainActor` to ObservableObject classes |

### Comprehensive Knowledge

Includes reference documentation for:

- SwiftUI patterns and @Observable
- Swift 6 concurrency (async/await, actors, Sendable)
- XCTest and Swift Testing frameworks
- xcodebuild commands and CI/CD
- iOS simulator management (simctl)
- Code signing and distribution
- Swift Package Manager

### Utility Scripts

| Script | Purpose |
|--------|---------|
| `new_package.sh` | Create new Swift package with SwiftFormat/SwiftLint configs |
| `run_tests.sh` | Run tests with common options |
| `format_and_lint.sh` | Format and lint Swift code |
| `simulator.sh` | Quick simulator management |

## Installation

First, add the plugin marketplace:

```bash
claude plugin marketplace add hmohamed01/claude-code-plugins
```

Then install the plugin:

```bash
claude plugin install swift-developer@hmohamed-plugins
```

## Usage

The agent triggers on explicit request. Examples:

```
"Help me create a new Swift package for my networking layer"
"I need to build a settings screen with SwiftUI using @Observable"
"Review my Swift code for concurrency issues"
"Run the tests for my iOS app on iPhone 15 simulator"
```

### Agent Capabilities

- **Project Setup**: Create Swift packages, configure Xcode projects
- **SwiftUI Development**: Implement views with @Observable, NavigationStack
- **Concurrency**: Apply async/await, actors, Sendable correctly
- **Building & Testing**: Execute xcodebuild commands
- **Code Review**: Analyze for issues and anti-patterns
- **Simulator Management**: Boot, install, and launch apps

## Requirements

- macOS with Xcode 15+ (Xcode 16+ for Swift 6)
- Xcode Command Line Tools: `xcode-select --install`

## License

MIT
