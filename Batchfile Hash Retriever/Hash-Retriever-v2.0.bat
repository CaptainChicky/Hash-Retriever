:: I've gotten better batchfile habits so I'm going to rewrite this lol
@echo off
setlocal

title Hash Retriever
color 0b
mode 1000
cls

echo Made by Captain Chicky 2023.
echo =======================================================================================
echo =======================================================================================
echo Welcome to the hash retriever!
echo This script is a utility script written for the user to have an easier time checking hashes with the Command Prompt.
echo To begin, please type in the file path of the file you want the hash of...
echo.

call :GetFilePath
call :GetAlgorithm
call :RetrieveHash

echo.
echo Done! Thank you for using this script! :D
pause
endlocal
exit

:GetFilePath
set /p "FP=File path: "

:: Validate file path input
if not exist "%FP%" (
    echo.
    echo The file does not exist. Please retype the file path...
    goto :GetFilePath
)

echo.
echo You have entered:
echo %FP%
echo.

set /p "choice=Y or N?... "

:: Validate choice input
if /i "%choice%" neq "Y" (
    echo.
    echo Please retype the file path...
    goto :GetFilePath
)

exit /b

:GetAlgorithm
echo.
echo =======================================================================================
echo =======================================================================================
echo Now, please choose the algorithm you want to get the hash from...
echo 1^) MD2
echo 2^) MD4
echo 3^) MD5
echo 4^) SHA1
echo 5^) SHA256
echo 6^) SHA384
echo 7^) SHA512

set /p "choice2=Enter a number matching the corresponding selection: "

:: Validate algorithm choice input
if not "%choice2%" equ "1" if not "%choice2%" equ "2" if not "%choice2%" equ "3" if not "%choice2%" equ "4" if not "%choice2%" equ "5" if not "%choice2%" equ "6" if not "%choice2%" equ "7" (
    echo.
    echo Your input is not one of the choices. Please try again...
    goto :GetAlgorithm
)

:: Set the algorithm
if "%choice2%" equ "1" ( 
    set "choice2=MD2" 
) else if "%choice2%" equ "2" ( 
    set "choice2=MD4" 
) else if "%choice2%" equ "3" ( 
    set "choice2=MD5" 
) else if "%choice2%" equ "4" ( 
    set "choice2=SHA1" 
) else if "%choice2%" equ "5" ( 
    set "choice2=SHA256" 
) else if "%choice2%" equ "6" ( 
    set "choice2=SHA384" 
) else if "%choice2%" equ "7" ( 
    set "choice2=SHA512" 
)

exit /b

:RetrieveHash
echo.
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.

certutil -hashfile "%FP%" %choice2%

exit /b