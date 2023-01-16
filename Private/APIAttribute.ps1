# I don't really like the duplication, but separate classes seem neater than
# using an enum or something instead. Also PowerShell classes seem to behave
# quite annoyingly in modules...
$source = @"
public class APIQueryStringAttribute : System.Attribute
{
    public string APIParameterName      { get; set; }
    public bool   TreatAsBoundParameter { get; set; }


    public APIQueryStringAttribute(string apiParameterName, bool bindParam)
    {
        this.APIParameterName      = apiParameterName;
        this.TreatAsBoundParameter = true;
    }

    public APIQueryStringAttribute()
    {

    }
}

public class APISubmittableAttribute : System.Attribute
{
    public string APIParameterName      { get; set; }
    public bool   TreatAsBoundParameter { get; set; }


    public APISubmittableAttribute(string apiParameterName, bool bindParam)
    {
        this.APIParameterName      = apiParameterName;
        this.TreatAsBoundParameter = bindParam;
    }

    public APISubmittableAttribute()
    {

    }
}
"@

Add-Type -TypeDefinition $source
