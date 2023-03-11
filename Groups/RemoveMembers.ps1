# Name: Remove Group Members from SamAccountName
# Description: Remove group members to a given group.
# Author: Dilith Achalan
# Date: 08/03/2023
# Version: 1.0.0
# Usage: PowerShell.exe -ExecutionPolicy Bypass -File "C:\Scripts\RemoveMembers.ps1" -GroupName [Group Name] -MemberList [csv file]
# Notes: [Any additional information or notes about the script]

# --- BEGIN SCRIPT ---

param (
  [string]$GroupName,
  [string]$FileName = ".\GroupMembers.csv"
)

if ([string]::IsNullOrEmpty($GroupName)) {
  Write-Host "Group name is a required argument"
  return
}
if ([string]::IsNullOrEmpty($FileName)) {
  Write-Host "File name is a required argument"
  return
}

Write-Host "GroupName: $($GroupName)"
Write-Host "FileName: $($FileName)"

Import-Module ActiveDirectory

try{
    
    # Check if group exists in AD
    $Group = Get-ADGroup -Identity $GroupName -ErrorAction Stop

    # Check if file exists
    if (Test-Path $FileName -ErrorAction Stop) {
        $MemberList = Import-csv $FileName

        # Add AD Group Members for given group
        foreach ($Member in $MemberList){
            Remove-ADGroupMember -Identity $Group -Members $Member.SamAccountName -Confirm:$false -ErrorAction Stop
            Write-Host $Member.SamAccountName "removed from the $GroupName group" -ForegroundColor Green
        }
        Write-Host "Group members removed from the $GroupName group" -ForegroundColor Yellow

    } else {
        Write-Host "The file does not exist." -ForegroundColor Red
    }
    
}
catch{
    Write-Host "AD Group $($GroupName) not found" -ForegroundColor Red
}

# --- END SCRIPT ---