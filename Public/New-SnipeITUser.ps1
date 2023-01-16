<#
    .SYNOPSIS
    Creates a new Snipe-IT user.

    .PARAMETER FirstName
    Specifies the user's first name.

    .PARAMETER LastName,
    Specifies the user's last name.

    .PARAMETER Username,
    Specifies the user's username.

    .PARAMETER Password,
    Specifies the user's password.

    .PARAMETER Email
    Specifies the user's email address.

    .PARAMETER Permissions
    Not implemented, I have no idea.

    .PARAMETER Activated
    Specifies whether the user's account is active.
    
    .PARAMETER Phone,
    Specifies the user's phone number.

    .PARAMETER JobTitle
    Specifies the user's job title.

    .PARAMETER ManagerId
    Specifies the id of the manager that the user is bound to.

    .PARAMETER EmployeeNumber
    Specifies the user's employee number/id.

    .PARAMETER Notes
    Specifies additional notes for the user.

    .PARAMETER CompanyId
    Specifies the id of the company that the user is bound to.

    .PARAMETER TwoFactorEnrolled
    Specifies whether user is enrolled in MFA.

    .PARAMETER TwoFactorOptin
    ?

    .PARAMETER DepartmentId
    Specifies the id of the department that the user is bound to.

    .PARAMETER LocationId
    Specifies the id of the location that the user is bound to.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITUser.ps1
    Alex Iuculano, 2020
#>

function New-SnipeITUser
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$FirstName,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$LastName,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Username,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Password,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Email,

        # Honestly no idea, docs don't make this obvious how it works
        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Permissions,

        [APISubmittableAttribute()]
        [Bool]$Activated,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Phone,

        [APISubmittableAttribute("job_title")]
        [ValidateNotNullOrEmpty()]
        [String]$JobTitle,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManagerId,

        [APISubmittableAttribute("employee_num")]
        [ValidateNotNullOrEmpty()]
        [String]$EmployeeNumber,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CompanyId,

        [APISubmittableAttribute()]
        [Bool]$TwoFactorEnrolled,

        [APISubmittableAttribute()]
        [Bool]$TwoFactorOptin,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$DepartmentId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$LocationId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )

    
    if (!$PSCmdlet.ShouldProcess($Username))
    {
        return
    }


    $endpoint = "$Url/api/v1/users"
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    if ($Password)
    {
        $table["password_confirmation"] = $Password
    }
    
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
