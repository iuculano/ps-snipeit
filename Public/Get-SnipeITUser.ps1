<#
    .SYNOPSIS
    Gets one or more Snipe-IT users.

    .PARAMETER Id
    Specifies one or more users by id.

    .PARAMETER Linked
    Returns linked data for a specified user id.

    .PARAMETER Limit
    Specifies the number of results to return.

    .PARAMETER Offset
    Specifies the id to begin returning results from.

    .PARAMETER Search
    Specifies a text string to search the user data for.

    .PARAMETER Sort
    Specifies the column name to sort by.

    This expects snake_case as the naming scheme.

    .PARAMETER Order
    Specifies the order to use on the sort column.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITUser.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITUser
{
    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Id")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Id,

        [Parameter(ParameterSetName = "Id")]
        [ValidateSet("Assets", "Accessories")]
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
        [String]$Username,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Sort,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateSet("Ascending", "Descending")]
        [String]$Order,

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
                $endpoint  = "$Url/api/v1/users"
                $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"
                break
            }
    
            "Id"
            {
                if ($Linked)
                {
                    $endpoint = "$Url/api/v1/users/$Id/$($Linked.ToLower())"
                }
    
                else
                {
                    $endpoint = "$Url/api/v1/users/$Id"
                }

                break
            }
        }
    

        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.User"
    }
}
