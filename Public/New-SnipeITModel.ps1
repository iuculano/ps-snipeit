<#
    .SYNOPSIS
    Creates a new Snipe-IT model.

    .PARAMETER Name
    Specifies the name of the model.

    .PARAMETER ModelNumber
    Specifies the model's model number.

    .PARAMETER CategoryId
    Specifies the id of the category the model should fall under.

    .PARAMETER ManufacturerId
    Specifies the id of the manufacturer to assign to the model.

    .PARAMETER EndOfLife
    Specifies the number of months until the model is considered
    end of life.

    .PARAMETER FieldsetId
    Specifies the id of an existing custom fieldset.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    New-SnipeITModel.ps1
    Alex Iuculano, 2021
#>

function New-SnipeITModel
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
        [String]$ModelNumber,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CategoryId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManufacturerId,

        [APISubmittableAttribute("eol")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$EndOfLife,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$FieldsetId,

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


    $endpoint = "$Url/api/v1/models"   
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
