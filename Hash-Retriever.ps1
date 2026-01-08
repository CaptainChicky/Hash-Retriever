$Host.UI.RawUI.WindowSize = New-Object Management.Automation.Host.Size(150, 40)
$Host.UI.RawUI.BackgroundColor = "Black"
$Host.UI.RawUI.ForegroundColor = "Cyan"
Clear-Host

function Write-Header {
    param([string]$Title)
    Write-Host ""
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host " $Title" -ForegroundColor White
    Write-Host "===============================================================================" -ForegroundColor Cyan
    Write-Host ""
}

function Write-Success {
    param([string]$Message)
    Write-Host "✓ $Message" -ForegroundColor Green
}

function Write-Error {
    param([string]$Message)
    Write-Host "✗ ERROR: $Message" -ForegroundColor Red
}

function Get-MACKey {
    Write-Header "MACTripleDES Key Configuration"
    
    Write-Host "  MACTripleDES requires a cryptographic key." -ForegroundColor Gray
    Write-Host "  Enter key in hex format (16 or 24 bytes = 32 or 48 hex characters)" -ForegroundColor Gray
    Write-Host "  Example: A3E8B7C2F1D4968E5A7C3B9F2E1D6840" -ForegroundColor Yellow
    Write-Host "  NOTE: Avoid sequential patterns like 0123456789ABCDEF (weak keys)" -ForegroundColor Yellow
    Write-Host ""
    
    while ($true) {
        $key = Read-Host "  Enter key (or press Enter for default)"
        
        # Use default if empty
        if ([string]::IsNullOrWhiteSpace($key)) {
            $key = "A3E8B7C2F1D4968E5A7C3B9F2E1D6840"
            Write-Host ""
            Write-Host "  Using default secure key." -ForegroundColor Yellow
            return $key
        }
        
        # Check length
        if ($key.Length -ne 32 -and $key.Length -ne 48) {
            Write-Host ""
            Write-Error "Key must be exactly 32 or 48 hex characters (16 or 24 bytes)."
            Write-Host "  You entered $($key.Length) characters." -ForegroundColor Gray
            Write-Host ""
            continue
        }
        
        # Validate hex characters
        if ($key -notmatch '^[0-9A-Fa-f]+$') {
            Write-Host ""
            Write-Error "Key must contain only hex characters (0-9, A-F)."
            Write-Host ""
            continue
        }
        
        # Confirm key
        Write-Host ""
        Write-Host "  You have entered key: " -NoNewline -ForegroundColor Gray
        Write-Host $key -ForegroundColor Yellow
        Write-Host "  Length: $($key.Length) hex characters ($($key.Length / 2) bytes)" -ForegroundColor Gray
        Write-Host ""
        
        $confirm = Read-Host "  Is this correct? (Y/N)"
        
        if ($confirm -eq "Y" -or $confirm -eq "y") {
            Write-Success "Key validated successfully!"
            return $key
        }
        else {
            Write-Host ""
            Write-Host "  Please re-enter the key..." -ForegroundColor Yellow
            Write-Host ""
        }
    }
}

# Introduction
Clear-Host
Write-Host ""
Write-Host "  ╔═══════════════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "  ║                    HASH RETRIEVER v2.0                            ║" -ForegroundColor Cyan
Write-Host "  ║                 Made by Captain Chicky 2026                       ║" -ForegroundColor Cyan
Write-Host "  ╚═══════════════════════════════════════════════════════════════════╝" -ForegroundColor Cyan
Write-Host ""
Write-Host "  This utility helps you compute cryptographic hashes of files." -ForegroundColor Gray
Write-Host "  Supports: MD2, MD4, MD5, SHA1, SHA256, SHA384, SHA512," -ForegroundColor Gray
Write-Host "            RIPEMD160, and MACTripleDES" -ForegroundColor Gray
Write-Host ""

# Get File Path
do {
    $path = Read-Host "  Enter file path"
    
    if ([string]::IsNullOrWhiteSpace($path)) {
        Write-Error "File path cannot be empty."
        Write-Host ""
        continue
    }
    
    # Remove quotes if present
    $path = $path.Trim('"')
    
    Write-Host ""
    Write-Host "  You have entered: " -NoNewline -ForegroundColor Gray
    Write-Host $path -ForegroundColor Yellow
    Write-Host ""
    
    $confirm = Read-Host "  Is this correct? (Y/N)"
    
    if ($confirm -eq "N" -or $confirm -eq "n") {
        Write-Host ""
        Write-Host "  Please retype the file path..." -ForegroundColor Yellow
        Write-Host ""
        continue
    }
    elseif ($confirm -eq "Y" -or $confirm -eq "y") {
        if (-not (Test-Path -Path $path -PathType Leaf)) {
            Write-Host ""
            Write-Error "File does not exist. Please try again."
            Write-Host ""
            continue
        }
        else {
            Write-Success "File found!"
            break
        }
    }
    else {
        Write-Host ""
        Write-Error "Invalid choice. Please enter Y or N."
        Write-Host ""
    }

} while ($true)

# Get Algorithm
Write-Header "Select Hash Algorithm"

Write-Host "  ┌─────────────────────────────────────────────────────────────────┐" -ForegroundColor Cyan
Write-Host "  │  [1] MD2        [2] MD4        [3] MD5                          │" -ForegroundColor White
Write-Host "  │  [4] SHA1       [5] SHA256     [6] SHA384                       │" -ForegroundColor White
Write-Host "  │  [7] SHA512     [8] RIPEMD160  [9] MACTripleDES (requires key)  │" -ForegroundColor White
Write-Host "  └─────────────────────────────────────────────────────────────────┘" -ForegroundColor Cyan
Write-Host ""

$macKey = $null

while ($true) {
    $choice = Read-Host "  Enter number (1-9)"
    
    $algorithm = switch ($choice) {
        "1" { "MD2"; break }
        "2" { "MD4"; break }
        "3" { "MD5"; break }
        "4" { "SHA1"; break }
        "5" { "SHA256"; break }
        "6" { "SHA384"; break }
        "7" { "SHA512"; break }
        "8" { "RIPEMD160"; break }
        "9" { "MACTripleDES"; break }
        default { 
            Write-Host ""
            Write-Error "Invalid choice. Please enter a number between 1 and 9."
            Write-Host ""
            $null
        }
    }
    
    if ($null -ne $algorithm) {
        Write-Success "Algorithm selected: $algorithm"
        
        # Get MAC key if MACTripleDES is selected
        if ($algorithm -eq "MACTripleDES") {
            $macKey = Get-MACKey
        }
        
        break
    }
}

# Compute Hash
Write-Header "Computing Hash"

Write-Host "  Algorithm: " -NoNewline -ForegroundColor Gray
Write-Host $algorithm -ForegroundColor Yellow
Write-Host "  File: " -NoNewline -ForegroundColor Gray
Write-Host $path -ForegroundColor Yellow
if ($algorithm -eq "MACTripleDES") {
    Write-Host "  Key: " -NoNewline -ForegroundColor Gray
    Write-Host $macKey -ForegroundColor Yellow
}
Write-Host ""
Write-Host "  Please wait... computing hash..." -ForegroundColor Gray
Write-Host ""

try {
    if ($algorithm -eq "MD4" -or $algorithm -eq "MD2") {
        # Use CertUtil for MD4 and MD2
        $result = certutil -hashfile "$path" $algorithm 2>&1
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
            Write-Host ""
            $result | ForEach-Object {
                if ($_ -match '^[a-fA-F0-9\s]+$' -and $_.Trim().Length -gt 10) {
                    Write-Host "  Hash: " -NoNewline -ForegroundColor Green
                    Write-Host $_.Trim() -ForegroundColor White
                }
            }
            Write-Host ""
            Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
        } else {
            Write-Error "Failed to compute hash with CertUtil."
        }
    }
    elseif ($algorithm -eq "MACTripleDES") {
        # Use .NET for MACTripleDES
        $keyBytes = New-Object byte[] ($macKey.Length / 2)
        for ($i = 0; $i -lt $macKey.Length; $i += 2) {
            $keyBytes[$i / 2] = [Convert]::ToByte($macKey.Substring($i, 2), 16)
        }
        
        $stream = [System.IO.File]::OpenRead($path)
        $mac = New-Object System.Security.Cryptography.MACTripleDES
        $mac.Key = $keyBytes
        $hashBytes = $mac.ComputeHash($stream)
        $stream.Close()
        $mac.Dispose()
        
        $hashString = [System.BitConverter]::ToString($hashBytes) -replace '-',''
        
        Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Algorithm : " -NoNewline -ForegroundColor Gray
        Write-Host "MACTripleDES" -ForegroundColor White
        Write-Host "  MAC       : " -NoNewline -ForegroundColor Green
        Write-Host $hashString -ForegroundColor White
        Write-Host "  Key       : " -NoNewline -ForegroundColor Gray
        Write-Host $macKey -ForegroundColor White
        Write-Host "  Path      : " -NoNewline -ForegroundColor Gray
        Write-Host $path -ForegroundColor White
        Write-Host ""
        Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
    }
    elseif ($algorithm -eq "RIPEMD160") {
        # Use .NET for RIPEMD160
        $stream = [System.IO.File]::OpenRead($path)
        $hasher = [System.Security.Cryptography.RIPEMD160]::Create()
        $hashBytes = $hasher.ComputeHash($stream)
        $stream.Close()
        
        $hashString = [System.BitConverter]::ToString($hashBytes) -replace '-',''
        
        Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Algorithm : " -NoNewline -ForegroundColor Gray
        Write-Host "RIPEMD160" -ForegroundColor White
        Write-Host "  Hash      : " -NoNewline -ForegroundColor Green
        Write-Host $hashString -ForegroundColor White
        Write-Host "  Path      : " -NoNewline -ForegroundColor Gray
        Write-Host $path -ForegroundColor White
        Write-Host ""
        Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
    }
    else {
        # Use Get-FileHash for SHA1, SHA256, SHA384, SHA512, MD5
        $hash = Get-FileHash -Path $path -Algorithm $algorithm -ErrorAction Stop
        
        Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "  Algorithm : " -NoNewline -ForegroundColor Gray
        Write-Host $hash.Algorithm -ForegroundColor White
        Write-Host "  Hash      : " -NoNewline -ForegroundColor Green
        Write-Host $hash.Hash -ForegroundColor White
        Write-Host "  Path      : " -NoNewline -ForegroundColor Gray
        Write-Host $hash.Path -ForegroundColor White
        Write-Host ""
        Write-Host "  ─────────────────────────────────────────────────────────" -ForegroundColor Cyan
    }
    
    Write-Host ""
    Write-Success "Hash computation complete!"
    
} catch {
    Write-Host ""
    Write-Error "Failed to compute hash: $($_.Exception.Message)"
}

# Footer
Write-Host ""
Write-Host "===============================================================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Done! Thank you for using this script :D" -ForegroundColor Green
Write-Host ""

Read-Host "  Press Enter to exit"
exit