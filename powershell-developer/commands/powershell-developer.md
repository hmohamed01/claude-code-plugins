---
description: Comprehensive PowerShell development assistance for scripts, modules, GUIs, and Windows automation with Microsoft best practices verification
argument-hint: Task description (e.g., "create a file browser GUI" or "review my script for best practices")
allowed-tools: ["Task"]
---

# PowerShell Developer Command

Launch the powershell-developer agent to provide expert PowerShell development assistance for scripts, modules, Windows Forms/WPF GUIs, and automation tasks.

**User request:** $ARGUMENTS

---

## Instructions

Use the Task tool to invoke the `powershell-developer` agent with the user's request.

The agent has access to:
- PowerShell knowledge skill with comprehensive reference documentation
- PowerShell Gallery verification via WebFetch/WebSearch
- Tools: Read, Write, Edit, Bash, Glob, Grep, WebFetch, WebSearch, TodoWrite

**IMMEDIATELY invoke the agent using the Task tool:**

```
Task tool parameters:
- subagent_type: "powershell-developer:powershell-developer"
- description: "PowerShell development assistance"
- prompt: <the user's request from $ARGUMENTS, or if empty, ask "What PowerShell development task would you like help with?">
```

Do not process the request yourself. Launch the agent and let it handle the task.
