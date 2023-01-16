<#
    .SYNOPSIS
    Gets one or more Snipe-IT custom fieldsets.

    .PARAMETER Id
    Restrict results to a specified fieldset id.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Get-SnipeITCustomFieldset.ps1
    Alex Iuculano, 2020
#>

function Get-SnipeITCustomFieldset
{
    [CmdletBinding(DefaultParameterSetName = "Default")]
    Param
    (
        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName = "Id")]
        [ValidateRange(1, [Int32]::MaxValue)]
        [Int32]$Id,

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
                $endpoint = "$Url/api/v1/fields"
                break
            }
    
            "Id"
            {
                $endpoint = "$Url/api/v1/fields/$Id"
                break
            }
        }
    

        Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ConvertFrom-SnipeITAPI -Type "axSnipeIT.CustomFieldset"
    }
}
