<#
    .SYNOPSIS
    Gets one or more Snipe-IT maintenances.

    .PARAMETER Limit
    Specifies the number of results to return.

    .PARAMETER Offset
    Specifies the id to begin returning results from.

    .PARAMETER Search
    Specifies a text string to search the asset data for.

    .PARAMETER Sort
    Specifies the column name to sort by.

    This expects snake_case as the naming scheme.

    .PARAMETER Order
    Specifies the order to use on the sort column.

    .PARAMETER AssetId
    Restrict results to a specified asset id.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITMaintenance.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITMaintenance
{
    [CmdletBinding()]
    Param
    (
        [APIQueryStringAttribute()]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]$Limit,

        [APIQueryStringAttribute()]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]$Offset,

        [APIQueryStringAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Search,

        [APIQueryStringAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Sort,

        [APIQueryStringAttribute()]
        [ValidateSet("Ascending", "Descending")]
        [String]$Order,

        [APIQueryStringAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$AssetId,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )


    $endpoint  = "$Url/api/v1/maintenances"
    $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"


    Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.Maintenance"
}
