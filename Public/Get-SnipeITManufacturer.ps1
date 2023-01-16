<#
    .SYNOPSIS
    Gets one or more Snipe-IT manufacturers.

    .PARAMETER Id
    Specifies one or more manufacturers by id.

    .PARAMETER Name
    Specifies the name of a manufacturer to retrieve.

    .PARAMETER Website
    Specifies the manufacturer's website/homepage to use for the lookup.

    .PARAMETER SupportUrl
    Specifies the manufacturer's support url to use for the lookup.

    .PARAMETER SupportPhone
    Specifies the manufacturer's support phone number to use for the lookup.

    .PARAMETER SupportEmail
    Specifies the manufacturer's support email address to use for the lookup.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITManufacturers.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITManufacturer
{
    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Id")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Id,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APIQueryStringAttribute("url")]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$Website,
        
        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$SupportUrl,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$SupportPhone,

        [APIQueryStringAttribute()]
        [Parameter(ParameterSetName = "Default")]
        [ValidateNotNullOrEmpty()]
        [String]$SupportEmail,

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
                $endpoint  = "$Url/api/v1/manufacturers"
                $endpoint += ConvertTo-SnipeITAPI $PSCmdlet -As "QueryString"
                break
            }
    
            "Id"
            {
                $endpoint = "$Url/api/v1/manufacturers/$Id"
                break
            }
        }

        
        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.Manufacturer"
    }
}
