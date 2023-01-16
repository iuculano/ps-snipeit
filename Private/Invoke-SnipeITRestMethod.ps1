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

    
    $prettyReponse = [PSCustomObject]@{
        Uri        = $Params.Uri
        Method     = $Params.Method.ToString().ToUpper()
        StatusCode = 0
        Message    = ""
    }

    try
    {
        $response                 = Invoke-RestMethod @Params
        $prettyReponse.StatusCode = 200
    }

    catch
    {
        $response                = $_.Exception.Response
        prettyReponse.StatusCode = [Int32]$response.StatusCode
        prettyReponse.StatusCode = $response.StatusDescription
    }

    # https://docs.microsoft.com/en-us/dotnet/api/system.management.automation.psmemberinfocollection-1
    # If status and messages both exist - we probably have a failure
    if ($response.PSObject.Properties.Item("status") -and
        $response.status                             -eq "error")
    {
        # There can be multiple error messages, so try to format them a
        # little nicer...

        # Need to be careful here - the API seems to have a handful of
        # inconsistencies or flaws in the documentation. It doesn't always
        # return what the docs say it will, and the way it returns errors
        # doesn't always align across resource types.

        # For example - creating a new user vs new hardware.

        # Some errors seem to return their messages in... 'messages'
        # and for some reason others return it in 'errors'.
        $errorProperties = foreach($wtf in @("messages", "errors"))
        {
            $response.messages.PSObject.Properties
        }

        if ($errorProperties)
        {
            $longestName    = ($errorProperties.Name | Sort-Object Length -Descending)[0].Length
            $formattedError = foreach($property in $errorProperties)
            {
                "- $($property.Name.PadRight($longestName, ' ')) : $($property.Value)`n"
            }
    
            $formattedError = "Connection succesful, but API returned an error.`n`n" + (-join $formattedError).TrimEnd("`n")
            [PSCustomObject]@{
                Status = Value
            }
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


    # Lowercase the base URL so we don't need to care about it in individual
    # functions
    $split = $Url.Split("?")
    $uri   = $split[0].ToLower()
    if ($split.Length -gt 1)
    {
        $uri += "?$($split[1])"
    }

    $irmArgs =
    @{
        Uri     = $uri
        Method  = $Method
        Headers = 
        @{
            "Accept"        = "application/json"
            "Content-Type"  = "application/json"
            "Authorization" = "Bearer $APIKey"
        }
    }

    # Conditionally add Body, this should never happen on a GET
    if ($Body -ne $null)
    {
        $irmArgs["Body"] = $Body | ConvertTo-Json
    }


    $wcArgs =
    @{
        Interval = 5000
        MaxTries = 12
    }

    # Need to call the API at least once as it'll return the total number of
    # items for GETs. At that point, need to handle paging since we can only get
    # 500 of them in one shot.
    $response = { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command @wcArgs
    

    if ($Method -eq "GET")
    {
        $uri   = [System.UriBuilder]::new($Url)
        $query = [System.Web.HttpUtility]::ParseQueryString($uri.Query)        

        # Should get a total back from the call...
        if ($response.PSObject.Properties.Item("total"))
        {
            # Stream out the first result, there will be no further API calls if
            # there isn't enough data to warrant pagination
            [PSCustomObject]$response.rows


            # Set a couple defaults, these should exist in some capacity
            # This works nicely, since this assignment won't happen again once
            # offset gets assigned a default
            if ($null -eq $query["limit"])
            {
                $query["limit"] = $response.total 
            }
            
            if ($null -eq $query["offset"])
            {
                $query["offset"] = 0
            }


            # Just use the max value (500) as the page size
            $count = [Math]::Min($response.total, $query["limit"])
            $pages = [Math]::Ceiling($count / 500)
            for ($i = 1; $i -lt $pages; $i++)
            {
                # Always advance by the max page size and update query string
                $query["offset"]  = ([Int32]::Parse($query["offset"]) + 500).ToString()
                $uri.Query        = $query.ToString()

                
                # Actually get and append additional paged data
                # This will attempt to poll for a good result
                $irmArgs["Uri"] = $uri.Uri.ToString()
                $response       = { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command @wcArgs
                

                [PSCustomObject]$response.rows
            }
        }
    }
}
