# What is this?
This is a collection of scripts aimed towards helping a user find a file's hash. I wrote this after I found myself in need of finding file hashes of virtual disk image files for installing windows I've torrented from archive.org and a few Linux ISOs. I didn't feel like remembering the commands of PowerShell to find the hashes, so I made this where one would only need to type in the file path, and identify the algorithm used to find the hash.

# Contents and Use

1) PowerShell Hash Retriever `Hash-Retriever.ps1` uses certutil for MD2 and MD4, and .NET for the rest.

2) Batchfile Hash Retriever `Hash-Retriever.bat` uses certutil for most, except for RIPEMD160 and MACTripleDES where it pipes the command into powershell and logs the output.

To use, run the script lol. MACTripleDES isn't a hash exactly per se, but imo an auth hash is basically a hash so w/e I've included it in the scripts. There isn't any CRC32 or whatever as they are really not hashes.

# Dependencies
The PowerShell scripts, to be safe, should run on PowerShell 5.1 or higher, which should have native cmdlets that can hash. Both it and the batchfile script should be able to access `certutil.exe`, which should come installed with Windows 10 in the System32 folder, along with the command prompt.
