mode 270
echo "Made by Captain Chicky 2020."
echo "======================================================================================="
echo "======================================================================================="
echo "Welcome to the hash retriever."
$path = Read-Host "Please type in the file path of the file you want the hash of"
echo "======================================================================================="
echo "======================================================================================="
$algorithm = Read-Host "Please enter the algorithm you want to get the hash from"
echo "======================================================================================="
echo "======================================================================================="
echo "Please wait... retrieving file hash..."
Get-FileHash "$path" -Algorithm $algorithm | Format-List
pause