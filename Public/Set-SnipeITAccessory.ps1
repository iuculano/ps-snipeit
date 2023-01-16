<#
    .SYNOPSIS
    Creates a new Snipe-IT accessory.

    .PARAMETER Name
    Specifies the name of the accessory.

    .PARAMETER Quantity
    Specifies the number of accessories in stock.
    
    .PARAMETER OrderNumber
    Specifies the order number.

    .PARAMETER PurchaseCost
    Specifies the purchase cost of the accessory.

    .PARAMETER PurchaseDate
    Specifies the purchase date of the accessory.

    .PARAMETER ModelNumber
    Specifies the model number of the accessory.
    
    .PARAMETER CategoryId
    Specifies the id of the category to assign the accessory to.   

    .PARAMETER CompanyId
    Specifies the id of the company to assign the accessory to.

    .PARAMETER Location
    Specifies the id of the location to assign the accessory to.

    .PARAMETER ManufacturerId
    Specifies the id of the manufacturer to assign the accessory to.

    .PARAMETER SupplierId
    Specifies the id of the supplier to assign the accessory to.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.


    .NOTES
    Set-SnipeITAccessory.ps1
    Alex Iuculano, 2020
#> 

function Set-SnipeITAccessory
{
    [CmdletBinding(SupportsShouldProcess = $true)]
    Param
    (
        [Parameter(Position          = 0,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "InputObject")]
        [PSTypeName("axSnipeIT.Category")][Object]$InputObject,

        [Parameter(Position          = 0,
                   Mandatory         = $true,
                   ValueFromPipeline = $true,
                   ParameterSetName  = "Default")]            
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32[]]$Id,

        [APISubmittableAttribute()]
        [ValidateNotNullOrEmpty()]
        [String]$Name,

        [APISubmittableAttribute("qty")]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$Quantity,

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
        [String]$ModelNumber,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CategoryId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$CompanyId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$LocationId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$ManufacturerId,

        [APISubmittableAttribute()]
        [ValidateRange(0, [Int32]::MaxValue)]
        [Int32]$SupplierId,

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


            $endpoint = "$Url/api/v1/accessories/$i"   
            $table    = ConvertTo-SnipeITAPI $PSCmdlet -As "Submittable"
            Invoke-SnipeITRestMethod -Method "PATCH" -Url $endpoint -APIKey $APIKey -Body $table
        }
    }
}
