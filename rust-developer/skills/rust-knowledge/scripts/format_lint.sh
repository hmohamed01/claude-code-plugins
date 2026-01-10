#!/bin/bash
# Format and lint Rust code
# Usage: format_lint.sh [--check] [--fix]
#   --check   Check without modifying (for CI)
#   --fix     Auto-fix clippy warnings where possible

set -e

CHECK_MODE=false
FIX_MODE=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --check)
            CHECK_MODE=true
            shift
            ;;
        --fix)
            FIX_MODE=true
            shift
            ;;
        *)
            shift
            ;;
    esac
done

echo "=== Rust Code Quality Check ==="
echo ""

# Format
echo ">> Running rustfmt..."
if [ "$CHECK_MODE" = true ]; then
    cargo fmt -- --check
    echo "   Format check passed"
else
    cargo fmt
    echo "   Code formatted"
fi
echo ""

# Clippy
echo ">> Running clippy..."
CLIPPY_ARGS="--all-targets --all-features"

if [ "$FIX_MODE" = true ]; then
    cargo clippy $CLIPPY_ARGS --fix --allow-dirty --allow-staged
    echo "   Clippy fixes applied"
elif [ "$CHECK_MODE" = true ]; then
    cargo clippy $CLIPPY_ARGS -- -D warnings
    echo "   Clippy check passed"
else
    cargo clippy $CLIPPY_ARGS
fi
echo ""

# Check for common issues
echo ">> Checking for common issues..."

# Check for TODO/FIXME
TODO_COUNT=$(grep -r "TODO\|FIXME" --include="*.rs" . 2>/dev/null | wc -l | tr -d ' ')
if [ "$TODO_COUNT" -gt 0 ]; then
    echo "   Found $TODO_COUNT TODO/FIXME comments"
fi

# Check for unwrap
UNWRAP_COUNT=$(grep -r "\.unwrap()" --include="*.rs" . 2>/dev/null | grep -v "test" | grep -v "#\[cfg(test)\]" | wc -l | tr -d ' ')
if [ "$UNWRAP_COUNT" -gt 0 ]; then
    echo "   Found $UNWRAP_COUNT .unwrap() calls (consider using .expect() or ?)"
fi

echo ""
echo "=== Done ==="
