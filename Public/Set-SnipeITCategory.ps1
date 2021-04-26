<#
    .SYNOPSIS
    Updates one or more Snipe-IT categories.

    .PARAMETER InputObject
    Specifies an axSnipeIT.Category object returned by a previous 
    Get-SnipeITCategory call. This will be mapped to the user's Id.

    .PARAMETER Id
    Specifies the id of the category to update.

    .PARAMETER Name
    Specifies the name of the category.

    .PARAMETER CategoryType
    Specifies the category type.

    .PARAMETER UseDefaultEula
    I have no idea currently. API docs have a blank description. :(

    .PARAMETER RequireAcceptance
    Specifies whether to require a user to accept the terms.

    .PARAMETER CheckInEmail
    Specifies whether to send the user the EULA and acceptance email
    when the item is checked in.
        
    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITCategory.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITCategory
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.Category")][Object]$InputObject,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Default")]            
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32[]]$Id,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateSet("Asset", "Accessory", "Consumable", "Component")]
        [String]$CategoryType,

        [APISubmittableAttribute()]
        [Bool]$UseDefaultEula,

        [APISubmittableAttribute()]
        [Bool]$RequireAcceptance,

        [APISubmittableAttribute()]
        [Bool]$CheckinEmail,

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


            $endpoint = "$Url/api/v1/categories/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
