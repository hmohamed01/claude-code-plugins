# swift-developer

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](https://opensource.org/licenses/MIT)
[![Platform](https://img.shields.io/badge/platform-macOS-lightgrey.svg)](https://developer.apple.com/macos/)
[![Swift](https://img.shields.io/badge/Swift-5.9%2B-orange.svg)](https://swift.org/)
[![Claude Code](https://img.shields.io/badge/Claude%20Code-compatible-blueviolet.svg)](https://claude.ai/code)

An autonomous Swift development agent for Claude Code that assists with iOS/macOS application development, Swift packages, SwiftUI, and Swift 6 concurrency patterns.

## Quick Start

Invoke the agent with the slash command:

```
/swift-developer:swift-developer
```

Then describe what you need help with. For example:
- "Create a SwiftUI settings screen with @Observable"
- "Review my code for concurrency issues"
- "Run tests on iPhone 15 simulator"

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

Add the plugin marketplace to Claude Code:

```bash
claude plugin marketplace add hmohamed01/claude-code-plugins
```

Then use `/plugins` to install swift-developer from the marketplace.

## Usage

### Slash Command (Recommended)

The fastest way to invoke the agent:

```
/swift-developer:swift-developer
```

Then describe your task in the next message. Examples:
- "Help me create a new Swift package for my networking layer"
- "I need to build a settings screen with SwiftUI using @Observable"
- "Review my Swift code for concurrency issues"
- "Run the tests for my iOS app on iPhone 15 simulator"

### Natural Language

The agent also triggers on explicit Swift-related requests in conversation.

### Agent Capabilities

- **Project Setup**: Create Swift packages, configure Xcode projects
- **SwiftUI Development**: Implement views with @Observable, NavigationStack
- **Concurrency**: Apply async/await, actors, Sendable correctly
- **Building & Testing**: Execute xcodebuild commands
- **Code Review**: Analyze for issues and anti-patterns
- **Simulator Management**: Boot, install, and launch apps

## Components

| Component | Name | Purpose |
|-----------|------|---------|
| Command | `/swift-developer:swift-developer` | Invoke the agent via slash command |
| Agent | swift-developer | Autonomous Swift development tasks |
| Skill | swift-knowledge | Swift development knowledge and patterns |
| Hooks | PreToolUse | Detect unsafe patterns in Swift code |

## Requirements

- macOS with Xcode 15+ (Xcode 16+ for Swift 6)
- Xcode Command Line Tools: `xcode-select --install`

## License

MIT
