#!/usr/bin/env python3
"""
Direct test of the top_miner_v2.py agent code
This bypasses the full ridges infrastructure and tests the agent directly
"""

import sys
import os
import json
from pathlib import Path

# Add the ridges directory to Python path
sys.path.insert(0, str(Path(__file__).parent / "ridges"))

def test_miner_direct():
    """Test the miner code directly"""
    print("=" * 50)
    print("Direct Miner Test")
    print("=" * 50)
    
    try:
        # Import the miner module
        from miner.top_miner_v2 import agent_main
        print("✅ Successfully imported top_miner_v2.py")
        
        # Create a test input
        test_input = {
            "problem_statement": "Fix the bug in the following code: def add(a, b): return a - b",
            "test_cases": [
                {"input": [2, 3], "expected": 5},
                {"input": [0, 0], "expected": 0}
            ],
            "code_context": "def add(a, b): return a - b  # This is wrong"
        }
        
        print("🧪 Running agent with test input...")
        print(f"Input: {json.dumps(test_input, indent=2)}")
        
        # Call the agent
        result = agent_main(test_input, repo_dir="test_repo", test_mode=True)
        
        print("✅ Agent execution completed!")
        print(f"Result type: {type(result)}")
        print(f"Result: {json.dumps(result, indent=2)}")
        
        # Validate result format
        if isinstance(result, dict) and "patch" in result:
            print("✅ Result format is correct (contains 'patch' key)")
        else:
            print("⚠️  Result format may be incorrect (should contain 'patch' key)")
            
        return True
        
    except Exception as e:
        print(f"❌ Error testing miner: {e}")
        import traceback
        traceback.print_exc()
        return False

if __name__ == "__main__":
    success = test_miner_direct()
    if success:
        print("\n🎉 Direct miner test completed successfully!")
    else:
        print("\n💥 Direct miner test failed!")
        sys.exit(1)
