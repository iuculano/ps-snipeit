<#
    .SYNOPSIS
    Gets one or more Snipe-IT accessories.

    .PARAMETER Limit
    Specifies the number of results to return.

    .PARAMETER Offset
    Specifies the id to begin returning results from.

    .PARAMETER Search
    Specifies a text string to search the asset data for.

    .PARAMETER OrderNumber
    Restrict results to accessories with a specified order number.

    .PARAMETER Sort
    Specifies the column name to sort by.

    This expects snake_case as the naming scheme.

    .PARAMETER Order
    Specifies the order to use on the sort column.

    .PARAMETER Expand
    Specifies whether to return detailed information.

    .PARAMETER Id
    Restrict results to a specified accessory id.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITAccessory.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITAccessory
{
    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]$Limit,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]$Offset,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Search,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$OrderNumber,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Sort,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("Ascending", "Descending")]
        [String]$Order,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("True", "False")]
        [String]$Expand,

        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Id")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Id,

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
                $endpoint  = "$Url/api/v1/accessories"
                $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"
                break
            }
    
            "Id"
            {
                $endpoint = "$Url/api/v1/accessories/$Id"
                break
            }
        }
        

        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.Accessory"
    }
}
