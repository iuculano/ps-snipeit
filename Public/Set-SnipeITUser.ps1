<#
    .SYNOPSIS
    Gets one or more Snipe-IT users.

    .PARAMETER InputObject
    Specifies an axSnipeIT.User object returned by a previous Get-SnipeITUser 
    call. This will be mapped to the user's Id.

    .PARAMETER Id
    Specifies the Id number of a user to update.

    .PARAMETER FirstName
    Specifies the first name to set on the user.

    .PARAMETER LastName
    Specifies the last name to set on the user.

    .PARAMETER Username
    Specifies the username to set on the user.

    .PARAMETER Password
    Specifies a new password to set on the user.

    .PARAMETER Email
    Specifies the email address to set on the user.

    .PARAMETER Permissions
    Not implemented.

    .PARAMETER Activated
    Specifies whether a user account is activated.

    .PARAMETER Phone
    Specifies the phone number to set on the user.

    .PARAMETER JobTitle
    Specifies the job title to set on the user.

    .PARAMETER ManagerId
    Specifies the manager to set on the user, by id.

    .PARAMETER EmployeeNumber
    Specifies the employee number/id to set on the user.
    
    .PARAMETER Notes
    Specifies additional notes to set on the user.

    .PARAMETER CompanyId
    Specifies the id of the company that the user should be bound to.

    .PARAMETER TwoFactorEnrolled
    Specifies whether user is enrolled in MFA.

    .PARAMETER TwoFactorOptin
    ?
    
    .PARAMETER DepartmentId,
    Specifies the id of the department that the user should be bound to.

    .PARAMETER LocationId
    Specifies the id of the location that the user should be bound to.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITUser.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITUser
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.User")][Object]$InputObject,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Default")]            
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32[]]$Id,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$FirstName,
        
        [APISubmittableAttribute()]
        [String]$LastName,
        
        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Username,
        
        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Password,
        
        [APISubmittableAttribute()]
        [String]$Email,
     
        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Permissions,
        
        [APISubmittableAttribute()]
        [Bool]$Activated,
        
        [APISubmittableAttribute()]
        [String]$Phone,
        
        [APISubmittableAttribute("job_title")]
        [String]$JobTitle,
        
        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManagerId,

        [APISubmittableAttribute("employee_num")]
        [String]$EmployeeNumber,

        [APISubmittableAttribute()]
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


    Process
    {
        switch ($PSCmdlet.ParameterSetName)
        {
            "Default"
            {
                $identity = $Id
                break
            }

            "InputObject"
            {
                $identity = $InputObject.Id
                break
            }
        }


        foreach ($i in $identity)
        {
            if (!$PSCmdlet.ShouldProcess($i))
            {
                return
            }


            $endpoint = "$Url/api/v1/users/$i"
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
