# SQL Developer Plugin

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![SQL Server](https://img.shields.io/badge/SQL%20Server-2016%2B-CC2927.svg?logo=microsoftsqlserver)](https://www.microsoft.com/sql-server)
[![T-SQL](https://img.shields.io/badge/T--SQL-Language-blue.svg)](https://learn.microsoft.com/en-us/sql/t-sql/language-reference)
[![Claude Code Plugin](https://img.shields.io/badge/Claude%20Code-Plugin-blueviolet)](https://github.com/anthropics/claude-code)

Autonomous SQL Server development agent for Claude Code. Write T-SQL queries, create stored procedures, optimize performance, and review code with live Microsoft documentation verification.

## Features

- **Query Development**: CTEs, window functions, PIVOT, MERGE, APPLY operators
- **Stored Procedures**: Proper error handling, transaction management, parameterization
- **Performance Tuning**: Execution plan analysis, index recommendations, anti-pattern detection
- **Code Review**: SQL injection detection, NOLOCK audit, non-SARGable pattern warnings
- **Live Verification**: Syntax verification against Microsoft's official GitHub documentation

## Installation

### From Marketplace
```bash
claude plugin marketplace add hmohamed01/claude-code-plugins
claude plugin install sql-developer
```

### Local Development
```bash
claude --plugin-dir ./sql-developer
```

## Usage

### Slash Command
```
/sql-developer write a query to find duplicate records
/sql-developer create a stored procedure for order processing
/sql-developer review my-query.sql for performance issues
/sql-developer what's the syntax for STRING_AGG?
```

### Agent Triggering
The sql-developer agent triggers when you ask for help with:
- T-SQL query writing or optimization
- Stored procedure development
- Execution plan analysis
- SQL code review
- T-SQL syntax verification

## Components

| Component | Purpose |
|-----------|---------|
| `sql-knowledge` skill | T-SQL patterns, performance, security, data types, transactions |
| `sql-developer` agent | Autonomous development with syntax verification |
| `/sql-developer` command | Direct invocation |
| Pattern hooks | Warn about unsafe SQL patterns in .sql files |

## Hook Warnings

The plugin warns about these patterns when writing `.sql` files:

| Pattern | Risk |
|---------|------|
| String concatenation in `EXEC()` | SQL Injection |
| `NOLOCK` without comment | Dirty reads |
| Missing `TRY...CATCH` in procedures | Unhandled errors |
| Cursor usage | Performance (set-based alternative may exist) |
| `SELECT *` in views/procedures | Maintenance, performance |
| Functions on columns in WHERE | Non-SARGable (no index usage) |
| Hardcoded credentials | Security |
| Multiple DML without transaction | Data integrity |
| `DATETIME` instead of `DATETIME2` | Precision, range |

Warnings are advisory and don't block writes.

## Live Documentation Verification

The agent verifies T-SQL syntax against Microsoft's official documentation:

```
Source: https://github.com/MicrosoftDocs/sql-docs
Format: Raw markdown via WebFetch
```

This ensures syntax recommendations are accurate and include version requirements.

## References

The skill includes detailed reference documentation:

- **patterns.md** - CTEs, pagination, PIVOT, MERGE, window functions
- **performance.md** - Execution plans, parameter sniffing, Query Store
- **security.md** - SQL injection prevention, dynamic SQL, permissions
- **data-types.md** - Type selection, collation, precision/scale
- **transactions.md** - Isolation levels, deadlocks, distributed transactions

## Example Queries

### Safe Dynamic SQL
```sql
DECLARE @sql NVARCHAR(MAX) = N'SELECT * FROM Users WHERE Name = @Name';
EXEC sp_executesql @sql, N'@Name NVARCHAR(100)', @Name = @UserInput;
```

### Error Handling
```sql
BEGIN TRY
    BEGIN TRANSACTION;
    -- operations
    COMMIT TRANSACTION;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0 ROLLBACK TRANSACTION;
    THROW;
END CATCH;
```

### Window Functions
```sql
SELECT OrderId, CustomerId, Amount,
    SUM(Amount) OVER (PARTITION BY CustomerId ORDER BY OrderDate) AS RunningTotal
FROM Orders;
```

## Contributing

Contributions welcome! Please follow the patterns established in this plugin.

## License

MIT
