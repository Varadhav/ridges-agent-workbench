#!/bin/bash

# Multiple Miner Testing Script
# Usage: ./test_multiple_miners.sh [miner_directory] [num_problems] [problem_set] [timeout]

MINER_DIR=${1:-"ridges/miner"}
NUM_PROBLEMS=${2:-1}
PROBLEM_SET=${3:-"easy"}
TIMEOUT=${4:-300}

echo "=========================================="
echo "Multiple Miner Testing Script"
echo "=========================================="
echo "Miner Directory: $MINER_DIR"
echo "Problems: $NUM_PROBLEMS"
echo "Problem Set: $PROBLEM_SET"
echo "Timeout: ${TIMEOUT}s"
echo "=========================================="

# Find all miner files
MINER_FILES=$(find $MINER_DIR -name "top_agent_*.py" -o -name "custom_agent.py" | sort)

if [ -z "$MINER_FILES" ]; then
    echo "No miner files found in $MINER_DIR"
    exit 1
fi

echo "Found miner files:"
echo "$MINER_FILES"
echo ""

# Test each miner
for miner_file in $MINER_FILES; do
    echo "=========================================="
    echo "Testing: $miner_file"
    echo "=========================================="
    
    # Run test
    bash scripts/run_agent_test.sh "$miner_file" $NUM_PROBLEMS $PROBLEM_SET $TIMEOUT
    
    echo ""
    echo "Test completed for: $miner_file"
    echo "Results saved in runs/ directory"
    echo ""
done

echo "=========================================="
echo "All miner tests completed!"
echo "=========================================="
echo "Check runs/ directory for individual results"
echo "Use 'ls -la runs/' to see all test runs"
