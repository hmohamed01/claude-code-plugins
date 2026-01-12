---
description: Comprehensive Rust development assistance for systems programming, async applications, web services, and CLI tools with Rust documentation verification
argument-hint: Task description (e.g., "create a new CLI tool" or "review my async code")
allowed-tools: ["Task"]
---

# Rust Developer Command

Launch the rust-developer agent to provide expert Rust development assistance for systems programming, async applications, web services, and CLI tools.

**User request:** $ARGUMENTS

---

## Instructions

Use the Task tool to invoke the `rust-developer` agent with the user's request.

The agent has access to:
- Rust knowledge skill with comprehensive reference documentation
- Rust Book documentation verification via WebFetch
- Tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, LSP, TodoWrite

**IMMEDIATELY invoke the agent using the Task tool:**

```
Task tool parameters:
- subagent_type: "rust-developer:rust-developer"
- description: "Rust development assistance"
- prompt: <the user's request from $ARGUMENTS, or if empty, ask "What Rust development task would you like help with?">
```

Do not process the request yourself. Launch the agent and let it handle the task.
