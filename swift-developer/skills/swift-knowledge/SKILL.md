---
name: swift-knowledge
description: >
  Comprehensive Swift development knowledge for iOS/macOS applications, Swift packages, and modern Swift patterns.
  Use when working with: (1) xcodebuild commands and Xcode projects, (2) Swift Package Manager,
  (3) SwiftUI views and patterns, (4) Swift 6 concurrency (async/await, actors, Sendable),
  (5) XCTest and Swift Testing frameworks, (6) iOS simulator management with simctl,
  (7) Code signing and app distribution, (8) SwiftFormat and SwiftLint configuration.
---

# Swift Development Knowledge

## Prerequisites

- macOS with Xcode 15+ (Xcode 16+ for Swift 6)
- Xcode Command Line Tools: `xcode-select --install`
- Verify: `xcodebuild -version` and `swift --version`

## Quick Reference

### Essential Commands

| Task | Command |
|------|---------|
| Build package | `swift build` |
| Build release | `swift build -c release` |
| Run tests | `swift test` |
| Update deps | `swift package update` |
| List simulators | `xcrun simctl list devices` |
| Boot simulator | `xcrun simctl boot "iPhone 15"` |
| Install app | `xcrun simctl install booted ./App.app` |
| Format code | `swiftformat .` |
| Lint code | `swiftlint` |

### Common Destinations

```bash
# iOS Simulator
-destination 'platform=iOS Simulator,name=iPhone 15'

# macOS
-destination 'platform=macOS'

# Generic iOS (for archives)
-destination 'generic/platform=iOS'
```

## Official Documentation

For authoritative reference, use Apple's official Swift documentation from the GitHub swift-book repository.

**IMPORTANT**: Apple's developer.apple.com uses a Single Page Application (SPA) that requires JavaScript, so WebFetch cannot extract content from it. Instead, use the raw GitHub URLs below which provide static markdown that WebFetch can process.

### Swift Language Documentation (GitHub)

Base URL: `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/`

| Topic | URL |
|-------|-----|
| Concurrency | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Concurrency.md` |
| Protocols | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Protocols.md` |
| Generics | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Generics.md` |
| Error Handling | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/ErrorHandling.md` |
| Closures | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Closures.md` |
| Memory Safety | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/MemorySafety.md` |
| Access Control | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/AccessControl.md` |
| Macros | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Macros.md` |
| Opaque Types | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/OpaqueTypes.md` |
| Initialization | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Initialization.md` |
| Properties | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Properties.md` |
| Methods | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/LanguageGuide/Methods.md` |
| Attributes | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/ReferenceManual/Attributes.md` |
| Types | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/ReferenceManual/Types.md` |
| Declarations | `https://raw.githubusercontent.com/swiftlang/swift-book/main/TSPL.docc/ReferenceManual/Declarations.md` |

Use `WebFetch` with these URLs to retrieve specific language feature details when implementing Swift code.

**Note**: SwiftUI framework documentation is NOT available on GitHub. For SwiftUI-specific APIs, rely on the reference files in this skill and your training knowledge.

### Additional GitHub Documentation Sources

Beyond the Swift Book, these repositories provide authoritative documentation:

| Repository | Use For | URL |
|------------|---------|-----|
| Swift Testing | Swift Testing framework (`@Test`, `#expect`) | `https://github.com/apple/swift-testing` |
| Swift Evolution | Latest language proposals and features | `https://github.com/apple/swift-evolution/tree/main/proposals` |
| Swift Compiler Docs | Compiler internals and ABI | `https://github.com/apple/swift/tree/main/docs` |
| Swift Async Algorithms | Async sequences and algorithms | `https://github.com/apple/swift-async-algorithms` |

**Example WebFetch URLs:**
- Swift Testing: `https://raw.githubusercontent.com/apple/swift-testing/main/README.md`
- Evolution Proposal: `https://raw.githubusercontent.com/apple/swift-evolution/main/proposals/0401-remove-property-wrapper-isolation.md`
- Async Algorithms: `https://raw.githubusercontent.com/apple/swift-async-algorithms/main/README.md`

## Reference Files

Detailed documentation for specific topics:

| Topic | File |
|-------|------|
| SwiftUI patterns | [references/swiftui-patterns.md](references/swiftui-patterns.md) |
| Swift 6 concurrency | [references/concurrency.md](references/concurrency.md) |
| Testing patterns | [references/testing-patterns.md](references/testing-patterns.md) |
| Architecture patterns | [references/architecture.md](references/architecture.md) |
| Best practices | [references/best-practices.md](references/best-practices.md) |
| Swift Package Manager | [references/spm.md](references/spm.md) |
| xcodebuild commands | [references/xcodebuild.md](references/xcodebuild.md) |
| Simulator control | [references/simctl.md](references/simctl.md) |
| Code signing | [references/code-signing.md](references/code-signing.md) |
| CI/CD setup | [references/cicd.md](references/cicd.md) |
| Troubleshooting | [references/troubleshooting.md](references/troubleshooting.md) |

## Included Scripts

| Script | Purpose |
|--------|---------|
| `scripts/new_package.sh` | Create new Swift package with config files |
| `scripts/run_tests.sh` | Run tests with common options |
| `scripts/format_and_lint.sh` | Format and lint Swift code |
| `scripts/simulator.sh` | Quick simulator management |

Run scripts from the skill directory:
```bash
$CLAUDE_PLUGIN_ROOT/skills/swift-knowledge/scripts/new_package.sh MyPackage
```

## Asset Templates

| Asset | Purpose |
|-------|---------|
| `assets/Package.swift.template` | Swift package manifest template |
| `assets/.swiftformat` | SwiftFormat configuration |
| `assets/.swiftlint.yml` | SwiftLint configuration |

## Best Practices Summary

### DO
- Use SwiftUI + @Observable for iOS 17+ projects
- Use async/await for all async operations
- Store secrets in Keychain, not UserDefaults
- Use `@MainActor` for UI-related code
- Enable strict concurrency checking
- Test on real devices before release

### DON'T
- Force unwrap without safety checks
- Block main thread with sync operations
- Store API keys in source code
- Ignore Swift 6 concurrency warnings
- Skip error handling
