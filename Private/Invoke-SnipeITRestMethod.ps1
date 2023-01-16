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

 class SnipeITException : Exception 
 {
    SnipeITException($Message) : base($Message)
    {

    }
}


function Invoke-InternalGuardedRestMethod
{
    param
    (
        [HashTable]$Params
    )

    
    try
    {
        $response = Invoke-WebRequest @Params
        $response = $response | ConvertFrom-Json -AsHashtable
    }

    catch
    {
        # This is definitely a breaking change with PowerShell 5
        # From PS6 and up, this will return the body
        $response = $_.ErrorDetails.Message | ConvertFrom-Json -AsHashtable

        # This is the most harmless exception, we can just return false here
        # to signify that we need to retry the request
        if ([Int32]$_.Exception.Response.StatusCode -eq 429)
        {
            Write-Debug "Rate limited -> $($_.ErrorDetails)"
            return $false
        }
    }


    # This seems to be the intended way for the API to return errors...
    # https://snipe-it.readme.io/reference/api-overview
    # It'll like like:
    # {
    #     "status": "error",
    #     "messages": {
    #         "status_id": [
    #             "The selected status id is invalid."
    #         ]
    #     }
    #   }
    # }    
    $isErrorNormal = $response["status"] -eq "error" -and $response["messages"]
    if ($isErrorNormal)
    {
        $errorReasons = $response.messages
    }

    # But it can also generate errors in a different format because who knows
    # {
    #     "message": "The given data was invalid.",
    #     "errors": {
    #         "password": [
    #             "The password must be at least 8 characters."
    #         ]
    #     }
    # }
    $isErrorWonky  = $response["message"] -and $response["errors"]
    if ($isErrorWonky)
    {
        $errorReasons = $response.errors
    }

    if ($isErrorNormal -or $isErrorWonky)
    {
        # There can be multiple error messages, so try to format them a
        # little nicer...
        # This will build up a single string to act as a cohesive error

        # Iterate over the keys in the messages first, since they pertain
        # to the parameter that's in error
        $lines = @()
        foreach($parameter in $errorReasons.GetEnumerator())
        {
            # ConvertFrom-Json has parsed this has a PSCustomObject, need
            # to jump through some hoops to split it into keys and values
            foreach($reason in $parameter.Value)
            {
                $lines += "$reason"
            }

            $lines += "`n"
        }

        $errorMessage = ($lines | Out-String).Trim()
        if ($errorMessage)
        {
            $exception = [SnipeITException]::New($errorMessage)
            $record    = [Management.Automation.ErrorRecord]::New($exception, "SnipeITException", [Management.Automation.ErrorCategory]::InvalidOperation, $response)
            $PSCmdlet.ThrowTerminatingError($record)
        }
    }

    $response
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


    $irmArgs =
    @{
        Uri     = $Url
        Method  = $Method
        Headers = 
        @{
            "Accept"        = "application/json"
            "Content-Type"  = "application/json; charset=utf-8"
            "Authorization" = "Bearer $APIKey"
        }

        ContentType = "application/json; charset=utf-8"
    }

    # Conditionally add Body, this should never happen on a GET
    if ($Body -ne $null)
    {
        $irmArgs["Body"] = $Body | ConvertTo-Json
    }

    # Need to call the API at least once as it'll return the total number of
    # items for GETs. At that point, need to handle paging since we can only get
    # 500 of them in one shot.
    $response = $null
    $response = { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command -Interval 5000 -MaxTries 6
    if ($null -eq $response)
    {
        return
    }


    if ($Method -eq "GET")
    {
        # API call was succesful and it returned some data
        if ($response["total"] -and $response.total -gt 0)
        {
            # Stream out the first result, there will be no further API calls if
            # there isn't enough data to warrant pagination
            [PSCustomObject]$response.rows


            # Set a couple defaults, these should exist in some capacity
            # This works nicely, since this assignment won't happen again once
            # offset gets assigned a default
            $uri   = [System.UriBuilder]::new($Url)
            $query = [System.Web.HttpUtility]::ParseQueryString($uri.Query)    
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
                $query["offset"] = ([Int32]::Parse($query["offset"]) + 500).ToString()
                $uri.Query       = $query.ToString()

                
                # Actually get and append additional paged data
                # This will attempt to poll for a good result
                $irmArgs["Uri"] = $uri.Uri.ToString()
                $response       = { Invoke-InternalGuardedRestMethod $irmArgs } | Wait-Command @wcArgs
                

                [PSCustomObject]$response.rows
            }
        }

        # API call was succesful, but didn't return any data
        elseif (!$response["total"] -and $response.Count -gt 0)
        {
            [PSCustomObject]$response
        }
    }

    else
    {
        [PSCustomObject]$response
    }
}
