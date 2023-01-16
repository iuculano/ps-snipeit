<#
    .SYNOPSIS
    Gets one or more Snipe-IT assets.

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

    .PARAMETER ModelId
    Restrict results to a specified model id.

    .PARAMETER CategoryId
    Restrict results to a specified category id.

    .PARAMETER ManufacturerId
    Restrict results to a specified manufacturer id.

    .PARAMETER CompanyId
    Restrict results to a specified company id.

    .PARAMETER LocationId
    Restrict results to a specified location id.

    .PARAMETER Status
    Restrict results to a specified status.

    Acceptable values for this parameter are:
    "RTD", "Deployed", "Undeployable", "Deleted", "Requestable"

    .PARAMETER StatusId
    Restrict results to a specified staus id.

    .PARAMETER Id
    Restrict results to a specified asset id.

    .PARAMETER AssetTag
    Restrict results to a specified asset tag.

    .PARAMETER Serial
    Restrict results to a specified serial number.

    .PARAMETER Audit
    Returns assets due for an audit.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITHardware.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITHardware
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
        [String]$Sort,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("Ascending", "Descending")]
        [String]$Order,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ModelId,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CategoryId,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManufacturerId,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CompanyId,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$LocationId,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("RTD", "Deployed", "Undeployable", "Deleted", "Requestable")]
        [String]$Status,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$StatusId,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Id")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Id,

        [Parameter(Mandatory        = $true,
                   ParameterSetName = "AssetTag")]
        [ValidateNotNullOrEmpty()]
        [String]$AssetTag,

        [Parameter(Mandatory        = $true,
                   ParameterSetName = "Serial")]
        [ValidateNotNullOrEmpty()]
        [String]$Serial,

        [Parameter(ParameterSetName = "Audit")]
        [ValidateSet("Due", "Overdue")]
        [String]$Audit,

        [Parameter(ParameterSetName = "Id")]
        [Switch]$License,

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
                $endpoint  = "$Url/api/v1/hardware"
                $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"
                break
            }
    
            "Id"
            {
                if ($License)
                {
                    $endpoint = "$Url/api/v1/hardware/$Id/licenses"
                }

                else
                {
                    $endpoint = "$Url/api/v1/users/$Id"
                }

                break
            }
    
            "AssetTag"
            {
                $endpoint = "$Url/api/v1/hardware/bytag/$AssetTag"
                break
            }
    
            "Serial"
            {
                $endpoint = "$Url/api/v1/hardware/byserial/$Serial"
                break
            }
    
            "Audit"
            {
                $endpoint = "$Url/api/v1/hardware/audit/$($Audit.ToLower())"
                break
            }
        }

        
        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.Hardware"
    }
}
