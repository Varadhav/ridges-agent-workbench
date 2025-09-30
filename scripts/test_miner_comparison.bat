@echo off
REM Multi-Miner Comparison Testing Script for Windows
REM Usage: test_miner_comparison.bat [miner1] [miner2] [num_problems] [problem_set] [timeout]

setlocal enabledelayedexpansion

REM Default parameters
set DEFAULT_MINER1=ridges\miner\custom_agent.py
set DEFAULT_MINER2=ridges\miner\top_miner_v2.py
set DEFAULT_NUM_PROBLEMS=1
set DEFAULT_PROBLEM_SET=easy
set DEFAULT_TIMEOUT=300

REM Parse command line arguments
set MINER1=%1
if "%MINER1%"=="" set MINER1=%DEFAULT_MINER1%

set MINER2=%2
if "%MINER2%"=="" set MINER2=%DEFAULT_MINER2%

set NUM_PROBLEMS=%3
if "%NUM_PROBLEMS%"=="" set NUM_PROBLEMS=%DEFAULT_NUM_PROBLEMS%

set PROBLEM_SET=%4
if "%PROBLEM_SET%"=="" set PROBLEM_SET=%DEFAULT_PROBLEM_SET%

set TIMEOUT=%5
if "%TIMEOUT%"=="" set TIMEOUT=%DEFAULT_TIMEOUT%

REM Create timestamp for this comparison run
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "TIMESTAMP=%dt:~0,8%_%dt:~8,6%"
set "COMPARISON_DIR=runs\comparison_%TIMESTAMP%"

REM Create comparison directory
if not exist "%COMPARISON_DIR%" mkdir "%COMPARISON_DIR%"

echo ==========================================
echo Multi-Miner Comparison Testing
echo ==========================================
echo Timestamp: %TIMESTAMP%
echo Miner 1: %MINER1%
echo Miner 2: %MINER2%
echo Problems: %NUM_PROBLEMS% %PROBLEM_SET%
echo Timeout: %TIMEOUT%s
echo Comparison Dir: %COMPARISON_DIR%
echo ==========================================

REM Test Miner 1
echo.
echo --- Testing Miner 1: %MINER1% ---
set "MINER1_DIR=%COMPARISON_DIR%\miner1_%MINER1:~-20,-3%"
if not exist "%MINER1_DIR%" mkdir "%MINER1_DIR%"

echo Running: bash scripts\run_agent_test.sh %MINER1% %NUM_PROBLEMS% %PROBLEM_SET% %TIMEOUT%
bash scripts\run_agent_test.sh %MINER1% %NUM_PROBLEMS% %PROBLEM_SET% %TIMEOUT% > "%MINER1_DIR%\test_output.log" 2>&1

REM Copy results to comparison directory
for /f "delims=" %%i in ('dir /b /ad /od runs') do set "LATEST_RUN=%%i"
if exist "runs\%LATEST_RUN%" (
    xcopy "runs\%LATEST_RUN%\*" "%MINER1_DIR%\" /E /I /Y >nul
    echo Miner 1 results saved to: %MINER1_DIR%
) else (
    echo Warning: Could not find latest run results for Miner 1
)

REM Test Miner 2
echo.
echo --- Testing Miner 2: %MINER2% ---
set "MINER2_DIR=%COMPARISON_DIR%\miner2_%MINER2:~-20,-3%"
if not exist "%MINER2_DIR%" mkdir "%MINER2_DIR%"

echo Running: bash scripts\run_agent_test.sh %MINER2% %NUM_PROBLEMS% %PROBLEM_SET% %TIMEOUT%
bash scripts\run_agent_test.sh %MINER2% %NUM_PROBLEMS% %PROBLEM_SET% %TIMEOUT% > "%MINER2_DIR%\test_output.log" 2>&1

REM Copy results to comparison directory
for /f "delims=" %%i in ('dir /b /ad /od runs') do set "LATEST_RUN=%%i"
if exist "runs\%LATEST_RUN%" (
    xcopy "runs\%LATEST_RUN%\*" "%MINER2_DIR%\" /E /I /Y >nul
    echo Miner 2 results saved to: %MINER2_DIR%
) else (
    echo Warning: Could not find latest run results for Miner 2
)

REM Create comparison summary
echo.
echo --- Creating Comparison Summary ---
(
echo # Miner Comparison Report
echo.
echo **Timestamp**: %TIMESTAMP%
echo **Problem Set**: %NUM_PROBLEMS% %PROBLEM_SET% problems
echo **Timeout**: %TIMEOUT%s
echo.
echo ## Tested Miners
echo.
echo ### Miner 1: %MINER1%
echo - **Results Directory**: %MINER1_DIR%
echo - **Log File**: %MINER1_DIR%\run.log
echo - **Metadata**: %MINER1_DIR%\meta.txt
echo.
echo ### Miner 2: %MINER2%
echo - **Results Directory**: %MINER2_DIR%
echo - **Log File**: %MINER2_DIR%\run.log
echo - **Metadata**: %MINER2_DIR%\meta.txt
echo.
echo ## Quick Comparison
echo.
echo ```bash
echo # View Miner 1 results
echo type %MINER1_DIR%\run.log
echo.
echo # View Miner 2 results  
echo type %MINER2_DIR%\run.log
echo.
echo # Compare performance
echo echo === Miner 1 Summary ===
echo more +0 %MINER1_DIR%\run.log
echo.
echo echo === Miner 2 Summary ===
echo more +0 %MINER2_DIR%\run.log
echo ```
echo.
echo ## Files Structure
echo.
echo ```
echo %COMPARISON_DIR%\
echo ├── miner1_%MINER1:~-20,-3%\
echo │   ├── run.log
echo │   ├── meta.txt
echo │   └── git_commit.txt
echo ├── miner2_%MINER2:~-20,-3%\
echo │   ├── run.log
echo │   ├── meta.txt
echo │   └── git_commit.txt
echo └── comparison_summary.md
echo ```
) > "%COMPARISON_DIR%\comparison_summary.md"

echo.
echo ==========================================
echo Comparison Complete!
echo ==========================================
echo Results saved to: %COMPARISON_DIR%
echo Summary: %COMPARISON_DIR%\comparison_summary.md
echo.
echo To view results:
echo   type "%COMPARISON_DIR%\comparison_summary.md"
echo   type "%COMPARISON_DIR%\miner1_%MINER1:~-20,-3%\run.log"
echo   type "%COMPARISON_DIR%\miner2_%MINER2:~-20,-3%\run.log"
echo ==========================================
pause
