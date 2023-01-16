<#
    .SYNOPSIS
    Helper function to help map data to how the SnipeIT API expects.

    .DESCRIPTION
    Walks the parameters of the calling function and parses them into a format
    that can be directly consumed by the Snipe-IT API.

    .PARAMETER PSCmdletVariable
    Specifies a cmdlet's PSCmdlet... variable.

    .PARAMETER As
    Specifies the return format.


    .NOTES
    ConvertTo-SnipeITAPI.ps1
    Alex Iuculano, 2021
#>


function ConvertTo-SnipeITAPI
{
    [CmdletBinding()]
    Param
    (
        [Parameter(Mandatory = $true)]
        [System.Management.Automation.PSCmdlet]$PSCmdletVariable,

        [Parameter(Mandatory = $true)]
        [ValidateSet("QueryString", "Submittable")]
        [String]$As
    )


    # Allllll of this is included since we're not parsing BoundParameters, so
    # filtering it down is a must
    $blacklist =
    @(
        # Our stuff
        "Type",
        
        # Built-in cmdlet parameters
        "Verbose",
        "Debug",
        "ErrorAction",
        "WarningAction",
        "InformationAction",
        "ErrorVariable",
        "WarningVariable",
        "InformationVariable",
        "OutVariable",
        "OutBuffer",
        "PipelineVariable",
        "WhatIf",
        "Confirm"
    )

    # The payload of whatever we're compiling to - this may stay as a hash
    # table, or could wind up converted to a query string
    $payload = @{ }

    # Filtered list of parameters - get rid of a ton of built-in PowerShell
    # bits that will otherwise be included
    $filteredParams = $PSCmdletVariable.MyInvocation.MyCommand.Parameters.GetEnumerator().Where({ $_.Key -notin $blacklist })
    foreach ($param in $filteredParams)
    {
        # Try to grab the value of the current parameter we're looking at
        $variable = (Get-Variable $param.Key)

        # Skip if there's no value to possibly parse except when there's a
        # nullable type set - an empty String won't trip this because
        # PowerShell will always parse a null as an empty string
        if ($null                           -eq $variable.Value -and 
            $param.Value.ParameterType.Name -ne 'Nullable`1')
        {
            continue
        }

        $variable = [PSCustomObject]@{
            Name       = $variable.Name
            Value      = $variable.Value
            Attributes = $variable.Attributes
            Type       = $param.Value.ParameterType.Name
        }


        # Look for the existence of the Attributes, anything tagged with them
        # will be doing some work with the Snipe-IT API, in some capacity
        $attribute = $variable.Attributes.Where({
            $_.TypeId.Name -contains "API$($As)Attribute"
        })

        # Any paramater without an attribute is considered to not be relevant
        # to the API and can be skipped
        if (!$attribute)
        {
            continue
        }

        # Asssigning a default value won't cause PowerShell to consider it a
        # bound parameter, so we support specifying that you want that that
        elseif (!$attribute.TreatAsBoundParameter -and
                 $variable.Name                   -notin $PSCmdletVariable.MyInvocation.BoundParameters.Keys)
        {
            continue
        }


        # If we've gotten this far, there's data to convert
        if ($attribute.APIParameterName)
        {
            # The parameter name in the attribute is considered gospel
            # No further processing is needed if it's explicitly set
            $key = $attribute.APIParameterName
        }

        else
        {
            # If a parameter name isn't specified on the attribute, make the 
            # assumption that the parameter name is a direct match. In this
            # case, the Parameter's name will be converted from CamelCase to
            # snake_case

            # Regex grabs the index of each capital letter. This is used
            # to determine where to inject the underscores for snake_case
            $string = $variable.Name | Select-String -Pattern "[A-Z]" -CaseSensitive -AllMatches
            $snake  = $variable.Name.ToLower()
            $offset = 0

            foreach ($match in $string.Matches)
            {
                # Skip the beginning, don't want to place an underscore at the start
                if ($match.Index -gt 0)
                {
                    # Need offset because we're making the string longer with each underscore
                    $snake   = $snake.Insert($match.Index + $offset, "_")
                    $offset += 1
                }
            }

            $key = $snake
        }    
    
        # If you need do any further data bending before passing it along...
        # For instance, transforming a DateTime string into a differnet format
        # that whatever underlying API expects
        switch ($variable.Type)
        {
            { @("Boolean", "SwitchParameter") -contains $_ }
            {
                # Not sure if the query string is actually case sensitive?
                # This may not be needed, but I guess it's more 'correct'
                $value = $variable.Value.ToString().ToLower()
            }
        
            "DateTime"
            {
                # Snipe-IT expects hyphenated dates
                $value = ($variable.Value.ToShortDateString()).Replace("/", "-")
            }

            "String"
            {
                # Consider empty strings null, which effectively unsets
                # a value in the Snipe-IT API
                if ([String]::IsNullOrEmpty($variable.Value))
                {
                    $value = $null
                }

                else
                {
                    $value = $variable.Value
                }
            }

            default
            {
                # No need to do any adaptation
                $value = $variable.Value
            }
        }


        # Almost done...
        $payload[$key] = $value
    }


    # At this point, we're done building the payload and just need to
    # determine whether to convert it to a query string, or leave it
    # as a hash table for the body
    switch ($As)
    {
        "QueryString"
        {
            # My OCD hurts and this might be a little overkill, but
            # adapt 'order' params into their SnipeIT short form

            # Also, it's used all over the place, which is why I implement it
            # here rather than in the calling function
            switch ($payload["order"])
            {
                "Ascending"
                {
                    $payload["order"] = "asc"
                }

                "Descending"
                {
                    $payload["order"] = "desc"
                }
            }


            # Return just the query string, don't need the entire URI
            if ($payload.Count)
            {
                $query = [System.Web.HttpUtility]::ParseQueryString("")
                foreach ($key in $payload.Keys)
                {
                    # Skip nulls, literally useless in the query string
                    # but have meaning in the body of a request
                    if ($null -ne $payload[$key])
                    {
                        $query[$key] = $payload[$key]
                    }
                }

                "?$($query.ToString())"
                return
            }

            else
            {
                # Not sure if this better than nothing?
                return [String]::Empty
            }
        }

        "Submittable"
        {
            $payload
        }
    }
}
