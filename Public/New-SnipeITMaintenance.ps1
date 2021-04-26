<#
    .SYNOPSIS
    Creates a new Snipe-IT maintenance.

    .PARAMETER Title
    Specifies the maintenance's title.

    .PARAMETER AssetId
    Specifies the id of the asset to bind the maintenance to.

    .PARAMETER SupplierId
    Specifies the supplier? 
    Snipe-IT doesn't have a description for this field.

    .PARAMETER IsWarranty
    Specifies the warranty status? 
    Snipe-IT doesn't have a description for this field.

    .PARAMETER Cost
    Specifies the cost associated to the maintenance? 
    Snipe-IT doesn't have a description for this field.

    .PARAMETER Notes
    Specifies additional notes to set on the maintenance.

    .PARAMETER AssetMaintenanceType
    Specifies the type of maintenance.

    .PARAMETER StartDate
    Specifies the date that the maintenance will begin.

    .PARAMETER CompletionDate
    Specifies the date that the maintenance will end.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITMaintenance.ps1
    Alex Iuculano, 2020
#>

function New-SnipeITMaintenance
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Title,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$AssetId,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$SupplierId,

        [APISubmittableAttribute()]
        [Bool]$IsWarranty,

        [APISubmittableAttribute()]
        [Float]$Cost,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$AssetMaintenanceType,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [DateTime]$StartDate,

        [APISubmittableAttribute()]
        [DateTime]$CompletionDate,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )


    if (!$PSCmdlet.ShouldProcess($Name))
    {
        return
    }


    $endpoint = "$Url/api/v1/maintenances"
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
