# Name: Get Reporting CXO.
# Description: Get Reporting CXO (Using CEO name) of a set of users. Define the CEO Name on $CEOName variable.
# Author: Dilith Achalan
# Date: 02/08/2024
# Version: 1.0.0
# Usage: PowerShell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ReportingCXO.ps1"
# Notes: [Any additional information or notes about the script]

# --- BEGIN SCRIPT ---

# Define the CEO's name
$CEOName = "Yara Ayurvie"

# Defind the User List.
$UserList = '.\Users.csv'

# Get the email addresses from a file
$Emails = Import-Csv -Path $UserList | Select-Object -ExpandProperty UserPrincipalName

# Create an empty array to store the output
$Output = @()

# Loop through each email address
foreach ($Email in $Emails) {

    Write-Host "Processing email: $Email"

    # Get the user object that matches the email address
    $User = Get-ADUser -Filter {EmailAddress -eq $Email} -Properties Manager

    # Reset the CXO variable
    $MatchedCXO = $null

    # Check if the user's manager is the CEO
    if ($User.Manager -ne $null) {
        $Manager = Get-ADUser -Identity $User.Manager -Properties DisplayName, Mail
        if ($Manager.DisplayName -eq $CEOName) {
            # User is reporting directly to the CEO
            $MatchedCXO = $Manager
        }
    }

    # If the user is not reporting directly to the CEO, loop through managers until we find the CEO
    if ($MatchedCXO -eq $null) {
        while ($User.Manager -ne $null) {
            # Get the manager object
            $Manager = Get-ADUser -Identity $User.Manager -Properties DisplayName, Mail, Manager

            # Check if the manager's display name matches the CEO's name
            if ($Manager.DisplayName -eq $CEOName) {
                # Found the CEO, so the CXO is the previous manager
                $MatchedCXO = $User
                break
            }

            # Move up the hierarchy to the next manager
            $User = $Manager
        }
    }

    # Determine the CXO's name based on whether it was found or not
    $CXOName = if ($MatchedCXO) {$MatchedCXO.DisplayName} else {"CXO not found"}

    # Create a custom object with the user mail and CXO name
    $Object = [PSCustomObject]@{
        mail = $Email
        CXOName = $CXOName
    }

    # Add the object to the output array
    $Output += $Object
}

# Export the output array to a csv file
$Output | Export-Csv -Path ReportingCXO.csv -NoTypeInformation

Write-Host "Script execution completed."

# --- END SCRIPT ---