<#
    .SYNOPSIS
    Creates a new Snipe-IT location.

    .PARAMETER Name
    Specifies the name of the location.

    .PARAMETER Address
    Specifies the address of the location.

    .PARAMETER Address2
    Specifies the address... 2... of the location.

    .PARAMETER State
    Specifies the state of the location.

    .PARAMETER Country
    Specifies the country of the location.

    .PARAMETER Zip
    Specifies the zip code of the location.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITLocation.ps1
    Alex Iuculano, 2020
#>

function New-SnipeITLocation
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Address,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Address2,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$State,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Country,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Zip,

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


    $endpoint = "$Url/api/v1/locations"
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
