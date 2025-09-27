#!/bin/bash

# Ridges Agent Test Runner
# Usage: ./run_agent_test.sh [agent_path] [num_problems] [problem_set] [timeout]

set -e  # Exit on any error

# Default parameters
DEFAULT_AGENT_PATH="miner/custom_agent.py"
DEFAULT_NUM_PROBLEMS=1
DEFAULT_PROBLEM_SET="easy"
DEFAULT_TIMEOUT=300

# Parse command line arguments
AGENT_PATH=${1:-$DEFAULT_AGENT_PATH}
NUM_PROBLEMS=${2:-$DEFAULT_NUM_PROBLEMS}
PROBLEM_SET=${3:-$DEFAULT_PROBLEM_SET}
TIMEOUT=${4:-$DEFAULT_TIMEOUT}

# Validate problem set
if [[ ! "$PROBLEM_SET" =~ ^(easy|medium|hard)$ ]]; then
    echo "Error: Problem set must be 'easy', 'medium', or 'hard'"
    echo "Usage: $0 [agent_path] [num_problems] [problem_set] [timeout]"
    exit 1
fi

# Create timestamp for this run
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
RUN_DIR="runs/$TIMESTAMP"

# Create run directory
mkdir -p "$RUN_DIR"

echo "=========================================="
echo "Ridges Agent Test Runner"
echo "=========================================="
echo "Timestamp: $TIMESTAMP"
echo "Agent Path: $AGENT_PATH"
echo "Number of Problems: $NUM_PROBLEMS"
echo "Problem Set: $PROBLEM_SET"
echo "Timeout: ${TIMEOUT}s"
echo "Run Directory: $RUN_DIR"
echo "=========================================="

# Save run metadata
cat > "$RUN_DIR/meta.txt" << EOF
Run Timestamp: $TIMESTAMP
Agent Path: $AGENT_PATH
Number of Problems: $NUM_PROBLEMS
Problem Set: $PROBLEM_SET
Timeout: ${TIMEOUT}s
Start Time: $(date)
EOF

# Save git commit info for reproducibility
echo "Saving git commit information..."
{
    echo "Git Commit: $(git rev-parse HEAD 2>/dev/null || echo 'Not a git repository')"
    echo "Git Branch: $(git branch --show-current 2>/dev/null || echo 'Not a git repository')"
    echo "Git Status:"
    git status --porcelain 2>/dev/null || echo "Not a git repository"
    echo "Git Log (last 5 commits):"
    git log --oneline -5 2>/dev/null || echo "Not a git repository"
} > "$RUN_DIR/git_commit.txt"

# Check if agent file exists
if [ ! -f "ridges/$AGENT_PATH" ]; then
    echo "Error: Agent file not found at ridges/$AGENT_PATH"
    echo "Please ensure your custom agent code is placed at the correct path."
    exit 1
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo "Error: Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if Python is available
if ! command -v python3 &> /dev/null; then
    echo "Error: Python 3 is not installed or not in PATH"
    exit 1
fi

# Check if .env file exists
if [ ! -f ".env" ]; then
    echo "Warning: .env file not found. Using default configuration."
    echo "Consider copying env.template to .env and configuring your settings."
fi

# Load environment variables if .env exists
if [ -f ".env" ]; then
    echo "Loading environment variables from .env..."
    export $(grep -v '^#' .env | xargs)
fi

# Run the actual test
echo "Starting agent test..."
echo "This may take several minutes depending on the problem set and timeout."

# Log everything to the run directory
{
    echo "=========================================="
    echo "Test Execution Log"
    echo "=========================================="
    echo "Start Time: $(date)"
    echo ""
    
    # Change to ridges directory for the test
    cd ridges
    
    # Run the test with the specified parameters
    echo "Running test with parameters:"
    echo "  Agent: $AGENT_PATH"
    echo "  Problems: $NUM_PROBLEMS"
    echo "  Set: $PROBLEM_SET"
    echo "  Timeout: ${TIMEOUT}s"
    echo ""
    
    # This is where you would run your actual test command
    # For now, we'll simulate the test process
    echo "Simulating test execution..."
    echo "Note: Replace this section with your actual test command"
    echo ""
    echo "Example test command would be:"
    echo "python3 -m pytest test_agent.py --agent=$AGENT_PATH --problems=$NUM_PROBLEMS --set=$PROBLEM_SET --timeout=$TIMEOUT"
    echo ""
    
    # Simulate test progress
    for i in $(seq 1 $NUM_PROBLEMS); do
        echo "Processing problem $i/$NUM_PROBLEMS..."
        sleep 2  # Simulate processing time
        echo "Problem $i completed successfully"
    done
    
    echo ""
    echo "Test completed successfully!"
    echo "End Time: $(date)"
    
} 2>&1 | tee "../$RUN_DIR/run.log"

# Return to original directory
cd ..

echo ""
echo "=========================================="
echo "Test Complete!"
echo "=========================================="
echo "Results saved to: $RUN_DIR"
echo "Log file: $RUN_DIR/run.log"
echo "Metadata: $RUN_DIR/meta.txt"
echo "Git info: $RUN_DIR/git_commit.txt"
echo ""
echo "To view results:"
echo "  cat $RUN_DIR/run.log"
echo "  cat $RUN_DIR/meta.txt"
echo ""

