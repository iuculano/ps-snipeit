<#
    .SYNOPSIS
    Updates one or more Snipe-IT custom fieldsets.

    .PARAMETER InputObject
    Specifies an axSnipeIT.CustomFieldset object returned by a previous 
    Get-SnipeITCustomFieldset call. This will be mapped to the user's Id.

    .PARAMETER Id
    Specifies the id of the custom fieldset to update.

    .PARAMETER Name
    Specifies the name of the custom fieldset.
        
    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITCustomFieldset.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITCustomFieldset
{
    [CmdletBinding(DefaultParameterSetName = "Default",
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


            $endpoint = "$Url/api/v1/fields/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PUT" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
