 <#
    .SYNOPSIS
    Wrapper for Invoke-RestMethod that takes care of some boilerplate.

    .PARAMETER Method
    Specifies the method used for the web request. 
    
    The acceptable values for this parameter are:
    GET, PATCH, PUT, POST, DELETE

    .PARAMETER Body
    Specifies the body of the request.

    .PARAMETER Url
    Specifies the SnipeIT endpoint to which the request is sent.

    .PARAMETER APIKey
    Specifies a SnipeIT API key.

    
    .NOTES
    Invoke-SnipeITRestMethod.ps1
    Alex Iuculano, 2020
 #>


function Invoke-InternalGuardedRestMethod
{
    param
    (
        [HashTable]$Params
    )


    try
    {
        Invoke-RestMethod @Params
    }

    catch
    {
        # Seems like the actual response is HTTP 405 despite the message that comes back? 
        # $response = $_.Exception.InnerException.InnerException.Response
        $response   = $_.ErrorDetails | ConvertFrom-Json     
        if ($response.Messages -eq 429)
        {
            Write-Debug "Rate limited -> $($_.ErrorDetails)"
        }

        else
        {
            # Just bubble up any other exception
            $PSCmdlet.ThrowTerminatingError($_)
        }        
    }
 }

function Invoke-SnipeITRestMethod
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [ValidateSet("GET", "PATCH", "PUT", "POST", "DELETE")]
        [Microsoft.PowerShell.Commands.WebRequestMethod]$Method,

        [ValidateNotNull()]
        [HashTable]$Body,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$Url,

        [Parameter(Mandatory = $true)]
        [ValidateNotNullOrEmpty()]
        [String]$APIKey
    )


    $wcArgs =
    @{
        Interval = 5000
        MaxTries = 12
    }

    $irmArgs =
    @{
        Uri     = $Url
        Method  = $Method
        Headers = 
        @{
            "Accept"        = "application/json"
            "Content-Type"  = "application/json"
            "Authorization" = "Bearer $APIKey"
        }
    }

    if ($Method -eq "GET")
    {
        $uri   = [System.UriBuilder]::new($Url)
        $query = [System.Web.HttpUtility]::ParseQueryString($uri.Query)
        

        # Need to call the API at least once as it'll return the total number
        # of items. At that point, need to handle paging since we can only get
        # 500 of them in one shot.
        $data = { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command @wcArgs

        # Should get a total back from the call...
        if ($data.total)
        {
            # Stream out the first result, there will be no further API calls if
            # there isn't enough data to warrant pagination
            [PSCustomObject]$data.rows


            # Set a couple defaults, these should exist in some capacity
            # This works nicely, since this assignment won't happen again once
            # offset gets assigned a default
            $query["limit" ] ??= $data.total
            $query["offset"] ??= 0


            # Just use the max value (500) as the page size
            $count = [Math]::Min($data.total, $query["limit"])
            $pages = [Math]::Ceiling($count / 500)
            for ($i = 1; $i -lt $pages; $i++)
            {
                # Always advance by the max page size and update query string
                $query["offset"]  = ([Int32]::Parse($query["offset"]) + 500).ToString()
                $uri.Query        = $query.ToString()

                
                # Actually get and append additional paged data
                # This will attempt to poll for a good result
                $irmArgs["Uri"] = $uri.Uri.ToString()
                $data           = { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command @wcArgs
                

                [PSCustomObject]$data.rows
            }
        }
    }

    else
    {
        if ($Body)
        {
            $irmArgs["Body"] = $Body | ConvertTo-Json
        }


        { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command @wcArgs
    }
}
