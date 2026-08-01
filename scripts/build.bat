@echo off
setlocal
REM ==========================================================================
REM  build.bat - Compiles a single-file ESAPI script without Visual Studio.
REM
REM  Usage (from anywhere):
REM    scripts\build.bat                 -> compiles the bundled example
REM    scripts\build.bat MyScript.cs     -> compiles your own .cs file
REM ==========================================================================

REM --- Always work from the repository root, regardless of where we are called
pushd "%~dp0.."

REM --- EDIT THIS LINE if check_env.bat reports a different path --------------
set "ESAPI_DIR=C:\Program Files (x86)\Varian\RTM\16.1\esapi\API"

set "CSC=C:\Windows\Microsoft.NET\Framework64\v4.0.30319\csc.exe"
set "API=%ESAPI_DIR%\VMS.TPS.Common.Model.API.dll"
set "TYPES=%ESAPI_DIR%\VMS.TPS.Common.Model.Types.dll"

if "%~1"=="" (
    set "SRC=examples\HelloEsapi.cs"
    set "OUT=HelloEsapi.esapi.dll"
) else (
    set "SRC=%~1"
    set "OUT=%~n1.esapi.dll"
)

REM --- PRE-BUILD CHECKS -----------------------------------------------------
REM  Paths are quoted in the messages below on purpose: an unquoted path
REM  containing "(x86)" breaks the parenthesised block in cmd.exe.
if not exist "%CSC%" (
    echo ERROR: csc.exe not found at:
    echo   "%CSC%"
    echo Make sure the 64-bit .NET Framework 4.x is installed.
    goto :fail
)
if not exist "%API%" (
    echo ERROR: VMS.TPS.Common.Model.API.dll not found at:
    echo   "%API%"
    echo Run scripts\check_env.bat and update ESAPI_DIR in this file.
    goto :fail
)
if not exist "%TYPES%" (
    echo ERROR: VMS.TPS.Common.Model.Types.dll not found at:
    echo   "%TYPES%"
    echo Run scripts\check_env.bat and update ESAPI_DIR in this file.
    goto :fail
)
if not exist "%SRC%" (
    echo ERROR: source file not found:
    echo   "%SRC%"
    echo Place your .cs file in the repository root and run:
    echo   scripts\build.bat YourFile.cs
    goto :fail
)

REM --- Delete any previous DLL so a failed build cannot leave a stale one ----
if exist "%OUT%" del "%OUT%"

echo Compiling "%SRC%" to "%OUT%" ...
echo.

REM --- COMPILATION ----------------------------------------------------------
REM  Note: this is the .NET Framework compiler (C# 5). Language features
REM  introduced in C# 6 or later - string interpolation, nameof,
REM  expression-bodied members - are not supported here.
"%CSC%" /nologo /target:library /platform:x64 /optimize+ /out:"%OUT%" ^
        /reference:"%API%" /reference:"%TYPES%" ^
        /reference:System.Windows.Forms.dll /reference:System.Drawing.dll ^
        "%SRC%"

if errorlevel 1 goto :buildfailed
if not exist "%OUT%" goto :buildfailed

echo.
echo SUCCESS: "%OUT%" generated.
echo Register it in Eclipse under Scripts ^> Administer Scripts.
echo.
echo A successful build only means the compiler produced a DLL.
echo Loading, behaviour and clinical safety still have to be verified locally.
goto :done

:buildfailed
echo.
echo BUILD FAILED. Review the C# error messages above.
echo No DLL was produced; the previous one was deleted on purpose.
goto :done

:fail
echo.

:done
echo.
popd
pause
endlocal
