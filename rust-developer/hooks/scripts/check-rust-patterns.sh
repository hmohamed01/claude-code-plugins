#!/bin/bash
# Rust unsafe coding pattern detection hook
# Warns on writes containing anti-patterns in Rust files

set -uo pipefail

# Read input JSON
input=$(cat)

# Extract file path and content
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.filePath // ""' 2>/dev/null || echo "")
content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string // ""' 2>/dev/null || echo "")

# Skip if not a Rust file
if [[ ! "$file_path" == *.rs ]]; then
    exit 0
fi

# Skip if no content
if [[ -z "$content" ]]; then
    exit 0
fi

issues=()

# Pattern 1: Hardcoded secrets/API keys
if echo "$content" | grep -qiE '(api_key|apikey|secret|password|token)\s*[:=]\s*"[^"]{8,}"'; then
    issues+=("Potential hardcoded secret detected. Use environment variables instead.")
fi

# Pattern 2: panic! in library code (not in tests or main.rs)
if [[ ! "$file_path" =~ (test|main\.rs) ]] && echo "$content" | grep -qE 'panic!\s*\('; then
    issues+=("panic! in library code. Consider returning Result instead.")
fi

# Pattern 3: Multiple unwrap() without expect() context
if [[ ! "$file_path" =~ test ]]; then
    unwrap_count=$(echo "$content" | grep -c '\.unwrap()' || true)
    expect_count=$(echo "$content" | grep -c '\.expect(' || true)

    if [[ "$unwrap_count" -gt 3 ]] && [[ "$expect_count" -eq 0 ]]; then
        issues+=("Multiple .unwrap() calls without .expect(). Consider adding context with .expect(\"reason\").")
    fi
fi

# Pattern 4: unsafe blocks without SAFETY comment
if echo "$content" | grep -qE 'unsafe\s*\{' && ! echo "$content" | grep -qE '// SAFETY:'; then
    issues+=("unsafe block without SAFETY comment. Add '// SAFETY: <reason>' before unsafe blocks.")
fi

# Pattern 5: Blocking operations in async context
if echo "$content" | grep -qE 'async\s+fn' && echo "$content" | grep -qE 'std::thread::sleep|std::fs::(read|write)'; then
    issues+=("Blocking operation in async function. Use tokio equivalents (tokio::time::sleep, tokio::fs).")
fi

# If issues found, warn (exit 0 to allow, just inform)
if [[ ${#issues[@]} -gt 0 ]]; then
    # Build issues message
    issues_text=""
    for i in "${!issues[@]}"; do
        issues_text+="$((i+1)). ${issues[$i]}\\n"
    done

    # Output JSON to stderr (exit code 0 = warning only, don't block)
    cat >&2 << EOF
{
  "hookSpecificOutput": {
    "permissionDecision": "allow"
  },
  "systemMessage": "RUST BEST PRACTICES WARNING for $file_path:\\n\\n${issues_text}\\nConsider fixing these patterns for production-quality code. Run clippy for comprehensive analysis:\\n  cargo clippy -- -W clippy::all"
}
EOF
    exit 0
fi

# No issues, allow the write silently
exit 0
