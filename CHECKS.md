# Quick Sanity Checklist

This document provides a quick checklist to verify that your Ridges Agent Workbench is properly set up and functioning correctly.

## Prerequisites Check

### 1. Python Environment
```bash
# Check Python version (should be 3.11+)
python --version
# Expected: Python 3.11.x or higher
```

### 2. Docker Status
```bash
# Check if Docker is running
docker info
# Expected: Docker system information without errors
```

### 3. Git Repository
```bash
# Check git status
git status
# Expected: Clean working tree or list of modified files
```

## Ridges Repository Check

### 4. Ridges.py Help Command
```bash
# Navigate to ridges directory and check help
cd ridges
./ridges.py --help
# Expected: Help output showing available commands and options
```

**Alternative if ridges.py not found:**
```bash
# Check if ridges.py exists
ls -la ridges.py
# Expected: File exists and is executable
```

## Environment Configuration Check

### 5. Chutes API Key Configuration
```bash
# Check if .env file exists
ls -la .env
# Expected: .env file exists

# Check if Chutes API key is configured
grep "CHUTES_API_KEY" .env
# Expected: CHUTES_API_KEY=your_actual_api_key_here
```

**Alternative check:**
```bash
# Check ridges proxy configuration
ls -la ridges/proxy/.env
# Expected: ridges/proxy/.env file exists with API key
```

## Agent Code Check

### 6. Agent Main Function Exists
```bash
# Check if agent file exists
ls -la ridges/miner/top_agent_tmp.py
# Expected: File exists and is readable

# Check for agent_main function
grep -n "def agent_main" ridges/miner/top_agent_tmp.py
# Expected: Line number and function definition
```

### 7. Agent Returns Patch Format
```bash
# Check return format in agent code
grep -A 5 -B 5 "return.*patch" ridges/miner/top_agent_tmp.py
# Expected: Return statement with {"patch": "..."} format
```

**Alternative check:**
```bash
# Check for proper return format
grep -n "return.*{" ridges/miner/top_agent_tmp.py
# Expected: Return statement with dictionary format
```

## Test Execution Check

### 8. Wrapper Script Execution
```bash
# Test wrapper script with dry run
bash scripts/run_agent_test.sh --help 2>/dev/null || echo "Script exists and is executable"
# Expected: Script runs without errors
```

### 9. Test Run Execution
```bash
# Run a quick test
bash scripts/run_agent_test.sh ridges/miner/top_agent_tmp.py 1 easy 60
# Expected: Test completes successfully with timestamped results
```

## Results Verification Check

### 10. Test Results Directory
```bash
# Check if runs directory exists and has recent results
ls -la runs/
# Expected: Directory exists with timestamped subdirectories
```

### 11. Log Files Structure
```bash
# Check latest run directory
LATEST_RUN=$(ls -t runs/ | head -1)
echo "Latest run: $LATEST_RUN"

# Check required files exist
ls -la runs/$LATEST_RUN/
# Expected: meta.txt, git_commit.txt, run.log files exist
```

### 12. Run Log Summary
```bash
# Check if run.log ends with summary
tail -10 runs/$LATEST_RUN/run.log
# Expected: Log ends with "Test completed successfully!" or similar summary
```

## Quick Health Check Script

Save this as `quick_check.sh` and run it for automated verification:

```bash
#!/bin/bash
echo "=== Ridges Agent Workbench Health Check ==="

# Check Python
echo "1. Python version:"
python --version

# Check Docker
echo "2. Docker status:"
docker info >/dev/null 2>&1 && echo "✅ Docker running" || echo "❌ Docker not running"

# Check Git
echo "3. Git status:"
git status --porcelain | wc -l | xargs echo "Modified files:"

# Check .env
echo "4. Environment file:"
[ -f .env ] && echo "✅ .env exists" || echo "❌ .env missing"

# Check agent file
echo "5. Agent file:"
[ -f ridges/miner/top_agent_tmp.py ] && echo "✅ Agent file exists" || echo "❌ Agent file missing"

# Check agent_main function
echo "6. Agent main function:"
grep -q "def agent_main" ridges/miner/top_agent_tmp.py && echo "✅ agent_main found" || echo "❌ agent_main missing"

# Check return format
echo "7. Return format:"
grep -q "return.*patch" ridges/miner/top_agent_tmp.py && echo "✅ Patch return found" || echo "❌ Patch return missing"

# Check recent runs
echo "8. Recent test runs:"
ls -la runs/ | tail -5

echo "=== Health Check Complete ==="
```

## Troubleshooting Common Issues

### Issue: "ridges.py not found"
**Solution**: Ensure you have the full ridges repository cloned
```bash
# Check if ridges directory has required files
ls -la ridges/
# Should contain: ridges.py, proxy/, miner/, etc.
```

### Issue: "Docker not running"
**Solution**: Start Docker Desktop or Docker service
```bash
# On Windows
# Start Docker Desktop application

# On Linux/Mac
sudo systemctl start docker
```

### Issue: "Agent file not found"
**Solution**: Ensure agent file exists at correct path
```bash
# Check current agent file
ls -la ridges/miner/top_agent_tmp.py

# If missing, copy from custom_agent.py
cp ridges/miner/custom_agent.py ridges/miner/top_agent_tmp.py
```

### Issue: "No test results"
**Solution**: Run a test to generate results
```bash
# Run a quick test
bash scripts/run_agent_test.sh
```

## Success Criteria

✅ **All checks pass** - Workbench is ready for use
❌ **Any check fails** - Address the specific issue before proceeding

## Next Steps

Once all checks pass:
1. **Run comprehensive tests** with your top miner
2. **Compare results** across different problem sets
3. **Analyze performance** using the generated logs
4. **Share results** with the community

---

**Note**: This checklist ensures your workbench is properly configured for reproducible agent testing and benchmarking.
