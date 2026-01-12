---
description: Comprehensive Swift development assistance for iOS/macOS apps, Swift packages, SwiftUI, Swift 6 concurrency, and code review with Apple documentation verification
argument-hint: Task description (e.g., "create a networking layer" or "review my code for concurrency issues")
allowed-tools: ["Task"]
---

# Swift Developer Command

Launch the swift-developer agent to provide expert Swift development assistance for iOS/macOS applications, Swift packages, SwiftUI, and Swift 6 concurrency patterns.

**User request:** $ARGUMENTS

---

## Instructions

Use the Task tool to invoke the `swift-developer` agent with the user's request.

The agent has access to:
- Swift knowledge skill with comprehensive reference documentation
- Apple documentation verification via WebFetch
- Tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, LSP, TodoWrite

**IMMEDIATELY invoke the agent using the Task tool:**

```
Task tool parameters:
- subagent_type: "swift-developer:swift-developer"
- description: "Swift development assistance"
- prompt: <the user's request from $ARGUMENTS, or if empty, ask "What Swift development task would you like help with?">
```

Do not process the request yourself. Launch the agent and let it handle the task.
