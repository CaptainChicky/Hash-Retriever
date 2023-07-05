mode 270
Write-Host "Made by Captain Chicky 2023."
Write-Host "======================================================================================="
Write-Host "======================================================================================="
Write-Host "Welcome to the hash retriever!"
Write-Host "This script is a utility script written for the user to have an easier time checking hashes with PowerShell."
Write-Host "To begin, please type in the file path of the file you want the hash of..."

do {
    $path = Read-Host "File path"
    Write-Host ""
    Write-Host "You have entered..."
    Write-Host $path
    Write-Host "Is this correct?"
    $UserInput = Read-Host -Prompt "Y or N?"

    if ($UserInput -eq "N") {
        Write-Host ""
        Write-Host "Please retype the file path..."
    }
    elseif ($UserInput -eq "Y") {
        $fileExists = Test-Path -Path $path -PathType Leaf
        if (-not $fileExists) {
            Write-Host ""
            Write-Host "The file does not exist. Please retype the file path..."
        }
        else {
            break  # Exit the loop when a valid file path is entered
        }
    }
    else {
        Write-Host ""
        Write-Host "Invalid choice. Let's try again."
    }

} while ($true)


Write-Host ""
Write-Host "======================================================================================="
Write-Host "======================================================================================="

while ($true) {
    $var = Read-Host -Prompt "
`nNow, please choose the algorithm you want to get the hash from...
`n1) SHA1
`n2) SHA256
`n3) SHA384
`n4) SHA512
`n5) MACTripleDES
`n6) RIPEMD160
`n7) MD5
`n8) MD4
`n9) MD2
`nEnter a number matching the corresponding selection"

    switch ($var) {
        1 {
            $algorithm = "SHA1"
        }
        2 {
            $algorithm = "SHA256"
        }
        3 {
            $algorithm = "SHA384"
        }
        4 {
            $algorithm = "SHA512"
        }
        5 {
            $algorithm = "MACTripleDES"
        }
        6 {
            $algorithm = "RIPEMD160"
        }
        7 {
            $algorithm = "MD5"
        }
        8 {
            $algorithm = "MD4"
        }
        9 {
            $algorithm = "MD2"
        }
        default {
            Write-Host "Invalid choice. Please enter a valid selection."
            $algorithm = "broken"
        }
    }

    if ($algorithm -eq "broken") {
        continue
    } elseif ($algorithm -eq "MD4" -or $algorithm -eq "MD2") {
        Write-Host "======================================================================================="
        Write-Host "======================================================================================="
        Write-Host "Please wait... retrieving file hash..."
        Write-Host ""
        Write-Host ""
        certutil -hashfile "$path" $algorithm | Format-List
        Write-Host ""
        Write-Host ""
        Write-Host ""
        break
    } else {
        Write-Host "======================================================================================="
        Write-Host "======================================================================================="
        Write-Host "Please wait... retrieving file hash..."
        Get-FileHash "$path" -Algorithm $algorithm | Format-List
        break
    }
}

Write-Host "Done! Thank you for using this script! :D"
pause
exit