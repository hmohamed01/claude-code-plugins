#!/bin/bash
# Hook script to check for unsafe Rust patterns in Write/Edit operations
# Blocks writes that contain dangerous patterns

set -e

# Read the tool input from stdin
INPUT=$(cat)

# Extract file path and content
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // .tool_input.path // ""')
CONTENT=$(echo "$INPUT" | jq -r '.tool_input.content // .tool_input.new_string // ""')

# Only check .rs files
if [[ ! "$FILE_PATH" =~ \.rs$ ]]; then
    echo '{"decision": "approve"}'
    exit 0
fi

ISSUES=()

# Check for hardcoded secrets/API keys
if echo "$CONTENT" | grep -qiE '(api_key|apikey|secret|password|token)\s*[:=]\s*"[^"]{8,}"'; then
    ISSUES+=("Potential hardcoded secret detected. Use environment variables instead.")
fi

# Check for panic! in library code (not in tests or main.rs)
if [[ ! "$FILE_PATH" =~ (test|main\.rs) ]] && echo "$CONTENT" | grep -qE 'panic!\s*\('; then
    ISSUES+=("panic! in library code. Consider returning Result instead.")
fi

# Check for unwrap() without expect() context (simple heuristic)
# Allow unwrap in tests
if [[ ! "$FILE_PATH" =~ test ]]; then
    UNWRAP_COUNT=$(echo "$CONTENT" | grep -c '\.unwrap()' || true)
    EXPECT_COUNT=$(echo "$CONTENT" | grep -c '\.expect(' || true)

    if [ "$UNWRAP_COUNT" -gt 3 ] && [ "$EXPECT_COUNT" -eq 0 ]; then
        ISSUES+=("Multiple .unwrap() calls without .expect(). Consider adding context with .expect(\"reason\").")
    fi
fi

# Check for unsafe blocks without comment justification
if echo "$CONTENT" | grep -qE 'unsafe\s*\{' && ! echo "$CONTENT" | grep -qB2 '// SAFETY:'; then
    ISSUES+=("unsafe block without SAFETY comment. Add '// SAFETY: <reason>' before unsafe blocks.")
fi

# Check for blocking operations in async context
if echo "$CONTENT" | grep -qE 'async\s+fn' && echo "$CONTENT" | grep -qE 'std::thread::sleep|std::fs::(read|write)'; then
    ISSUES+=("Blocking operation in async function. Use tokio equivalents (tokio::time::sleep, tokio::fs).")
fi

# If there are issues, report them as warnings but still approve
# We don't want to block the write, just inform
if [ ${#ISSUES[@]} -gt 0 ]; then
    MESSAGE=$(printf '%s\n' "${ISSUES[@]}" | jq -Rs '.')
    echo "{\"decision\": \"approve\", \"message\": $MESSAGE}"
else
    echo '{"decision": "approve"}'
fi
