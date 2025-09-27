# My Ridges Agent Workbench

Personal workbench for working with the Ridges AI agent system and running reproducible local evaluations with top miner code.

## Prerequisites

Before using this workbench, ensure you have:

* **Python 3.11+** installed and available
* **Local ridges repository** cloned and set up in the same directory as this workbench
* **Chutes API key** configured in `ridges/proxy/.env`
* **Docker** installed and running (required for local testing)
* **Git** for version control

### Getting Your Chutes API Key

1. Sign up for a Chutes account at [chutes.com](https://chutes.com)
2. Navigate to your API settings
3. Generate a new API key
4. Copy the key for configuration

### Setting Up Environment

```bash
# Copy the environment template
cp env.template .env

# Edit .env with your actual API key
nano .env
```

Add your Chutes API key to the `.env` file:
```
CHUTES_API_KEY=your_actual_api_key_here
```

## Project Structure

* `scripts/` - Automation scripts for testing and evaluation  
   * `run_agent_test.sh` - Linux/Mac wrapper for ridges.py test-agent
   * `run_ridges_test.bat` - Windows wrapper for ridges.py test-agent
   * `run_agent_test.ps1` - PowerShell wrapper for local testing
   * `run_agent_test.bat` - Windows CMD wrapper for local testing
* `runs/` - Timestamped test results and logs (ignored by git)
* `ridges/` - Local copy of the Ridges repository
* `env.template` - Environment configuration template
* `README.md` - This documentation
* `.gitignore` - Git ignore configuration

## Getting Open Top Agents

### Step 1: Explore Available Agents

1. Access the Ridges platform or agent marketplace
2. Browse available open-source top agents via the Explore section
3. Review agent performance metrics and compatibility
4. Select a top-performing agent that meets your requirements

### Step 2: Download Agent Code

1. Select a top-performing open agent from the available options
2. Copy the complete agent code (typically 300KB+ for production agents)
3. Save the code to `ridges/miner/top_agent_tmp.py`

### Step 3: Verify Agent Structure

Ensure the downloaded agent contains:

* `agent_main(input_dict)` function as the main entry point
* Proper error handling and return format: `{"patch": "...diff..."}`
* No unauthorized outbound network calls (only proxy endpoints allowed)

### Step 4: Test Your Agent

Once you have your open top agent code in place:

```bash
# Test with default parameters
bash scripts/run_agent_test.sh

# Test with custom parameters
bash scripts/run_agent_test.sh ridges/miner/top_agent_tmp.py 3 medium 600
```

## Current Top Miner Integration

### ✅ **COMPLETED**: Advanced Top Miner Code Integrated

Your advanced top miner code has been successfully integrated:

* **File**: `ridges/miner/custom_agent.py` (3,922 lines)
* **Function**: `agent_main(input_dict)` ✅
* **Return Format**: `{"patch": "..."}` ✅
* **Features**: Advanced problem-solving, multi-language support, comprehensive tooling
* **Status**: Ready for testing and evaluation

### Top Miner Capabilities

Your integrated top miner includes:

* **Multi-language Support**: Python, JavaScript, TypeScript, Java, C++, Go, Rust
* **Advanced Problem Analysis**: Pattern recognition, complexity assessment
* **Comprehensive Tooling**: Git integration, testing frameworks, debugging tools
* **Intelligent Workflow**: Step-by-step problem solving with checkpoints
* **Error Handling**: Robust exception handling and recovery mechanisms

## Environment Configuration

The workbench includes a comprehensive environment template for easy configuration:

```bash
# Copy the template and customize with your values
cp .env.template .env

# Edit .env with your actual API keys and preferences
nano .env
```

The template includes configuration for:

* **Chutes API Key**: Your API key from the Chutes platform
* **Testing Parameters**: Default values for agent testing
* **Docker Configuration**: Sandbox image settings
* **Development Options**: Debug mode, auto-updates, etc.

## Running Tests

### Basic Usage

**For ridges.py test-agent (recommended):**
```bash
# Linux/Mac - Run with ridges.py test-agent
bash scripts/run_agent_test.sh

# Windows - Run with ridges.py test-agent  
scripts\run_ridges_test.bat

# Run with custom parameters
bash scripts/run_agent_test.sh [agent_path] [num_problems] [problem_set] [timeout]
scripts\run_ridges_test.bat [agent_path] [num_problems] [problem_set] [timeout]
```

**For local testing (simulation):**
```bash
# PowerShell wrapper
.\scripts\run_agent_test.ps1

# Windows CMD wrapper  
scripts\run_agent_test.bat
```

### Example Commands

```bash
# Test with defaults (ridges.py test-agent)
bash scripts/run_agent_test.sh
scripts\run_ridges_test.bat

# Test 2 medium problems with 15-minute timeout
bash scripts/run_agent_test.sh miner/top_agent_tmp.py 2 medium 900
scripts\run_ridges_test.bat miner\top_agent_tmp.py 2 medium 900

# Test 5 easy problems with default timeout
bash scripts/run_agent_test.sh miner/top_agent_tmp.py 5 easy 300
scripts\run_ridges_test.bat miner\top_agent_tmp.py 5 easy 300
```

### Parameters

* **agent_path**: Path to agent file (default: `miner/top_agent_tmp.py`)
* **num_problems**: Number of problems to test (default: `1`)
* **problem_set**: Difficulty level - `easy`, `medium`, or `hard` (default: `easy`)
* **timeout**: Timeout per problem in seconds (default: `300`)

## Test Results and Logs

### Where Logs Are Saved

All test results are automatically saved to timestamped directories:

```
runs/
├── 20250922_143052/     # Timestamp: YYYYMMDD_HHMMSS
│   ├── meta.txt         # Test parameters and run metadata
│   ├── git_commit.txt   # Git commit info for reproducibility
│   └── run.log          # Complete test output and results
└── 20250922_150234/     # Another test run
    ├── meta.txt
    ├── git_commit.txt
    └── run.log
```

### Log Contents

* **meta.txt**: Run parameters, timestamp, agent path, problem set details
* **git_commit.txt**: Git commit hash, branch, and repository status for reproducibility
* **run.log**: Complete test execution log including:  
   * Test setup and configuration  
   * Individual problem results  
   * Performance metrics and timing  
   * Error messages and debugging info  
   * Cleanup and summary statistics

### Reading Results

```bash
# List all test runs
ls -la runs/

# View the last 20 lines of a specific test
tail -20 runs/20250922_143052/run.log

# Check test parameters
cat runs/20250922_143052/meta.txt

# Review git commit info for reproducibility
cat runs/20250922_143052/git_commit.txt
```

### Understanding Test Results

**meta.txt** contains:
- Run timestamp and parameters
- Agent path and problem set details
- Timeout and start time information

**git_commit.txt** contains:
- Git commit hash for reproducibility
- Branch and status information
- Recent commit history

**run.log** contains:
- Complete test execution log
- Problem processing details
- Performance metrics and timing
- Error messages and debugging info
- Final results and summary

## Quick Start Guide

### For New Users (Getting Open Top Agents)

1. **Setup Prerequisites**: Install Python 3.11+, Docker, and Git
2. **Get Chutes API Key**: Sign up at chutes.com and generate an API key
3. **Configure Environment**: Copy `env.template` to `.env` and add your API key
4. **Find Open Agent**: Browse the Explore section for top-performing agents
5. **Download Agent**: Copy agent code to `ridges/miner/top_agent_tmp.py`
6. **Run Tests**: Execute `bash scripts/run_agent_test.sh` to benchmark
7. **Review Results**: Check `runs/<timestamp>/` for detailed logs

### For Existing Users (Current Top Miner)

1. **✅ Top Miner**: Advanced 3,922-line top miner code already integrated
2. **Test**: Run `bash scripts/run_agent_test.sh` with desired parameters
3. **Review**: Check timestamped results in `runs/` directory
4. **Compare**: Use logs to compare different agents or parameter configurations
5. **Reproduce**: Git commit tracking ensures tests can be reproduced exactly

## Workflow Summary

1. **Setup**: Ensure prerequisites are installed and configured
2. **Get Agent**: Download open top agent from Explore section OR use existing top miner
3. **Test**: Run `bash scripts/run_agent_test.sh` with desired parameters
4. **Review**: Check timestamped results in `runs/` directory
5. **Compare**: Use logs to compare different agents or parameter configurations
6. **Reproduce**: Git commit tracking ensures tests can be reproduced exactly

## Important Notes

### Benchmarking Purpose Only

**This workbench is designed for processing and benchmarking agents only, not for agent improvement or development.**

* Use this system to evaluate and compare different open top agents
* Measure performance across different problem sets and configurations
* Generate reproducible benchmark results for analysis
* Track agent performance over time with consistent testing

### Not for Agent Development

* Do not use this workbench for modifying or improving agent code
* Agent development should be done in dedicated development environments
* This system focuses on evaluation and comparison of existing agents
* Use the Explore section to find and download top-performing agents
* Focus on benchmarking and performance analysis, not code modification

### Data and Privacy

* Test results remain local to your system
* No agent code or results are shared externally without explicit action
* Git tracking ensures full reproducibility of benchmark results
* Logs contain detailed execution information for thorough analysis

## Troubleshooting

### Common Issues

**"Agent file not found"**

* Ensure agent file exists at the specified path
* Check that the path is relative to the ridges directory

**"Docker not running"**

* Start Docker Desktop or Docker service
* Verify Docker permissions for your user

**"Python command not found"**

* Ensure virtual environment is activated
* Check that Python 3.11+ is installed and accessible

**Test hangs at proxy startup**

* Check network connectivity to Chutes backend
* Verify API key is correctly configured in `ridges/proxy/.env`
* Ensure no firewall blocking required connections

### Getting Help

If you encounter issues:

1. Check the complete logs in `runs/[timestamp]/run.log`
2. Verify all prerequisites are properly installed
3. Ensure the ridges repository is properly set up (see Ridges Repository Setup below)
4. Confirm your Chutes API key is valid and correctly configured

## Ridges Repository Setup

### Current Status
**⚠️ Partial Setup**: Currently only have `ridges/miner/` directory with top miner code
**❌ Missing Components**: Need full ridges repository with `ridges.py`, `proxy/`, and other components

### Required Setup Steps

1. **Clone Full Ridges Repository**:
   ```bash
   # Remove current partial ridges directory
   rm -rf ridges/
   
   # Clone the complete ridges repository
   git clone https://github.com/ridgesai/ridges.git ridges/
   ```

2. **Set Up Proxy Configuration**:
   ```bash
   # Navigate to ridges directory
   cd ridges/
   
   # Set up proxy configuration
   cp proxy/.env.template proxy/.env
   # Edit proxy/.env with your Chutes API key
   ```

3. **Verify Complete Setup**:
   ```bash
   # Check for required files
   ls -la ridges/ridges.py
   ls -la ridges/proxy/.env
   ls -la ridges/miner/
   ```

### Expected Directory Structure
```
ridges/
├── ridges.py              # Main ridges script
├── proxy/                 # Proxy configuration
│   └── .env              # Chutes API configuration
├── miner/                # Agent code
│   ├── custom_agent.py   # Your top miner (3,922 lines)
│   └── top_agent_tmp.py  # Copy for testing
└── ...                   # Other ridges components
```

## Version History

* **v0.1.0**: Initial release with automated testing wrapper and comprehensive logging

## Agent Source

**Agent Used**: Advanced Top Miner Agent  
**Source**: Production-ready 3,922-line implementation  
**Location**: `ridges/miner/custom_agent.py` (also available as `ridges/miner/top_agent_tmp.py`)  
**Function**: `agent_main(input_dict)` returning `{"patch": "..."}`  
**Features**: Multi-language support, advanced tooling, intelligent problem-solving

## About

Local testing environment for Ridges agents with Chutes integration and top miner code.

