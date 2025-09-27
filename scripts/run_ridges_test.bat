@echo off
REM Ridges Agent Test Wrapper for Windows
REM Usage: run_ridges_test.bat [agent_path] [num_problems] [problem_set] [timeout]
REM 
REM This script provides a consistent interface for testing agents with the ridges.py test-agent command
REM and creates timestamped runs with comprehensive logging for reproducibility.

setlocal enabledelayedexpansion

REM Default parameters
set DEFAULT_AGENT_PATH=miner\top_agent_tmp.py
set DEFAULT_NUM_PROBLEMS=1
set DEFAULT_PROBLEM_SET=easy
set DEFAULT_TIMEOUT=300

REM Parse command line arguments
set AGENT_PATH=%1
if "%AGENT_PATH%"=="" set AGENT_PATH=%DEFAULT_AGENT_PATH%

set NUM_PROBLEMS=%2
if "%NUM_PROBLEMS%"=="" set NUM_PROBLEMS=%DEFAULT_NUM_PROBLEMS%

set PROBLEM_SET=%3
if "%PROBLEM_SET%"=="" set PROBLEM_SET=%DEFAULT_PROBLEM_SET%

set TIMEOUT=%4
if "%TIMEOUT%"=="" set TIMEOUT=%DEFAULT_TIMEOUT%

REM Validate problem set
if not "%PROBLEM_SET%"=="easy" if not "%PROBLEM_SET%"=="medium" if not "%PROBLEM_SET%"=="hard" (
    echo Error: Problem set must be 'easy', 'medium', or 'hard'
    echo Usage: %0 [agent_path] [num_problems] [problem_set] [timeout]
    echo   agent_path: Path to agent file (default: %DEFAULT_AGENT_PATH%)
    echo   num_problems: Number of problems to test (default: %DEFAULT_NUM_PROBLEMS%)
    echo   problem_set: Difficulty level (default: %DEFAULT_PROBLEM_SET%)
    echo   timeout: Timeout per problem in seconds (default: %DEFAULT_TIMEOUT%)
    exit /b 1
)

REM Create timestamp for this run
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set "RUN_DIR=runs\%TIMESTAMP%"

REM Create run directory
if not exist "%RUN_DIR%" mkdir "%RUN_DIR%"

echo ==========================================
echo Ridges Agent Test Wrapper
echo ==========================================
echo Timestamp: %TIMESTAMP%
echo Agent Path: %AGENT_PATH%
echo Number of Problems: %NUM_PROBLEMS%
echo Problem Set: %PROBLEM_SET%
echo Timeout: %TIMEOUT%s
echo Run Directory: %RUN_DIR%
echo ==========================================

REM Save run metadata
echo Run Timestamp: %TIMESTAMP% > "%RUN_DIR%\meta.txt"
echo Agent Path: %AGENT_PATH% >> "%RUN_DIR%\meta.txt"
echo Number of Problems: %NUM_PROBLEMS% >> "%RUN_DIR%\meta.txt"
echo Problem Set: %PROBLEM_SET% >> "%RUN_DIR%\meta.txt"
echo Timeout: %TIMEOUT%s >> "%RUN_DIR%\meta.txt"
echo Start Time: %date% %time% >> "%RUN_DIR%\meta.txt"
echo Script Version: 1.0 >> "%RUN_DIR%\meta.txt"

REM Save git commit info for reproducibility (from ridges directory)
echo Saving git commit information from ridges directory...
cd ridges
git rev-parse HEAD > "..\%RUN_DIR%\git_commit.txt" 2>nul || echo Not a git repository > "..\%RUN_DIR%\git_commit.txt"
git branch --show-current >> "..\%RUN_DIR%\git_commit.txt" 2>nul || echo Not a git repository >> "..\%RUN_DIR%\git_commit.txt"
echo Git Status: >> "..\%RUN_DIR%\git_commit.txt"
git status --porcelain >> "..\%RUN_DIR%\git_commit.txt" 2>nul || echo Not a git repository >> "..\%RUN_DIR%\git_commit.txt"
cd ..

REM Check if agent file exists
if not exist "ridges\%AGENT_PATH%" (
    echo Error: Agent file not found at ridges\%AGENT_PATH%
    echo Please ensure your agent file exists at the specified path.
    exit /b 1
)

REM Check if ridges.py exists
if not exist "ridges\ridges.py" (
    echo Error: ridges.py not found in ridges\
    echo Please ensure the ridges repository is properly set up.
    exit /b 1
)

REM Check if Docker is running
docker info >nul 2>&1
if errorlevel 1 (
    echo Error: Docker is not running. Please start Docker and try again.
    exit /b 1
)

REM Check if Python is available
python --version >nul 2>&1
if errorlevel 1 (
    echo Error: Python is not installed or not in PATH
    exit /b 1
)

REM Check if .env file exists in ridges directory
if not exist "ridges\.env" (
    echo Warning: .env file not found in ridges\
    echo Consider setting up environment configuration for Chutes API.
)

REM Run the actual test with ridges.py test-agent
echo Starting ridges.py test-agent...
echo This may take several minutes depending on the problem set and timeout.

REM Log everything to the run directory
(
echo ==========================================
echo Ridges Test Execution Log
echo ==========================================
echo Start Time: %date% %time%
echo.
echo Running ridges.py test-agent with parameters:
echo   Agent: %AGENT_PATH%
echo   Problems: %NUM_PROBLEMS%
echo   Set: %PROBLEM_SET%
echo   Timeout: %TIMEOUT%s
echo.
echo Executing: ridges\ridges.py test-agent --agent-file %AGENT_PATH% --num-problems %NUM_PROBLEMS% --problem-set %PROBLEM_SET% --timeout %TIMEOUT% --verbose
echo.

REM Change to ridges directory for the test
cd ridges

REM Run the actual ridges.py test-agent command
ridges.py test-agent --agent-file "%AGENT_PATH%" --num-problems %NUM_PROBLEMS% --problem-set %PROBLEM_SET% --timeout %TIMEOUT% --verbose

echo.
echo Test completed successfully!
echo End Time: %date% %time%
) > "..\%RUN_DIR%\run.log" 2>&1

REM Return to original directory
cd ..

echo.
echo ==========================================
echo Test Complete!
echo ==========================================
echo Results saved to: %RUN_DIR%
echo Log file: %RUN_DIR%\run.log
echo Metadata: %RUN_DIR%\meta.txt
echo Git info: %RUN_DIR%\git_commit.txt
echo.
echo To view results:
echo   type "%RUN_DIR%\run.log"
echo   type "%RUN_DIR%\meta.txt"
echo.
echo To run another test:
echo   scripts\run_ridges_test.bat [agent_path] [num_problems] [problem_set] [timeout]
echo.

pause
