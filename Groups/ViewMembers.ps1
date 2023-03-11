# Name: View Group Members
# Description: View group members in a given group.
# Author: Dilith Achalan
# Date: 08/03/2023
# Version: 1.0.0
# Usage: PowerShell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ViewMembers.ps1" -GroupName [Group Name] | Output will export to a CSV file.
# Notes: [Any additional information or notes about the script]

# --- BEGIN SCRIPT ---

param (
  [string]$GroupName
)

if ([string]::IsNullOrEmpty($GroupName)) {
  Write-Host "Group name is a required argument"
  return
}

Write-Host "GroupName: $($GroupName)"

Import-Module ActiveDirectory

try {
    
  # Check if group exists in AD
  $Group = Get-ADGroup -Identity $GroupName -ErrorAction Stop

  # Get AD Group Members for given group
  Get-ADGroupMember -Identity $Group | Select-Object Name, SamAccountName | Export-Csv "GroupMembers_$($GroupName).csv" -NoTypeInformation
    
  if ($?) {
    Write-Host "Group members exported to GroupMembers_$($GroupName).csv file" -ForegroundColor Yellow
  }
  else {
    Write-Error "Failed to get group members for group $GroupName" -ForegroundColor Red
  }

}
catch {
  Write-Host "AD Group $($GroupName) not found" -ForegroundColor Red
}

# --- END SCRIPT ---