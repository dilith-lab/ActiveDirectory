# ActiveDirectory
Scripts related to Active Directory module
## Users
### View Reporting CXO
The following PowerShell script can be used to view the reporting CXO of a list of users with UserPrincipalName (UPN) in Active Directory. You can download the script from Github.

[ReportingCXO.ps1](https://github.com/dilith-lab/ActiveDirectory/blob/main/Users/ReportingCXO.ps1) 
```
PowerShell.exe -ExecutionPolicy Bypass -File .\ReportingCXO.ps1

# Define the CEO's name
$CEOName = "Yara Ayurvie"

# Defind the User List.
$UserList = '.\Users.csv'
```
By providing,
- CEOName 
- UserList with UserPrincipalName (UPN). Sample CSV file: [Users.csv](https://github.com/dilith-lab/ActiveDirectory/blob/main/Users/Users.csv)

it will export CSV file with user email address and corresponding CXO.

#### Hierarchical organization
Using PowerShell and Active Directory, it determines if users directly report to the CEO or traverse the managerial hierarchy. I have use this [UserList](https://github.com/dilith-lab/ActiveDirectory/blob/main/Users/SampleUsers/bulk_users.csv) for the demonstration.

![Hierarchical organization](https://github.com/dilith-lab/ActiveDirectory/blob/main/Users/SampleUsers/Org-Hierarchy.png "Hierarchical organization")

## Groups
### View Active Directory Group Members
The following PowerShell script can be used to view the members of an Active Directory group. You can download the script from Github.

[ViewMembers.ps1](https://github.com/dilith-lab/ActiveDirectory/blob/master/Groups/ViewMembers.ps1) 
```
PowerShell.exe -ExecutionPolicy Bypass -File .\ViewMembers.ps1 -GroupName SystemAdmin
```
By providing group name argument **-GroupName** *[group name]*, it will export a CSV file with group members of that specific group.

### Add Active Directory Group Members
The following PowerShell script can be used to add the members to an Active Directory group. You can download the script from Github.

[AddMembers.ps1](https://github.com/dilith-lab/ActiveDirectory/blob/master/Groups/AddMembers.ps1)
```
PowerShell.exe -ExecutionPolicy Bypass -File .\AddMembers.ps1 -GroupName SystemAdmin -FileName .\GroupMembers.csv
```
By providing group name argument **-GroupName** *[group name]* and **-FileName** *[file name]*, it will add the group members to that specific group.

### Remove Active Directory Group Members
The following PowerShell script can be used to remove the members to an Active Directory group. You can download the script from Github.

[RemoveMembers.ps1](https://github.com/dilith-lab/ActiveDirectory/blob/master/Groups/RemoveMembers.ps1)
```
PowerShell.exe -ExecutionPolicy Bypass -File .\RemoveMembers.ps1 -GroupName SystemAdmin -FileName .\GroupMembers.csv
```
By providing group name argument **-GroupName** *[group name]* and **-FileName** *[file name]*, it will remove the group members from that specific group.
