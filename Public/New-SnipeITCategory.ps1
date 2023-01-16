<#
    .SYNOPSIS
    Creates a new Snipe-IT category.

    .PARAMETER Name
    Specifies the name of the category.

    .PARAMETER CategoryType
    Specifies the category type.

    .PARAMETER UseDefaultEula
    I have no idea currently. API docs have a blank description. :(

    .PARAMETER RequireAcceptance
    Specifies whether to require a user to accept the terms.

    .PARAMETER CheckInEmail
    Specifies whether to send the user the EULA and acceptance email
    when the item is checked in.
        
    .PARAMETER CustomFields
    Specifies a hash table of custom fields to assign to the asset.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITCategory.ps1
    Alex Iuculano, 2020
#>
 
 function New-SnipeITCategory
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
        [ValidateSet("Asset", "Accessory", "Consumable", "Component")]
        [String]$CategoryType,

        [APISubmittableAttribute()]
        [Bool]$UseDefaultEula,

        [APISubmittableAttribute()]
        [Bool]$RequireAcceptance,

        [APISubmittableAttribute()]
        [Bool]$CheckinEmail,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )
    

    if (!$PSCmdlet.ShouldProcess($Name))
    {
        continue
    }
    

    $endpoint = "$Url/api/v1/categories"   
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
