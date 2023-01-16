<#
    .SYNOPSIS
    Gets one or more Snipe-IT status labels.

    .PARAMETER Id
    Specifies one or more status labels by id.

    .PARAMETER Linked
    Returns linked data for a specified status label id.

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

    .PARAMETER Name
    Specifies the name of the status label to search for.

    .PARAMETER StatusType
    Specifies the type of the status label to search for.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITStatusLabel.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITStatusLabel
{
    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName = "Id")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Id,

        [Parameter(ParameterSetName = "Id")]
        [ValidateSet("Assets")]
        [String]$Linked,

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
        [String]$Sort,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("Ascending", "Descending")]
        [String]$Order,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("Deployable", "Pending", "Archived")]
        [String]$StatusType,

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
                $endpoint  = "$Url/api/v1/statuslabels"
                $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"
                break
            }
    
            "Id"
            {
                if ($Linked)
                {
                    # Linked uses "Assets" instead of "AssetList" for consistency 
                    $endpoint = "$Url/api/v1/statuslabels/$Id/assetlist"
                }

                else
                {
                    $endpoint = "$Url/api/v1/statuslabels/$Id"
                }

                break
            }
        }
    

        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.StatusLabel"
    }
}
