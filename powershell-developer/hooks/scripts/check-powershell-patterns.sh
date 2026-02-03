#!/bin/bash
# PowerShell unsafe coding pattern detection hook
# Warns on writes containing anti-patterns in PowerShell files

set -uo pipefail

# Read input JSON
input=$(cat)

# Extract file path and content
file_path=$(echo "$input" | jq -r '.tool_input.file_path // .tool_input.filePath // ""' 2>/dev/null || echo "")
content=$(echo "$input" | jq -r '.tool_input.content // .tool_input.new_string // ""' 2>/dev/null || echo "")

# Skip if not a PowerShell file
if [[ ! "$file_path" == *.ps1 ]] && [[ ! "$file_path" == *.psm1 ]] && [[ ! "$file_path" == *.psd1 ]]; then
    exit 0
fi

# Skip if no content
if [[ -z "$content" ]]; then
    exit 0
fi

issues=()

# Pattern 1: Common aliases in scripts (should use full cmdlet names)
# Check for standalone aliases at word boundaries
if echo "$content" | grep -qE '\b(gci|gi|gl|gp|gwmi|iex|iwr|irm|ise|lp|ls|mi|mp|ndr|ni|nmo|nv|oh|ps|pwd|ri|rm|rmdir|rni|rnp|rv|rvpa|sajb|sc|sl|sp|spjb|sv|type|where|sort|foreach|select|measure|%|\\?)\b[[:space:]]'; then
    # Exclude if it's in a comment or string context (basic check)
    if ! echo "$content" | grep -qE '^[[:space:]]*#.*\b(gci|ls|rm|pwd)\b'; then
        issues+=("Aliases detected in script. Use full cmdlet names for readability: gci→Get-ChildItem, ls→Get-ChildItem, rm→Remove-Item, %→ForEach-Object, ?→Where-Object")
    fi
fi

# Pattern 2: Missing [CmdletBinding()] on functions with param blocks
# Check if there's a function with param() but no [CmdletBinding()]
if echo "$content" | grep -qE 'function\s+[A-Za-z]+-[A-Za-z]+' && echo "$content" | grep -qE '\bparam\s*\('; then
    if ! echo "$content" | grep -qE '\[CmdletBinding'; then
        issues+=("Function with parameters missing [CmdletBinding()]. Add [CmdletBinding()] before param() for advanced function features.")
    fi
fi

# Pattern 3: Hardcoded credentials or passwords
if echo "$content" | grep -qiE '(password|pwd|secret|apikey|api_key|token|credential)[[:space:]]*=[[:space:]]*["\047][^"\047]{4,}["\047]'; then
    issues+=("Hardcoded credential detected. Use SecretManagement module or secure prompts: Get-Credential, ConvertTo-SecureString")
fi

# Pattern 4: Missing -ErrorAction Stop in try block
# Check if there's a try block without -ErrorAction Stop nearby
if echo "$content" | grep -qE '\btry\s*\{'; then
    # Simple heuristic: if try exists but no -ErrorAction Stop anywhere
    if ! echo "$content" | grep -qE '-ErrorAction[[:space:]]+(Stop|'\''Stop'\'')'; then
        issues+=("try/catch without -ErrorAction Stop. Add -ErrorAction Stop to cmdlets in try blocks to catch non-terminating errors.")
    fi
fi

# Pattern 5: Using Write-Host for normal output
# Check for Write-Host not in a prompt/UI context
write_host_count=$(echo "$content" | grep -c 'Write-Host' 2>/dev/null || echo "0")
if [[ "$write_host_count" -gt 2 ]]; then
    # If many Write-Host calls, likely misusing it for output
    if ! echo "$content" | grep -qE 'ForegroundColor|BackgroundColor|-NoNewline'; then
        issues+=("Multiple Write-Host calls detected. Use Write-Output for pipeline-compatible output, Write-Host only for user prompts/UI.")
    fi
fi

# Pattern 6: Non-approved verb in function name
# Check for function names with non-standard verbs (basic check for common mistakes)
if echo "$content" | grep -qiE 'function\s+(Create|Delete|Modify|Execute|Run|Make|Do|Fetch|Retrieve|List)-'; then
    issues+=("Non-approved verb in function name. Use Get-Verb to see approved verbs: Create→New, Delete→Remove, Modify→Set, Execute/Run→Invoke, Fetch/Retrieve→Get")
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
  "systemMessage": "POWERSHELL BEST PRACTICES WARNING for $file_path:\\n\\n${issues_text}\\nConsider fixing these patterns for production-quality code. Run PSScriptAnalyzer for comprehensive analysis:\\n  Invoke-ScriptAnalyzer -Path '$file_path'"
}
EOF
    exit 0
fi

# No issues, allow the write silently
exit 0
