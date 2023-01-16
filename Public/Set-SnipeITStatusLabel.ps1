<#
    .SYNOPSIS
    Updates a Snipe-IT status label.

    .PARAMETER InputObject
    Specifies an axSnipeIT.StatusLabel object returned by a previous
    Set-SnipeITStatusLabel call. This will be mapped to the status label's Id.
    
    .PARAMETER Id
    Specifies the Id number of a status label to update.

    .PARAMETER Name
    Specifies the name of the status label.

    .PARAMETER Type
    Specifies the status label's type.

    .PARAMETER Notes
    Specifies additional notes to assign to the status label.

    .PARAMETER Color
    Specifies the color of the status label on the pie chart  in the dashboard.

    This expects the color in hex code format.

    .PARAMETER ShowInNav
    Specifies whether the status label should show in the left-side nav of the
    web UI.

    .PARAMETER DefaultLabel
    Specifies whether the status label should be forced to the top of the
    available statuses list.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITStatusLabel.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITStatusLabel
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.StatusLabel")][Object]$InputObject,

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

        [APISubmittableAttribute()]
        [ValidateSet("Deployable", "Pending", "Archived")]
        [String]$Type,

        [APISubmittableAttribute()]
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


            $endpoint = "$Url/api/v1/statuslabels/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
