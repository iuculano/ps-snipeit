<#
    .SYNOPSIS
    Updates one or more Snipe-IT locations.

    .PARAMETER InputObject
    Specifies an axSnipeIT.Location object returned by a previous 
    Get-SnipeITLocation call. This will be mapped to the locations's Id.

    .PARAMETER Id
    Specifies the id of the location to update.

    .PARAMETER Name
    Specifies the name of the location.

    .PARAMETER Address
    Specifies the address of the location.

    .PARAMETER Address2
    Specifies the address... 2... of the location.

    .PARAMETER State
    Specifies the state of the location.

    .PARAMETER Country
    Specifies the country of the location.

    .PARAMETER Zip
    Specifies the zip code of the location.
        
    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITLocation.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITLocation
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.Location")][Object]$InputObject,

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
        [String]$Address,

        [APISubmittableAttribute()]
        [String]$Address2,

        [APISubmittableAttribute()]
        [String]$State,

        [APISubmittableAttribute()]
        [String]$Country,

        [APISubmittableAttribute()]
        [String]$Zip,

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


            $endpoint = "$Url/api/v1/locations/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PUT" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
