@echo off
setlocal EnableExtensions

rem ============================================================
rem Build and publish Media Player Redux to the Steam Workshop.
rem ============================================================

rem Run from the directory containing this script, regardless of
rem the directory the caller launched it from.
pushd "%~dp0" || (
    echo ERROR: Could not enter the publishing directory.
    exit /b 1
)
set "publish_path=%CD%"

rem Adjust this path if Garry's Mod is installed elsewhere.
set "gmod_bin=D:\SteamLibrary\common\GarrysMod\bin"
set "gmad=%gmod_bin%\gmad.exe"
set "gmpublish=%gmod_bin%\gmpublish.exe"

set "publish_gma=workshop.gma"
set "publish_id=3001397905"
set "result=1"

rem Check required tools before building the package.
if not exist "%gmad%" (
    echo ERROR: gmad.exe was not found: "%gmad%"
    goto :cleanup
)
if not exist "%gmpublish%" (
    echo ERROR: gmpublish.exe was not found: "%gmpublish%"
    goto :cleanup
)

echo Building "%publish_gma%"...
"%gmad%" create -folder "%publish_path%" -out "%publish_gma%"
if errorlevel 1 (
    echo ERROR: gmad failed to build the addon.
    goto :cleanup
)
if not exist "%publish_gma%" (
    echo ERROR: gmad did not create "%publish_gma%".
    goto :cleanup
)

echo.
echo Uploading addon to Steam Workshop...
"%gmpublish%" update -addon "%publish_gma%" -id "%publish_id%"
if errorlevel 1 (
    echo ERROR: Steam Workshop publishing failed.
    goto :cleanup
)

set "result=0"
echo.
echo Publishing completed successfully.

:cleanup
echo.
if exist "%publish_gma%" (
    echo Removing temporary package...
    del "%publish_gma%"
)
popd
if "%result%"=="0" (
    pause
)
exit /b %result%
