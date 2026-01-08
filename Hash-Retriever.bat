@echo off
setlocal enabledelayedexpansion
title Hash Retriever
color 0b
mode con: cols=150 lines=35

:: Initial display
cls
echo Made by Captain Chicky 2026
echo ===============================================================================
echo Welcome to the Hash Retriever!
echo This script supports CertUtil and PowerShell .NET hash algorithms.
echo ===============================================================================
echo.

:Start
:: Clear all variables for fresh start
set "FP="
set "choice="
set "choice2="
set "ALGO="
set "METHOD="
set "MACKEY="
set "keychoice="
set "again="

call :GetFilePath
call :GetAlgorithm
call :RetrieveHash
call :AskRepeat

endlocal
exit /b

:: ============================================================================
:: GET FILE PATH
:: ============================================================================
:GetFilePath
set "FP="
set /p "FP=Enter file path: "
set "FP=%FP:"=%"

if not exist "%FP%" (
    echo.
    echo ERROR: File does not exist. Please try again.
    echo.
    goto :GetFilePath
)

echo.
echo You have entered: %FP%
echo.
set /p "choice=Is this correct? (Y/N): "
if /i not "%choice%"=="Y" (
    echo.
    echo Please retype the file path...
    echo.
    goto :GetFilePath
)
exit /b

:: ============================================================================
:: GET ALGORITHM
:: ============================================================================
:GetAlgorithm
echo.
echo ===============================================================================
echo Choose hash algorithm:
echo   [1] MD2           [2] MD4           [3] MD5
echo   [4] SHA1          [5] SHA256        [6] SHA384
echo   [7] SHA512        [8] RIPEMD160     [9] MACTripleDES (requires key)
echo ===============================================================================
set "choice2="
set /p "choice2=Enter number (1-9): "

:: Validate input is a single digit 1-9
if not defined choice2 goto :InvalidAlgorithm
if "%choice2%" lss "1" goto :InvalidAlgorithm
if "%choice2%" gtr "9" goto :InvalidAlgorithm

:: Map to algorithm and method
if "%choice2%"=="1" set "ALGO=MD2" & set "METHOD=certutil"
if "%choice2%"=="2" set "ALGO=MD4" & set "METHOD=certutil"
if "%choice2%"=="3" set "ALGO=MD5" & set "METHOD=certutil"
if "%choice2%"=="4" set "ALGO=SHA1" & set "METHOD=certutil"
if "%choice2%"=="5" set "ALGO=SHA256" & set "METHOD=certutil"
if "%choice2%"=="6" set "ALGO=SHA384" & set "METHOD=certutil"
if "%choice2%"=="7" set "ALGO=SHA512" & set "METHOD=certutil"
if "%choice2%"=="8" set "ALGO=RIPEMD160" & set "METHOD=powershell"
if "%choice2%"=="9" set "ALGO=MACTripleDES" & set "METHOD=powershell-mac"

:: Get MAC key if needed
if "%METHOD%"=="powershell-mac" (
    call :GetMACKey
)

exit /b 0

:InvalidAlgorithm
echo.
echo ERROR: Invalid choice. Please enter a number between 1 and 9.
echo.
goto :GetAlgorithm

:: ============================================================================
:: GET MAC KEY (for MACTripleDES)
:: ============================================================================
:GetMACKey
echo.
echo ===============================================================================
echo MACTripleDES requires a cryptographic key.
echo Enter key in hex format (16 or 24 bytes = 32 or 48 hex characters)
echo Example: A3E8B7C2F1D4968E5A7C3B9F2E1D6840
echo NOTE: Avoid sequential patterns like 0123456789ABCDEF (weak keys)
echo ===============================================================================
echo.

:PromptKey
set "MACKEY="
set /p "MACKEY=Enter key (or press Enter for default): "

:: Use default if empty
if not defined MACKEY (
    set "MACKEY=A3E8B7C2F1D4968E5A7C3B9F2E1D6840"
    echo.
    echo Using default secure key.
    goto :ValidateKeyComplete
)

:: Check length first
call :GetStringLength "%MACKEY%" keylen

if "%keylen%"=="32" goto :LengthOK
if "%keylen%"=="48" goto :LengthOK

echo.
echo ERROR: Key must be exactly 32 or 48 hex characters (16 or 24 bytes).
echo You entered %keylen% characters.
echo Please try again...
echo.
goto :PromptKey

:LengthOK
:: Validate hex characters - exit immediately on bad char
set "teststr=%MACKEY%"

:HexCheckLoop
if not defined teststr goto :ValidateKeyComplete
set "char=%teststr:~0,1%"
set "teststr=%teststr:~1%"

:: Check if valid hex char
if "%char%"=="0" goto :HexCheckLoop
if "%char%"=="1" goto :HexCheckLoop
if "%char%"=="2" goto :HexCheckLoop
if "%char%"=="3" goto :HexCheckLoop
if "%char%"=="4" goto :HexCheckLoop
if "%char%"=="5" goto :HexCheckLoop
if "%char%"=="6" goto :HexCheckLoop
if "%char%"=="7" goto :HexCheckLoop
if "%char%"=="8" goto :HexCheckLoop
if "%char%"=="9" goto :HexCheckLoop
if /i "%char%"=="A" goto :HexCheckLoop
if /i "%char%"=="B" goto :HexCheckLoop
if /i "%char%"=="C" goto :HexCheckLoop
if /i "%char%"=="D" goto :HexCheckLoop
if /i "%char%"=="E" goto :HexCheckLoop
if /i "%char%"=="F" goto :HexCheckLoop

:: If we get here, it's a bad character - reprompt immediately
echo.
echo ERROR: Key must contain only hex characters (0-9, A-F).
echo Invalid character found: %char%
echo Please try again...
echo.
goto :PromptKey

:ValidateKeyComplete
:: Confirm key
echo.
echo You have entered key: %MACKEY%
echo Length: %keylen% hex characters
echo.
set "keychoice="
set /p "keychoice=Is this correct? (Y/N): "

if /i not "%keychoice%"=="Y" (
    echo.
    echo Please re-enter the key...
    echo.
    goto :PromptKey
)

echo.
echo Key validated successfully!
exit /b 0

:: ============================================================================
:: GET STRING LENGTH HELPER
:: ============================================================================
:GetStringLength
setlocal enabledelayedexpansion
set "str=%~1"
set "len=0"
:LenLoop
if defined str (
    set "str=!str:~1!"
    set /a len+=1
    goto :LenLoop
)
endlocal & set "%~2=%len%"
exit /b

:: ============================================================================
:: RETRIEVE HASH
:: ============================================================================
:RetrieveHash
echo.
echo ===============================================================================
echo Computing %ALGO% hash...
echo ===============================================================================
echo.

if "%METHOD%"=="certutil" (
    :: CertUtil method for MD2, MD4, MD5, SHA1, SHA256, SHA384, SHA512
    certutil -hashfile "%FP%" %ALGO% 2>nul
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to compute hash with CertUtil.
        echo This could be due to file access issues or unsupported algorithm.
        echo.
        pause
        exit /b 1
    )
    
) else if "%METHOD%"=="powershell" (
    :: PowerShell .NET method for RIPEMD160
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "try { " ^
        "    $ErrorActionPreference = 'Stop'; " ^
        "    $file = '%FP%'; " ^
        "    $stream = [System.IO.File]::OpenRead($file); " ^
        "    $hasher = [System.Security.Cryptography.RIPEMD160]::Create(); " ^
        "    $hash = $hasher.ComputeHash($stream); " ^
        "    $stream.Close(); " ^
        "    $hashString = [System.BitConverter]::ToString($hash) -replace '-',''; " ^
        "    Write-Host 'RIPEMD160 hash of file:'; " ^
        "    Write-Host $file; " ^
        "    Write-Host $hashString; " ^
        "    exit 0; " ^
        "} catch { " ^
        "    Write-Host 'ERROR: Failed to compute hash'; " ^
        "    Write-Host $_.Exception.Message; " ^
        "    exit 1; " ^
        "}"
    
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to compute hash with PowerShell.
        echo Please check if the file is accessible and not locked.
        echo.
        pause
        exit /b 1
    )
    
) else if "%METHOD%"=="powershell-mac" (
    :: PowerShell .NET method for MACTripleDES with key
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
        "try { " ^
        "    $ErrorActionPreference = 'Stop'; " ^
        "    $file = '%FP%'; " ^
        "    $keyHex = '%MACKEY%'; " ^
        "    $keyBytes = New-Object byte[] ($keyHex.Length / 2); " ^
        "    for ($i = 0; $i -lt $keyHex.Length; $i += 2) { " ^
        "        $keyBytes[$i / 2] = [Convert]::ToByte($keyHex.Substring($i, 2), 16); " ^
        "    } " ^
        "    if ($keyBytes.Length -ne 16 -and $keyBytes.Length -ne 24) { " ^
        "        throw 'Key must be 16 or 24 bytes (32 or 48 hex characters)'; " ^
        "    } " ^
        "    $stream = [System.IO.File]::OpenRead($file); " ^
        "    $mac = New-Object System.Security.Cryptography.MACTripleDES; " ^
        "    $mac.Key = $keyBytes; " ^
        "    $hash = $mac.ComputeHash($stream); " ^
        "    $stream.Close(); " ^
        "    $mac.Dispose(); " ^
        "    $hashString = [System.BitConverter]::ToString($hash) -replace '-',''; " ^
        "    Write-Host ''; " ^
        "    Write-Host 'MACTripleDES of file:'; " ^
        "    Write-Host $file; " ^
        "    Write-Host 'MAC: ' $hashString; " ^
        "    Write-Host 'Key: ' $keyHex; " ^
        "    exit 0; " ^
        "} catch { " ^
        "    Write-Host ''; " ^
        "    Write-Host 'ERROR: Failed to compute MAC'; " ^
        "    if ($_.Exception.Message -match 'weak key') { " ^
        "        Write-Host 'The specified key is a known weak key for TripleDES.'; " ^
        "        Write-Host 'This should have been caught during validation.'; " ^
        "    } else { " ^
        "        Write-Host $_.Exception.Message; " ^
        "    } " ^
        "    exit 1; " ^
        "}"
    
    if errorlevel 1 (
        echo.
        echo ERROR: Failed to compute MAC with PowerShell.
        echo If this is a weak key error, please try a different key.
        echo.
        pause
        exit /b 1
    )
)

echo.
echo ===============================================================================
echo Hash computation complete!
echo ===============================================================================
exit /b 0

:: ============================================================================
:: ASK TO REPEAT
:: ============================================================================
:AskRepeat
echo.
set "again="
set /p "again=Calculate another hash? (Y/N): "
if /i "%again%"=="Y" (
    cls
    echo Made by Captain Chicky 2026
    echo ===============================================================================
    echo.
    goto :Start
)

echo.
echo Done. Thank you for using this script.
echo.
pause
exit /b