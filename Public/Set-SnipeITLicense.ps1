<#
    .SYNOPSIS
    Updates one or moreSnipe-IT licenses.

     .PARAMETER InputObject
    Specifies an axSnipeIT.License object returned by a previous 
    Get-SnipeITLicense call. This will be mapped to the user's Id.

    .PARAMETER Id
    Specifies the id of the license to update.

    .PARAMETER Name
    Specifies the name of the license.

    .PARAMETER CompanyId
    Specifies the id of the company to bind to the license.

    .PARAMETER ExpirationDate
    Specifies expiration date of the license.

    .PARAMETER LicenseEmail
    Specifies the email address associated with the license.

    .PARAMETER LicenseName
    Specifies the name of the point of contact for the license.

    .PARAMETER Maintained
    Specifies the maintained status of the license.

    .PARAMETER ManufacturerId
    Specifies the id of the manufacturer to bind to the license.
    
    .PARAMETER Notes
    Specifies additional notes for the license.

    .PARAMETER OrderNumber
    Specifies the order number for the license.

    .PARAMETER PurchaseCost
    Specifies the purchase cost for the license.
    
    .PARAMETER PurchaseDate
    Specifies the purchase date for the license.
    
    .PARAMETER PurchaseOrder
    Specifies the purchase order number for the license.

    .PARAMETER Reassignable
    Specifies whether the license can be reassigned.

    .PARAMETER Seats
    Specifies the number of seats the license has available.
    
    .PARAMETER Serial
    Specifies the serial number/license key.
    
    .PARAMETER SupplierId
    Specifies the id of the license supplier.
    (Is this a company id? The docs don't seem to specify...)
    
    .PARAMETER TerminationDate
    Specifies the termination date for the license.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITLicense.ps1
    Alex Iuculano, 2020
#>

function Set-SnipeITLicense
{
    [CmdletBinding(DefaultParameterSetName = "Default",
                   SupportsShouldProcess   = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.License")][Object]$InputObject,

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
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CompanyId,

        [APISubmittableAttribute()]
        [DateTime]$ExpirationDate,

        [APISubmittableAttribute()]
        [String]$LicenseEmail,

        [APISubmittableAttribute()]
        [String]$LicenseName,

        [APISubmittableAttribute()]
        [Bool]$Maintained,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManufacturerId,

        [APISubmittableAttribute()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [String]$OrderNumber,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Float]::MaxValue)]
        [Float]$PurchaseCost,
        
        [APISubmittableAttribute()]
        [DateTime]$PurchaseDate,

        [APISubmittableAttribute()]
        [String]$PurchaseOrder,

        [APISubmittableAttribute()]
        [Bool]$Reassignable,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Seats,
        
        [APISubmittableAttribute()]
        [String]$Serial,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$SupplierId,

        [APISubmittableAttribute()]
        [DateTime]$TerminationDate,

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


            $endpoint = "$Url/api/v1/licenses/$i"
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

            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
