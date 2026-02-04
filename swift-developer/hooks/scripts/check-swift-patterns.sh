#!/bin/bash
# Swift unsafe coding pattern detection hook
# Blocks writes containing unsafe patterns in Swift files

set -uo pipefail

# Read input JSON
input=$(cat)

# Extract file path and content
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.filePath // ""' 2>/dev/null || echo "")
content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string // ""' 2>/dev/null || echo "")

# Skip if not a Swift file
if [[ ! "$file_path" == *.swift ]]; then
    exit 0
fi

# Skip if no content
if [[ -z "$content" ]]; then
    exit 0
fi

issues=()

# Pattern 1: Force unwraps - look for identifier followed by ! not followed by =
# This catches: value!, foo.bar!, array[0]! but not !=
# Match word char or ] or ) followed by ! (not !=). Use || true since grep returns 1 on no match
force_unwrap_count=$(echo "$content" | grep -cE '(\w|]|\))[!]([^=]|$)' || true)
if [[ "$force_unwrap_count" -gt 0 ]]; then
    # Exclude common safe patterns (guard, if let already checked)
    if ! echo "$content" | grep -q 'guard let\|if let'; then
        issues+=("Force unwrap (!) detected. Use 'guard let' or 'if let' for safe unwrapping, or '??' for default values.")
    fi
fi

# Pattern 2: Hardcoded API keys/secrets
# Look for common patterns of hardcoded credentials
if echo "$content" | grep -qiE '(api_key|apikey|api_secret|apisecret|auth_token|authtoken|password|secret_key|secretkey)[[:space:]]*[:=][[:space:]]*"[^"]{8,}"'; then
    issues+=("Hardcoded API key or secret detected. Store credentials in Keychain or environment variables, not in source code.")
fi

# Check for Bearer tokens
if echo "$content" | grep -qE '"Bearer [A-Za-z0-9_-]{20,}"'; then
    issues+=("Hardcoded Bearer token detected. Store tokens securely, not in source code.")
fi

# Check for long alphanumeric strings that look like API keys (sk-, pk-, etc.)
if echo "$content" | grep -qE '"(sk|pk|api|key|token)[_-][A-Za-z0-9]{20,}"'; then
    issues+=("Potential API key detected (sk-, pk-, etc.). Store secrets securely, not in source code.")
fi

# Pattern 3: Blocking main thread with sync calls
if echo "$content" | grep -qE 'DispatchQueue\.main\.sync'; then
    issues+=("DispatchQueue.main.sync detected. Use .async to avoid blocking the main thread.")
fi

# Pattern 4: @unchecked Sendable without synchronization primitives
if echo "$content" | grep -q '@unchecked Sendable'; then
    # Check if the same content has proper synchronization
    if ! echo "$content" | grep -qE 'NSLock|os_unfair_lock|DispatchQueue|actor |Mutex|Lock\(\)'; then
        issues+=("@unchecked Sendable used without visible synchronization. Add NSLock, DispatchQueue, or other thread-safety mechanism.")
    fi
fi

# Pattern 5: Missing @MainActor on ObservableObject/Observable class
# Check if there's a class conforming to ObservableObject without @MainActor
if echo "$content" | grep -qE 'class[[:space:]]+[A-Za-z]+[[:space:]]*:[[:space:]]*(ObservableObject|Observable)'; then
    if ! echo "$content" | grep -qE '@MainActor[[:space:]]+(final[[:space:]]+)?class'; then
        if echo "$content" | grep -qE '@Published|@Observable'; then
            issues+=("ObservableObject/Observable class should use @MainActor for thread-safe UI updates.")
        fi
    fi
fi

# If issues found, block with detailed message
if [[ ${#issues[@]} -gt 0 ]]; then
    # Build issues message
    issues_text=""
    for i in "${!issues[@]}"; do
        issues_text+="$((i+1)). ${issues[$i]}\\n"
    done

    # Output JSON to stderr (exit code 2 = blocking error)
    cat >&2 << EOF
{
  "hookSpecificOutput": {
    "permissionDecision": "deny"
  },
  "systemMessage": "UNSAFE SWIFT PATTERNS DETECTED in $file_path:\\n\\n${issues_text}\\nPlease fix these issues before writing the file. Use safe alternatives:\\n- Force unwrap: Use guard let, if let, or ?? operator\\n- Secrets: Use Keychain or environment variables\\n- Main thread: Use async/await or .async instead of .sync\\n- Sendable: Add proper locking with NSLock or use actors\\n- UI classes: Add @MainActor to ObservableObject classes"
}
EOF
    exit 2
fi

# No issues, allow the write
exit 0
