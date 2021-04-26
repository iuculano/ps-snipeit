<#
    .SYNOPSIS
    Creates a new Snipe-IT company.

    .PARAMETER Name
    Specifies the name of the company.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITCompany.ps1
    Alex Iuculano, 2020
#>

function New-SnipeITCompany
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

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


    $endpoint = "$Url/api/v1/companies"
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
