# I don't really like the duplication, but separate classes seem neater than
# using an enum or something instead. Also PowerShell classes seem to behave
# quite annoyingly in modules...
$source = @"
public class APIQueryStringAttribute : System.Attribute
{
    public string APIParameterName;


    public APIQueryStringAttribute(string apiParameterName)
    {
        this.APIParameterName = apiParameterName;
    }

    public APIQueryStringAttribute()
    {

    }
}

public class APISubmittableAttribute : System.Attribute
{
    public string APIParameterName;


    public APISubmittableAttribute(string apiParameterName)
    {
        this.APIParameterName = apiParameterName;
    }

    public APISubmittableAttribute()
    {

    }
}
"@

Add-Type -TypeDefinition $source
