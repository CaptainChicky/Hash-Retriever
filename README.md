# README NOT FINISHED

# What is the hash retriever?
This is a collection of scripts aimed towards helping a user find a file's hash. I wrote this after I found myself in need of finding file hashes of virtual disk image files for installing windows I've torrented from archive.org and a few Linux ISOs. I didn't feel like remembering the commands of PowerShell to find the hashes, so I made this where one would only need to type in the file path, and identify the algorithm used to find the hash.

# What this repository contains...
This repository contains two folders:

1) PowerShell Hash Retriever, which contains the PowerShell scripts for finding file hash. There are three scripts currently, v1.0, 2.0, and 2.1. v1.0 is a script I spent little time on as a preliminary base to write the others. v2.0 is a polished script, and v2.1 adds a couple more hash algorithm options by utilizing certutil. 

2) Cmd Hash Retriever, which contains a single batch script imitating the v2.1 PowerShell script. Note that since the command prompt doesn't have any built in hash finding command, only certutil can be used, and thus lacks a couple of options, namely, MACTripleDES and RIPEMD160.

*Note*: The batch script can detect when you make the wrong hash algorithm choice, but the PowerShell script cannot. However, both the PowerShell scripts and the batch script cannot make sure that the file path is correct, so therefore, I have included a second verification step that allows the user to retype to file path, assuming the first time they made a mistake.

# Requirements to use...
PowerShell(no duh), and since there is still a little bit of MS-DOS batch programming, Windows Command Prompt(cmd.exe) is a optional feature to include.
