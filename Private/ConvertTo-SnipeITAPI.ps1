<#
    .SYNOPSIS
    Helper function to help map data to how the SnipeIT API expects.

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


    $boundParams = $PSCmdletVariable.MyInvocation.BoundParameters
    $query       = [System.Web.HttpUtility]::ParseQueryString("")

    foreach ($param in $boundParams.GetEnumerator())
    {
        # Look for the existence of the Attributes, anything tagged with them
        # will be doing some work with the Snipe-IT API, in some capacity
        $variable  = (Get-Variable $param.Key)
        $attribute = $variable.Attributes | Where-Object { 
            $_.TypeId.Name -contains "API$($As)Attribute"
        }

        # Just bail early if there's no attributes defined
        if (!$attribute)
        {
            continue
        }



        if ($attribute.APIParameterName)
        {
            # Direct specifications in the attribute are considered gospel
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
        switch ($variable.Value.GetType().Name)
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
        
            default
            {
                # No need to do any adaptation
                $value = $variable.Value
            }
        }


        # Almost done...
        $query[$key] = $value
    }


    # I thought about implicitly deciding based on the attribute, but I think
    # this is a little safer/better design...
    switch ($As)
    {
        "QueryString"
        {
            # My OCD hurts and this might be a little overkill, but
            # adapt 'order' params into their SnipeIT short form

            # Also, it's used all over the place, which is why I implement it
            # here rather than in the calling function
            switch ($query["order"])
            {
                "Ascending"
                {
                    $query["order"] = "asc"
                }

                "Descending"
                {
                    $query["order"] = "desc"
                }
            }


            # Return just the query string, don't need the entire URI
            if ($query.Count)
            {
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
            # Build a hash table to pass along as the Body to a REST method call

            # It seems a bit odd that I'm converting a query to a hash table
            # instead of the other way around?
            $table = @{ }
            foreach ($value in $query.GetEnumerator())
            {
                $table[$value] = $query[$value]
            }

            $table
        }
    }
}
