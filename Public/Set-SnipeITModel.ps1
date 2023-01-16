<#
    .SYNOPSIS
    Updates one or more Snipe-IT models.

    .PARAMETER InputObject
    Specifies an axSnipeIT.Model object returned by a previous 
    Get-SnipeITModel call. This will be mapped to the models's Id.

    .PARAMETER Id
    Specifies the id of the model to update.

    .PARAMETER Name
    Specifies the name of the model.

    .PARAMETER ModelNumber
    Specifies the model's model number.

    .PARAMETER FieldsetId
    Specifies the id of an existing custom fieldset.

    .PARAMETER ManufacturerId
    Specifies the id of the manufacturer to assign to the model.

    .PARAMETER CategoryId
    Specifies the id of the category the model should fall under.

    .PARAMETER Notes
    Specifies additional notes to add to the model.

    .PARAMETER Requestable
    Specifies whether the asset can be requested by users.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITModel.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITModel
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.Model")][Object]$InputObject,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Default")]            
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32[]]$Id,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APISubmittableAttribute()]
        [String]$ModelNumber,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$FieldsetId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManufacturerId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CategoryId,

        [APISubmittableAttribute()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [Bool]$Requestable,

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
                $identity = $Id
                break
            }

            "InputObject"
            {
                $identity = $InputObject.Id
                break
            }
        }


        foreach ($i in $identity)
        {
            if (!$PSCmdlet.ShouldProcess($i))
            {
                return
            }


            $endpoint = "$Url/api/v1/models/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
