<#
    .SYNOPSIS
    Updates one or more Snipe-IT assets.

    .PARAMETER InputObject
    Specifies an axSnipeIT.Hardware object returned by a previous 
    Get-SnipeITHardware call. This will be mapped to the user's Id.

    .PARAMETER Id
    Specifies the id of the asset to update.

    .PARAMETER AssetTag
    Specifies the asset's asset tag.

    .PARAMETER Notes
    Specifies the asset's additional notes.

    .PARAMETER StatusId
    Specifies the id of the status label to bind to the asset.

    .PARAMETER ModelId
    Specifies the id of the model to bind to the asset.

    .PARAMETER LastCheckout
    Specifies the date of the last checkout.

    .PARAMETER AssignedTo
    Specifies the id of the user to bind to the asset.

    .PARAMETER CompanyId
    Specifies the id of the company to bind to the asset.

    .PARAMETER Serial
    Specifies the asset's serial number.
    
    .PARAMETER OrderNumber
    Specifies the asset's order number.

    .PARAMETER PurchaseCost
    Specifies the asset's cost.

    .PARAMETER PurchaseDate
    Specifies the date that the asset was purchased on.

    .PARAMETER Requestable
    Specifies whether the asset can be requested by users.

    .PARAMETER Archived
    Specifies whether the asset is archived.

    .PARAMETER RtdLocationId
    Specifies the asset's usual location when not checked out.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITHardware.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITHardware
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
        [String]$AssetTag,

        [APISubmittableAttribute()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$StatusId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ModelId,

        [APISubmittableAttribute()]
        [DateTime]$LastCheckout,
        
        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$AssignedTo,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CompanyId,

        [APISubmittableAttribute()]
        [String]$Serial,

        [APISubmittableAttribute()]
        [String]$OrderNumber,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$WarrantyMonths,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Float]::MaxValue)]
        [Float]$PurchaseCost,

        [APISubmittableAttribute()]
        [DateTime]$PurchaseDate,
        
        [APISubmittableAttribute()]
        [Bool]$Requestable,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$RtdLocationId,

        [HashTable]$CustomFields,

        [APISubmittableAttribute()]
        [Parameter(ParameterSetName = "Audit")]
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


            $endpoint = "$Url/api/v1/hardware/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
