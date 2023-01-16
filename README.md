# PSSnipeIT
PowerShell wrapper for the Snipe-IT API.

### Usage
Set the endpoint and API key.
```
$PSDefaultParameterValues["*-SnipeIT*:Url"]    = "https://YOUR_URL.snipe-it.io"
$PSDefaultParameterValues["*-SnipeIT*:APIKey"] = "SOME_REALLY_LONG_API_KEY"
```

### Examples
Get all assets.
```
Get-SnipeITHardware
```

Get and count assets by their model.
```
Get-SnipeITHardware | Group-Object { $_.Model.Name } | Sort-Object Count
```

Change something about a user. (Protip: The 'Search' parameter is awesome)
```
Get-SnipeITUser -Search "someone@fake.net" | Set-SnipeITUser -Notes "Owns the world's cutest cat."
```

Find inconsistent data, like a License not having a Manufacturer set.
```
Get-SnipeITLicense | Where-Object { !$_.Manufacturer }
```

Immediately blow away all the assets in your database and get fired.
```
Get-SnipeITHardware | Remove-SnipeITHardware -Confirm:$false
```
