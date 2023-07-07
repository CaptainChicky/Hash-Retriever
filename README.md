# What is this?
This is a collection of scripts aimed towards helping a user find a file's hash. I wrote this after I found myself in need of finding file hashes of virtual disk image files for installing windows I've torrented from archive.org and a few Linux ISOs. I didn't feel like remembering the commands of PowerShell to find the hashes, so I made this where one would only need to type in the file path, and identify the algorithm used to find the hash.

I've revisited this in 2023 and updated the batchfile script and powershell scripts with better code and better coding habits lol.

# Contents and Use
This repository contains two folders:

1) PowerShell Hash Retriever, which contains the PowerShell scripts for finding file hash. There are three scripts currently, v1.0, 2.0, and 2.1. v1.0 is a script I spent little time on as a preliminary base to write the others. v2.0 is a polished script, and v2.1 adds a couple more hash algorithm options by utilizing certutil. For 2023, I've also revisited this and added a v2.2 that formats everything correctly and adds incorrect input catching.

2) Batchfile Hash Retriever, which contains a single batch script imitating the v2.1 PowerShell script. Note that since the command prompt doesn't have any built in hash finding command, only certutil can be used, and thus lacks a couple of options, namely, MACTripleDES and RIPEMD160. I've also revisited this in 2023 with a v2.0 that doesn't use goto (which disrupts code flow), and formats everything nicely with good batchfile coding habits.

# Dependencies
The PowerShell scripts, to be safe, should run on PowerShell 5.1 or higher, which should have native cmdlets that can hash. Both it and the batchfile script should be able to access `certutil.exe`, which should come installed with Windows 10 in the System32 folder, along with the command prompt.
