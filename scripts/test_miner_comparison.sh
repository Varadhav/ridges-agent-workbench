#!/bin/bash

# Multi-Miner Comparison Testing Script
# Usage: ./test_miner_comparison.sh [miner1] [miner2] [num_problems] [problem_set] [timeout]
# 
# This script tests multiple miners and creates comparison reports

set -e  # Exit on any error

# Default parameters
DEFAULT_MINER1="ridges/miner/custom_agent.py"
DEFAULT_MINER2="ridges/miner/top_miner_v2.py"
DEFAULT_NUM_PROBLEMS=1
DEFAULT_PROBLEM_SET="easy"
DEFAULT_TIMEOUT=300

# Parse command line arguments
MINER1=${1:-$DEFAULT_MINER1}
MINER2=${2:-$DEFAULT_MINER2}
NUM_PROBLEMS=${3:-$DEFAULT_NUM_PROBLEMS}
PROBLEM_SET=${4:-$DEFAULT_PROBLEM_SET}
TIMEOUT=${5:-$DEFAULT_TIMEOUT}

# Create timestamp for this comparison run
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
COMPARISON_DIR="runs/comparison_${TIMESTAMP}"

# Create comparison directory
mkdir -p "$COMPARISON_DIR"

echo "=========================================="
echo "Multi-Miner Comparison Testing"
echo "=========================================="
echo "Timestamp: $TIMESTAMP"
echo "Miner 1: $MINER1"
echo "Miner 2: $MINER2"
echo "Problems: $NUM_PROBLEMS $PROBLEM_SET"
echo "Timeout: ${TIMEOUT}s"
echo "Comparison Dir: $COMPARISON_DIR"
echo "=========================================="

# Test Miner 1
echo ""
echo "--- Testing Miner 1: $MINER1 ---"
MINER1_DIR="$COMPARISON_DIR/miner1_$(basename $MINER1 .py)"
mkdir -p "$MINER1_DIR"

echo "Running: bash scripts/run_agent_test.sh $MINER1 $NUM_PROBLEMS $PROBLEM_SET $TIMEOUT"
bash scripts/run_agent_test.sh "$MINER1" "$NUM_PROBLEMS" "$PROBLEM_SET" "$TIMEOUT" > "$MINER1_DIR/test_output.log" 2>&1

# Copy results to comparison directory
LATEST_RUN=$(ls -t runs/ | head -1)
if [ -d "runs/$LATEST_RUN" ]; then
    cp -r "runs/$LATEST_RUN"/* "$MINER1_DIR/"
    echo "Miner 1 results saved to: $MINER1_DIR"
else
    echo "Warning: Could not find latest run results for Miner 1"
fi

# Test Miner 2
echo ""
echo "--- Testing Miner 2: $MINER2 ---"
MINER2_DIR="$COMPARISON_DIR/miner2_$(basename $MINER2 .py)"
mkdir -p "$MINER2_DIR"

echo "Running: bash scripts/run_agent_test.sh $MINER2 $NUM_PROBLEMS $PROBLEM_SET $TIMEOUT"
bash scripts/run_agent_test.sh "$MINER2" "$NUM_PROBLEMS" "$PROBLEM_SET" "$TIMEOUT" > "$MINER2_DIR/test_output.log" 2>&1

# Copy results to comparison directory
LATEST_RUN=$(ls -t runs/ | head -1)
if [ -d "runs/$LATEST_RUN" ]; then
    cp -r "runs/$LATEST_RUN"/* "$MINER2_DIR/"
    echo "Miner 2 results saved to: $MINER2_DIR"
else
    echo "Warning: Could not find latest run results for Miner 2"
fi

# Create comparison summary
echo ""
echo "--- Creating Comparison Summary ---"
cat > "$COMPARISON_DIR/comparison_summary.md" << EOF
# Miner Comparison Report

**Timestamp**: $TIMESTAMP
**Problem Set**: $NUM_PROBLEMS $PROBLEM_SET problems
**Timeout**: ${TIMEOUT}s

## Tested Miners

### Miner 1: $MINER1
- **Results Directory**: $MINER1_DIR
- **Log File**: $MINER1_DIR/run.log
- **Metadata**: $MINER1_DIR/meta.txt

### Miner 2: $MINER2
- **Results Directory**: $MINER2_DIR
- **Log File**: $MINER2_DIR/run.log
- **Metadata**: $MINER2_DIR/meta.txt

## Quick Comparison

\`\`\`bash
# View Miner 1 results
cat $MINER1_DIR/run.log

# View Miner 2 results  
cat $MINER2_DIR/run.log

# Compare performance
echo "=== Miner 1 Summary ==="
tail -20 $MINER1_DIR/run.log

echo "=== Miner 2 Summary ==="
tail -20 $MINER2_DIR/run.log
\`\`\`

## Files Structure

\`\`\`
$COMPARISON_DIR/
├── miner1_$(basename $MINER1 .py)/
│   ├── run.log
│   ├── meta.txt
│   └── git_commit.txt
├── miner2_$(basename $MINER2 .py)/
│   ├── run.log
│   ├── meta.txt
│   └── git_commit.txt
└── comparison_summary.md
\`\`\`
EOF

echo ""
echo "=========================================="
echo "Comparison Complete!"
echo "=========================================="
echo "Results saved to: $COMPARISON_DIR"
echo "Summary: $COMPARISON_DIR/comparison_summary.md"
echo ""
echo "To view results:"
echo "  cat $COMPARISON_DIR/comparison_summary.md"
echo "  cat $COMPARISON_DIR/miner1_$(basename $MINER1 .py)/run.log"
echo "  cat $COMPARISON_DIR/miner2_$(basename $MINER2 .py)/run.log"
echo "=========================================="
