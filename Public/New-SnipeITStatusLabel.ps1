<#
    .SYNOPSIS
    Creates a new Snipe-IT status label.

    .PARAMETER Name
    Specifies the name of the status label.

    .PARAMETER Type
    Specifies the status label's type.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITStatusLabel.ps1
    Alex Iuculano, 2020
#>

function New-SnipeITStatusLabel
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APISubmittableAttribute()]
        [ValidateSet("Deployable", "Pending", "Archived")]
        [String]$Type,

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


    $endpoint = "$Url/api/v1/statuslabels"   
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
