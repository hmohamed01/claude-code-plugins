#!/bin/bash
# Create a new Rust project with standard configuration files
# Usage: new_project.sh <project-name> [--lib]

set -e

PROJECT_NAME="${1:-my-project}"
IS_LIB="${2:-}"

if [ -z "$PROJECT_NAME" ]; then
    echo "Usage: new_project.sh <project-name> [--lib]"
    exit 1
fi

# Create project
if [ "$IS_LIB" = "--lib" ]; then
    cargo new --lib "$PROJECT_NAME"
else
    cargo new "$PROJECT_NAME"
fi

cd "$PROJECT_NAME"

# Create rustfmt.toml
cat > rustfmt.toml << 'EOF'
edition = "2021"
max_width = 100
tab_spaces = 4
use_small_heuristics = "Default"
imports_granularity = "Module"
group_imports = "StdExternalCrate"
reorder_imports = true
EOF

# Create clippy.toml
cat > clippy.toml << 'EOF'
cognitive-complexity-threshold = 25
too-many-arguments-threshold = 7
type-complexity-threshold = 250
EOF

# Create .gitignore if not exists
if [ ! -f .gitignore ]; then
    cat > .gitignore << 'EOF'
/target
Cargo.lock
**/*.rs.bk
*.pdb
.env
.env.local
EOF
fi

# Add common dev dependencies to Cargo.toml
cat >> Cargo.toml << 'EOF'

[dev-dependencies]
# Add test dependencies here

[lints.rust]
unsafe_code = "warn"

[lints.clippy]
all = "warn"
pedantic = "warn"
nursery = "warn"
EOF

# Add lib-specific clippy config
if [ "$IS_LIB" = "--lib" ]; then
    cat >> Cargo.toml << 'EOF'

# For library crates
missing_docs = "warn"
EOF
fi

echo "Created Rust project: $PROJECT_NAME"
echo ""
echo "Next steps:"
echo "  cd $PROJECT_NAME"
echo "  cargo build"
echo "  cargo test"
echo "  cargo clippy"
