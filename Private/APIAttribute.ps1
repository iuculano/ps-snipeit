# I don't really like the duplication, but separate classes seem neater than
# using an enum or something instead. Also PowerShell classes seem to behave
# quite annoyingly in modules...
$source = @"
public class APIQueryStringAttribute : System.Attribute
{
    public string APIParameterName      { get; set; }
    public bool   TreatAsBoundParameter { get; set; }

    
    public APIQueryStringAttribute()
    {

    }

    public APIQueryStringAttribute(string apiParameterName)
    {
        this.APIParameterName      = apiParameterName;
        this.TreatAsBoundParameter = false;
    }

    // Seems like optional parameters don't work correctly in PowerShell???
    // https://github.com/PowerShell/PowerShell/issues/9684
    public APIQueryStringAttribute(string apiParameterName, bool bindParam)
    {
        this.APIParameterName      = apiParameterName;
        this.TreatAsBoundParameter = bindParam;
    }
}

public class APISubmittableAttribute : System.Attribute
{
    public string APIParameterName      { get; set; }
    public bool   TreatAsBoundParameter { get; set; }


    public APISubmittableAttribute()
    {

    }

    public APISubmittableAttribute(string apiParameterName)
    {
        this.APIParameterName      = apiParameterName;
        this.TreatAsBoundParameter = false;
    }

    public APISubmittableAttribute(string apiParameterName, bool bindParam)
    {
        this.APIParameterName      = apiParameterName;
        this.TreatAsBoundParameter = bindParam;
    }
}
"@

Add-Type -TypeDefinition $source