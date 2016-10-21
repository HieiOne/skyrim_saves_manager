##########################################################################################
# Name: SKYRIM Saves Manager                                                              
# Author: Hiei <blascogasconiban@gmail.com>                                                  
# Version: 1.0                                                                           
# Description: 
#              This script will backup your saves and remove       
# 	           from the backup folder saves older than 2 days,
#	           It also removes the oldest saves in the Skyrim 
#			   saves folder if you are sick of it like I was.                                                                                  
# IMPORTANT:                                                                             
#	        -                                                                                
#                                                                                                                                                    
##########################################################################################

$now = Get-Date
$days = "2"  #--- Days you want your file to survive ---#
$lastwrite = $now.AddDays(-$days)
$savesdirectory = "$env:USERPROFILE\Documents\My Games\Skyrim\Saves"
$backupdirectory = "$env:USERPROFILE\Documents\My Games\Skyrim\BackUP"
$extension = "*.skse", "*.ess"
$files = Get-Childitem $savesdirectory -Include $extension -Recurse
$oldfiles = Get-Childitem $backupdirectory -Include $extension -Recurse | Where {$_.LastWriteTime -le "$lastWrite"}
$savefiles = Get-Childitem $savesdirectory -Include $extension -Recurse | Where {-not $_.PsIsContainer} | sort CreationTime -desc | select -Skip 10 #--- Modify Skip for more saves ---#

function backup
{
	if (!(Test-Path -path $backupdirectory)) {New-Item $backupdirectory -Type Directory}
	foreach ($file in $files) 
		{
		if ($file -ne $NULL)
		{
			Write-Host "BackUp Completed for $file!"
			Copy-Item $file.FullName -Destination $backupdirectory | out-null
		}
		else
		{
			Write-Host "No more files to save"
		}
		}
}

function rbackup
{
	foreach ($file in $oldfiles) 
		{
		if ($file -ne $NULL)
			{
			Write-Host "Deleting File $file"
			Remove-Item $file.FullName | out-null
			}
		else
			{
			Write-Host "No more files to delete!"
			}
		}
}
	
function rsaves
{
	foreach ($file in $savefiles)
		{
		if ($file -ne $NULL)
			{
			Write-Host "Deleting File $file"
			Remove-Item $file.FullName | out-null
			}
		else
			{
			Write-Host "No more files to delete!"
			}
		}
}

function Menu
{
     param (
           [string]$Title = 'SKYRIM Saves Manager'
     )
     cls
     Write-Host "================ $Title ================"
     
     Write-Host "1: Press '1' for BackUP your save files."
     Write-Host "2: Press '2' for Remove old BackUP save files."
     Write-Host "3: Press '3' for Remove old saves in Skyrim Directory."
     Write-Host "Q: Press 'Q' to Quit."
}

do
{
     Menu
     $input = Read-Host "Please make a selection"
     switch ($input)
     {
           '1' {
                backup
           } '2' {
                rbackup
           } '3' {
                rsaves
           } 'q' {
                return
           }
     }
     pause
}
until ($input -eq 'q')