# Name: Get Reporting Manager.
# Description: Get Reporting Manager (CXO, CXO-1, CXO-2 etc) of a set of users. Define the Managers list on $DirectReports variable.
# Author: Dilith Achalan
# Date: 02/08/2024
# Version: 1.0.0
# Usage: PowerShell.exe -ExecutionPolicy Bypass -File "C:\Scripts\ReportingManager.ps1"
# Notes: [Any additional information or notes about the script]

# --- BEGIN SCRIPT ---

# Define the Direct Reports - Names of CXO, CXO-1, CXO-2
$DirectReports = @("Yara Ayurvie", "Ama Fernando", "Hansani Perera", "Jon Secada", "Dilith Achalan", "Kotlin Segev")

# Get the email addresses from a file
$Emails = Import-Csv -Path 'Users.csv' | Select-Object -ExpandProperty UserPrincipalName

# Create an empty array to store the output
$Output = @()

# Loop through each email address
foreach ($Email in $Emails) {

    Write-Host "Processing email: $Email"

    # Get the user object that matches the email address
    $User = Get-ADUser -Filter {EmailAddress -eq $Email} -Properties Manager

    # Initialize the matched DirectReports variable to null
    $MatchedDirectReports = $null

    # Loop through managers until we find the DirectReports
    while ($User.Manager -ne $null) {
        $Manager = Get-ADUser -Identity $User.Manager -Properties DisplayName, Mail, Manager
        if ($DirectReports -contains $Manager.DisplayName) {
            # Found the DirectReports, so assign it to the matched DirectReports variable
            $MatchedDirectReports = $Manager
            break
        }
        $User = $Manager
    }

    # Create a custom object with the user mail, DirectReports name, and DirectReports email
    $DirectReportName = if ($MatchedDirectReports) {$MatchedDirectReports.DisplayName} else {"CXO not found"}
    $Object = [PSCustomObject]@{
        mail = $Email
        DirectReportName = $DirectReportName
    }

    # Add the object to the output array
    $Output += $Object
}

# Export the output array to a csv file
$Output | Export-Csv -Path ReportingManager.csv -NoTypeInformation -Append -Force

Write-Host "Script execution completed."

# --- END SCRIPT ---