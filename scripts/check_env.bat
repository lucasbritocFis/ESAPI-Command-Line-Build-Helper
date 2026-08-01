@echo off
setlocal enabledelayedexpansion
echo ================================================================
echo   ESAPI Environment Checker
echo ================================================================
echo.

REM --- 1. C# compiler -------------------------------------------------------
set "CSC_PATH=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
if exist "%CSC_PATH%" (
    echo [OK] Compiler found:
    echo      "%CSC_PATH%"
) else (
    echo [ERROR] csc.exe not found.
    echo         Make sure the 64-bit .NET Framework 4.x is installed.
)
echo.

REM --- 2. ESAPI assemblies --------------------------------------------------
set "ESAPI_FOUND="
echo Searching for ESAPI in common Varian RTM locations...
echo.

for %%P in (
    "C:\Program Files (x86)\Varian\RTM"
    "C:\Program Files\Varian\RTM"
    "C:\Varian\RTM"
) do (
    if not defined ESAPI_FOUND (
        if exist "%%~P" (
            for /d %%D in ("%%~P\*") do (
                if not defined ESAPI_FOUND (
                    if exist "%%~D\esapi\API\VMS.TPS.Common.Model.API.dll" (
                        set "ESAPI_FOUND=%%~D\esapi\API"
                    )
                )
            )
        )
    )
)

if defined ESAPI_FOUND (
    echo [FOUND] "!ESAPI_FOUND!"
    echo.
    echo ================================================================
    echo   Copy this line into scripts\build.bat:
    echo ================================================================
    echo.
    echo   set "ESAPI_DIR=!ESAPI_FOUND!"
) else (
    echo [WARNING] VMS.TPS.Common.Model.API.dll was not found.
    echo           Locate it manually and set ESAPI_DIR in scripts\build.bat.
)

echo.
echo ================================================================
pause
endlocal
