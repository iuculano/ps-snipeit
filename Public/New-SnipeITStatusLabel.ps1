<#
    .SYNOPSIS
    Creates a new Snipe-IT status label.

    .PARAMETER Name
    Specifies the name of the status label.

    .PARAMETER Type
    Specifies the status label's type.

    .PARAMETER Notes
    Specifies notes to attach to the status label.

    .PARAMETER Color
    Specifies the color of the status label.

    This value should be written as hexidecimal.

    .PARAMETER ShowInNav
    Specifies whether the status label should show in the left-side nav of the
    web GUI.

    .PARAMETER DefaultLabel
    Specifies whether the status label should be brought to the top of the list
    of available statuses.

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
        [Parameter(Mandatory = $true)]
        [ValidateSet("Deployable", "Pending", "Archived")]
        [String]$Type,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Color,

        [APISubmittableAttribute()]
        [Bool]$ShowInNav,

        [APISubmittableAttribute()]
        [Bool]$DefaultLabel,

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
