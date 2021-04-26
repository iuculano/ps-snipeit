<#
    .SYNOPSIS
    Helper function to help map data returned by the SnipeIT API to beautiful
    CamelCase.

    .PARAMETER Node
    Specifies an object to start at.

    .PARAMETER Type
    Specifies the type to assign to the resulting object.


    .NOTES
    This is honestly pretty slow, and in my testing, basically doubles the time
    that it takes for returning data from the API. This will become worse as the
    ammount of data you're returning grows.

    For 1500 items, it costs about 5 seconds on my machine.
    
    If you're using the pipeline, this is less noticible since it gets spread
    across the lifetime of the operation, rather than you sitting and waiting
    for the function to return.

    You can run this in parallel by doing something like this on a  Get-SnipeIT* 
    call if you really want. In my limited testing, this significantly improves 
    performance. Note that this will likely affect ordering on big batches of data, 
    if that matters.

    For example:
    Invoke-SnipeITRestMethod -Method "GET" -Url $endpoint -APIKey $APIKey | ForEach-Object -Parallel `
    {
        . ".\Private\ConvertFrom-SnipeITAPI.ps1"
        ConvertFrom-SnipeITAPI $_ -Type "axSnipeIT.Accessory"
    }
    
    If you're really trying to cut down overhead, you can try sending entire arrays 
    down the pipeline instead of individual objects in the Invoke-SnipeITRestMethod 
    function.

    This somewhat breaks the "streaming" nature of the pipeline, but helps performance.


    ConvertFrom-SnipeITAPI.ps1
    Alex Iuculano, 2021
#>


function ConvertFrom-SnipeITAPI
{
    Param
    (
        [Parameter(Mandatory         = $true,
                   ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [Object[]]$Node,

        [ValidateNotNullOrEmpty()]
        [String]$Type
    )


    Process
    {
        foreach ($n in $Node)
        {
            $object     = @{ }
            $properties = $n.PSObject.Properties
        
            foreach ($property in $properties)
            {
                # CamelCase the property name...
                $name   = ""
                $splits = $property.Name.Split("_")
                foreach ($split in $splits)
                {
                    $name += [Char]::ToUpper($split[0]) + $split.Substring(1)
                }
        
        
                # If it's a value, just assign it
                if ($property.Value?.GetType().Name -ne "PSCustomObject")
                {
                    $object[$name] = $property.Value
                }
        
                # If it's an object, recurse to walk it and return its converted form
                else
                {
                    $value         = ConvertFrom-SnipeITAPI -Node $property.Value -Type $Type
                    $object[$name] = [PSCustomObject]$value
                }
            }
            
            
            $object = [PSCustomObject]$object
            $object.PSObject.TypeNames.Insert(0, $Type)
            $object
        }
    }
}
