<#
    .SYNOPSIS
    Assign one or more Snipe-IT assets.

    .PARAMETER InputObject
    Specifies an axSnipeIT.Hardware object returned by a previous 
    Get-SnipeITHardware call. This will be mapped to the user's Id.

    .PARAMETER Id
    Specifies the id of the asset to update.

    .PARAMETER Type
    Specifies the type of asset assignment.

    Valid options are Checkin and Checkout.

    .PARAMETER AssignedUser
    Specifies the id of the user to assign the asset to.

    .PARAMETER AssignedAsset
    Specifies the id of the asset to assign the asset to.

    .PARAMETER AssignedLocation
    Specifies the id of the location to assign the asset to.

    .PARAMETER ExpectedCheckin
    Specifies the expected date of asset checkin.

    .PARAMETER CheckoutAt
    Specifies a date to override the default checkout time of "now."

    .PARAMETER Name
    Specifies a new name that the asset will be changed to.

    .PARAMETER Note
    Specifies a note about the checkout.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITHardwareAssignment.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITHardwareAssignment
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.Hardware")][Object]$InputObject,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32[]]$Id,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateSet("Checkout", "Checkin")]
        [String]$Type,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$AssignedUser,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$AssignedAsset,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$AssignedLocation,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [DateTime]$ExpectedCheckin,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [DateTime]$CheckoutAt,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [Parameter(ParameterSetName = "Checkin")]
        [String]$Note,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkout")]
        [ValidateSet("User", "Asset", "Location")]
        [String]$CheckoutToType = "User",

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "InputObject")]
        [Parameter(ParameterSetName = "Default")]
        [Parameter(ParameterSetName = "Checkin")]
        [ValidateNotNullOrEmpty()]
        [String]$LocationId,

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


            $endpoint = "$Url/api/v1/assets/$i/$($Type.ToLower())"
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            $table.Remove("type")
            Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
