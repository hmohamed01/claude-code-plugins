#!/bin/bash
# SQL Pattern Checker for Claude Code
# Warns about unsafe T-SQL patterns

FILE_PATH="$1"
CONTENT="$2"

warnings=""

# Check for SQL injection risks (string concatenation in dynamic SQL)
if echo "$CONTENT" | grep -qiE "EXEC\s*\(\s*['\"].*\+.*@|EXEC\s*\(@.*\+"; then
    warnings="${warnings}⚠️  SQL INJECTION RISK: String concatenation in EXEC(). Use sp_executesql with parameters instead.\n"
fi

# Check for direct concatenation with user variables
if echo "$CONTENT" | grep -qiE "'\s*\+\s*@\w+\s*\+\s*'|@\w+\s*\+\s*'"; then
    warnings="${warnings}⚠️  SQL INJECTION RISK: Direct string concatenation with variables. Use parameterized queries.\n"
fi

# Check for NOLOCK without comment explaining why
if echo "$CONTENT" | grep -qiE "WITH\s*\(\s*NOLOCK\s*\)|NOLOCK"; then
    # Check if there's a comment explaining the NOLOCK usage
    has_nolock_comment=$(echo "$CONTENT" | grep -ciE "(--|/\*).*nolock" 2>/dev/null || true)
    if [ "${has_nolock_comment:-0}" -eq 0 ]; then
        warnings="${warnings}⚠️  NOLOCK HINT: Using NOLOCK can cause dirty reads. Add a comment explaining why it's acceptable here.\n"
    fi
fi

# Check for missing error handling in stored procedures
if echo "$CONTENT" | grep -qiE "CREATE\s+(OR\s+ALTER\s+)?PROC(EDURE)?"; then
    if ! echo "$CONTENT" | grep -qiE "BEGIN\s+TRY|TRY\s*\.\.\.CATCH"; then
        warnings="${warnings}⚠️  MISSING ERROR HANDLING: Stored procedure should include TRY...CATCH block.\n"
    fi
fi

# Check for cursor usage (often indicates set-based alternative exists)
if echo "$CONTENT" | grep -qiE "DECLARE\s+\w+\s+CURSOR|OPEN\s+\w+|FETCH\s+NEXT"; then
    warnings="${warnings}⚠️  CURSOR USAGE: Consider if a set-based operation (CTE, window function) would be more efficient.\n"
fi

# Check for SELECT * in non-ad-hoc contexts
if echo "$CONTENT" | grep -qiE "SELECT\s+\*\s+FROM" && echo "$CONTENT" | grep -qiE "CREATE\s+(VIEW|PROC|FUNCTION)|INSERT\s+INTO"; then
    warnings="${warnings}⚠️  SELECT *: Avoid SELECT * in views, procedures, or INSERT statements. List columns explicitly.\n"
fi

# Check for non-SARGable patterns
if echo "$CONTENT" | grep -qiE "WHERE\s+\w+\s*\(\s*\w+\s*\)\s*=|WHERE\s+YEAR\s*\(|WHERE\s+MONTH\s*\(|WHERE\s+CONVERT\s*\(|WHERE\s+CAST\s*\("; then
    warnings="${warnings}⚠️  NON-SARGABLE: Function on column in WHERE clause prevents index usage. Restructure the predicate.\n"
fi

# Check for hardcoded credentials
if echo "$CONTENT" | grep -qiE "PASSWORD\s*=\s*['\"][^'\"]+['\"]|PWD\s*=\s*['\"][^'\"]+['\"]"; then
    warnings="${warnings}⚠️  HARDCODED CREDENTIALS: Never store passwords in SQL scripts. Use secure credential management.\n"
fi

# Check for missing transaction handling with multiple DML
dml_count=$(echo "$CONTENT" | grep -ciE "^\s*(INSERT|UPDATE|DELETE|MERGE)\s+" 2>/dev/null || true)
dml_count=${dml_count:-0}
if [ "$dml_count" -gt 1 ] 2>/dev/null; then
    if ! echo "$CONTENT" | grep -qiE "BEGIN\s+TRAN(SACTION)?|COMMIT|ROLLBACK"; then
        warnings="${warnings}⚠️  MISSING TRANSACTION: Multiple DML statements without explicit transaction handling.\n"
    fi
fi

# Check for deprecated DATETIME usage in CREATE TABLE
if echo "$CONTENT" | grep -qiE "CREATE\s+TABLE" && echo "$CONTENT" | grep -qiE "\bDATETIME\b" && ! echo "$CONTENT" | grep -qiE "DATETIME2"; then
    warnings="${warnings}⚠️  DEPRECATED TYPE: Consider using DATETIME2 instead of DATETIME for better precision and range.\n"
fi

# Output warnings if any
if [ -n "$warnings" ]; then
    echo -e "\n🔍 SQL Pattern Analysis for: $FILE_PATH\n"
    echo -e "$warnings"
    echo -e "These are advisory warnings. Review and address as appropriate.\n"
fi

# Always exit 0 (advisory mode - don't block writes)
exit 0
