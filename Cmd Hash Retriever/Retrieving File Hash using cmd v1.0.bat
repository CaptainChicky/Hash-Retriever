@echo off
title Hash Retriever
color 0b
mode 1000
cls
goto Start

:Start
echo Made by Captain Chicky 2020.
echo =======================================================================================
echo =======================================================================================
echo Welcome to the hash retriever!
echo This script is a utility script written for the user to have an easier time checking hashes with the Command Prompt.
echo To begin, please type in the file path of the file you want the hash of...
goto Path

:Path
set /p "FP=File path:"
echo. 
echo You have entered...
echo %FP%
echo Is this correct?
set /p "choice=Y or N?..."
if /i "%choice%" == "Y" (
    goto Algorithm
) else if /i "%choice%" == "N" (
    echo.
    echo Please retype the file path...
    goto Path
) else (
	echo Your input is not one of the choices. 
	echo Please try again...
	pause
	goto Path
)

:Algorithm
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
set /p "choice2=Enter a number matching the corresponding selection:"
if /i "%choice2%" == "1" (
    goto 1
) else if /i "%choice2%" == "2" (
    goto 2
) else if /i "%choice2%" == "3" (
    goto 3
) else if /i "%choice2%" == "4" (
    goto 4
) else if /i "%choice2%" == "5" (
    goto 5
) else if /i "%choice2%" == "6" (
    goto 6
) else if /i "%choice2%" == "7" (
    goto 7
) else (
	echo Your input is not one of the choices. 
	echo Please try again...
	pause
	goto Algorithm
)

:1
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% MD2
echo.
echo Done! Thank you for using this script! :D
pause
exit

:2
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% MD4
echo.
echo Done! Thank you for using this script! :D
pause
exit

:3
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% MD5
echo.
echo Done! Thank you for using this script! :D
pause
exit

:4
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% SHA1
echo.
echo Done! Thank you for using this script! :D
pause
exit

:5
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% SHA256
echo.
echo Done! Thank you for using this script! :D
pause
exit

:6
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% SHA384
echo.
echo Done! Thank you for using this script! :D
pause
exit

:7
echo =======================================================================================
echo =======================================================================================
echo Please wait... retrieving file hash...
echo.
certutil -hashfile %FP% SHA512
echo.
echo Done! Thank you for using this script! :D
pause
exit
