<#
    .SYNOPSIS
    Creates a new Snipe-IT license.

    .PARAMETER Seats
    Specifies the number of seats a license accommodates.

    .PARAMETER CompanyId
    Specifies the id of the company that the license belongs to.

    .PARAMETER ExpirationDate
    Specifies the expiration date of the license.

    .PARAMETER LicenseEmail
    Specifies the email address associated with the license.

    .PARAMETER LicenseName
    Specifies the name of the point of contact for the license.

    .PARAMETER Serial
    Specifies the serial number/license key.

    .PARAMETER Maintained
    Specifies the maintained status of the license.
    
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
    New-SnipeITLicense.ps1
    Alex Iuculano, 2020
#>

function New-SnipeITLicense
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
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Seats,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CompanyId,

        [APISubmittableAttribute()]
        [DateTime]$ExpirationDate,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$LicenseEmail,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$LicenseName,

        [APISubmittableAttribute()]
        [Bool]$Maintained,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManufacturerId,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Notes,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$OrderNumber,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Float]::MaxValue)]
        [Float]$PurchaseCost,

        [APISubmittableAttribute()]
        [DateTime]$PurchaseDate,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$PurchaseOrder,

        [APISubmittableAttribute()]
        [Bool]$Reassignable,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
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


    if (!$PSCmdlet.ShouldProcess($Name))
    {
        return
    }


    $endpoint = "$Url/api/v1/licenses"
    $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
    Invoke-SnipeITRestMethod -Method "POST" -Url $endpoint -APIKey $APIKey -Body $table
}
