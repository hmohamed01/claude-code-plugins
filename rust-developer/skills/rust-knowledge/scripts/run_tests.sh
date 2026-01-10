#!/bin/bash
# Run Rust tests with common options
# Usage: run_tests.sh [options]
#   --all        Run all tests including ignored
#   --verbose    Show test output
#   --coverage   Generate coverage report (requires cargo-tarpaulin)
#   --release    Run in release mode
#   --doc        Run doc tests only

set -e

CARGO_ARGS=""
TEST_ARGS=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --all)
            TEST_ARGS="$TEST_ARGS --include-ignored"
            shift
            ;;
        --verbose)
            TEST_ARGS="$TEST_ARGS --nocapture"
            shift
            ;;
        --coverage)
            if ! command -v cargo-tarpaulin &> /dev/null; then
                echo "Installing cargo-tarpaulin..."
                cargo install cargo-tarpaulin
            fi
            echo "Running tests with coverage..."
            cargo tarpaulin --out Html --output-dir coverage
            echo "Coverage report: coverage/tarpaulin-report.html"
            exit 0
            ;;
        --release)
            CARGO_ARGS="$CARGO_ARGS --release"
            shift
            ;;
        --doc)
            CARGO_ARGS="$CARGO_ARGS --doc"
            shift
            ;;
        *)
            TEST_ARGS="$TEST_ARGS $1"
            shift
            ;;
    esac
done

echo "Running: cargo test $CARGO_ARGS -- $TEST_ARGS"
cargo test $CARGO_ARGS -- $TEST_ARGS
