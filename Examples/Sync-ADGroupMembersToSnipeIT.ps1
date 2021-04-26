<#
    .SYNOPSIS
    Basic sync tool for moving AD users to Snipe-IT.

    Currently, it'll sync a group's members. 


    .NOTES
    Sync-ADUsersToSnipeIT.ps1
    Alex Iuculano, 2020
#>

Param
(
    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$Identity = "Active Employees",

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$Url,

    [Parameter(Mandatory = $true)]
    [ValidateNotNullOrEmpty()]
    [String]$APIKey
)


$PSDefaultParameterValues["*-SnipeIT*:Url"]    ??= $Url
$PSDefaultParameterValues["*-SnipeIT*:APIKey"] ??= $APIKey


# Grab all Snipe-IT users first
$usersSI = Get-SnipeITUser

# Next, all AD users and map UserPrinciapalName to UserName for comparison
$usersAD = Get-ADGroupMember $Identity | Get-ADUser -Properties Mail, TelephoneNumber, Title, EmployeeId | Where-Object { $_.Enabled -eq $true }

foreach ($user in $usersAD)
{
    $siArgs =
    @{
        FirstName   = $user.GivenName
        LastName    = $user.Surname
        Username    = $user.UserPrincipalName
        Email       = $user.Mail
        Jobtitle    = $user.Title
        EmployeeNum = $user.EmployeeId
    }

    # Tolerate empty phone numbers
    if ($user.TelephoneNumber)
    {
        $siArgs["Phone"] = $user.TelephoneNumber
    }


    # Really just need this for their user Id :\
    $target = $usersSI.Where({ $user.UserPrincipalName -eq $_.UserName })

    # Update a user if they're in Snipe-IT
    if ($target)
    {
        Set-SnipeITUser @siArgs -Id $target.Id
    }

    # Otherwise, need to create them
    else
    {
        $characterSet        = "$-_.!*'()23456789abcdefghjkmnpqrstuvwxyzABCDEFGHJKLMNPQRSTUVWXYZ"
        $siArgs["Password" ] = -join ($characterSet.ToCharArray() | Get-Random -Count $characterSet.Length)
        $siArgs["Activated"] = $false
        New-SnipeITUser @siArgs
    }
}

# Finally, remove anyone from Snipe-IT who has no AD counterpart
foreach ($user in $usersSI)
{
    if ($user.UserName     -notin $usersAD.UserPrincipalName -and
        $user.Assets_Count -eq 0)
    {
        Remove-SnipeITUser $user.Id -Confirm:$false
    }
}
