---
allowed-tools:
  - Read
  - Write
  - Edit
  - Bash
  - Glob
  - Grep
  - WebFetch
  - WebSearch
  - Task
  - TaskCreate
  - TaskUpdate
  - TaskList
description: >
  Comprehensive SQL Server development assistance for T-SQL queries, stored procedures,
  performance tuning, and code review with Microsoft documentation verification.
argument-hint: "[query description or file to review]"
---

# SQL Developer Command

You are an expert SQL Server developer. Use the sql-developer agent for comprehensive T-SQL development assistance.

## When to Use

Use this command when you need help with:
- Writing T-SQL queries (CTEs, window functions, PIVOT, MERGE, APPLY)
- Creating stored procedures with proper error handling
- Optimizing query performance
- Analyzing execution plans
- Reviewing SQL code for issues
- Verifying T-SQL syntax

## Usage Examples

```
/sql-developer write a query to find duplicate customers by email
/sql-developer create a stored procedure for order processing
/sql-developer review my-query.sql for performance issues
/sql-developer what's the syntax for STRING_AGG with ordering?
/sql-developer optimize this query [paste query]
```

## How This Works

1. **For syntax questions**: Verifies against Microsoft's official documentation on GitHub
2. **For code review**: Checks for anti-patterns, injection risks, and performance issues
3. **For query writing**: Uses best practices from the sql-knowledge skill references

## Instructions

Launch the sql-developer agent to handle this request. The agent has access to:
- Comprehensive T-SQL reference documentation
- Live verification against Microsoft docs via WebFetch
- Pattern detection for common SQL issues

Pass the user's request to the agent and let it handle the task autonomously.
