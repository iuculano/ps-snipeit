<#
    .SYNOPSIS
    Gets one or more Snipe-IT companies.

    .PARAMETER Search
    Specifies a text string to search the asset data for.

    .PARAMETER Id
    Restrict results to a specified company id.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITCompany.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITCompany
{
    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Search,

        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName = "Id")]
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
                $endpoint  = "$Url/api/v1/companies"
                $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"
                break
            }
    
            "Id"
            {
                $endpoint = "$Url/api/v1/companies/$Id"
                break
            }
        }

    
        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.Company"
    }
}
