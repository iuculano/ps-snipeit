<#
    .SYNOPSIS
    Remove one or more Snipe-IT custom fieldsets.

    .PARAMETER Id
    Specifies a custom fieldset id to remove.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Remove-SnipeITCustomFieldset.ps1
    Alex Iuculano, 2020
#>

function Remove-SnipeITCustomFieldset
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   ConfirmImpact           = "High",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.CustomFieldset")][Object]$InputObject,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Default")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32[]]$Id,

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


            $endpoint = "$Url/api/v1/fieldsets/$i"
            Invoke-SnipeITRestMethod -Method "DELETE" -Url $endpoint -APIKey $APIKey
        }
    }
}
