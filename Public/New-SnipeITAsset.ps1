<#
    .SYNOPSIS
    Creates a new Snipe-IT asset.

    .PARAMETER AssetTag
    Specifies the asset tag of the asset.

    .PARAMETER StatusId
    Specifies the id of the status to assign to the asset.

    .PARAMETER ModelId
    Specifies the id of the model to assign to the asset.

    .PARAMETER Name
    Specifies the name of the asset.

    .PARAMETER CustomFields
    Specifies a hash table of custom fields to assign to the asset.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITAsset.ps1
    Alex Iuculano, 2020
#> 

function New-SnipeITAsset
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$AssetTag,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$StatusId,

        [APISubmittableAttribute()]
        [Parameter(Mandatory = $true)]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ModelId,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [HashTable]$CustomFields,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )


    if (!$PSCmdlet.ShouldProcess($AssetTag))
    {
        return
    }


    $endpoint = "$Url/api/v1/hardware"
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    if ($CustomFields)
    {
        # Append custom fields to the body - beware the naming, this is NOT 
        # internally compensated for as it stands
        foreach ($custom in $CustomFields.GetEnumerator())
        {
            $table[$custom.Key] = $custom.Value
        }
    }
    
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
