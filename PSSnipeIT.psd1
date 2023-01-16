#
# Module manifest for module 'PSSnipeIT'
#
# Generated by: Alex Iuculano
#
# Generated on: 10/11/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule        = 'PSSnipeIT.psm1'

# Version number of this module.
ModuleVersion     = '0.0.1'

# ID used to uniquely identify this module
GUID              = '23b00937-79ab-4cb9-9e62-2e3bb8172800'

# Author of this module
Author            = 'Alex Iuculano'

# Company or vendor of this module
CompanyName       = ''

# Copyright statement for this module
Copyright         = '(c) Alex Iuculano. All rights reserved.'

# Description of the functionality provided by this module
Description       = 'Snipe-IT API wrapper.'

# Minimum version of the PowerShell engine required by this module
PowerShellVersion = '5.1'

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = 
@(
    "Get-SnipeITAccessory",
    "Get-SnipeITHardware",
    "Get-SnipeITCategory",
    "Get-SnipeITCompany",
    "Get-SnipeITComponent",
    "Get-SnipeITCustomFieldset",
    "Get-SnipeITLicense",
    "Get-SnipeITLocation",
    "Get-SnipeITMaintenance",
    "Get-SnipeITManufacturer",
    "Get-SnipeITModel",
    "Get-SnipeITStatusLabel",
    "Get-SnipeITUser",
    "New-SnipeITAccessory",
    "New-SnipeITHardware",
    "New-SnipeITCategory",
    "New-SnipeITCompany",
    "New-SnipeITComponent",
    "New-SnipeITConsumable",
    "New-SnipeITCustomFieldset",
    "New-SnipeITLicense",
    "New-SnipeITLocation",
    "New-SnipeITMaintenance",
    "New-SnipeITManufacturer",
    "New-SnipeITModel",
    "New-SnipeITStatusLabel",
    "New-SnipeITUser",
    "Remove-SnipeITHardware",
    "Remove-SnipeITCategory",
    "Remove-SnipeITCompany",
    "Remove-SnipeITCustomFieldset",
    "Remove-SnipeITLicense",
    "Remove-SnipeITMaintenance",
    "Remove-SnipeITManufacturer",
    "Remove-SnipeITModel",
    "Remove-SnipeITStatusLabel",
    "Remove-SnipeITUser",
    "Set-SnipeITHardware",
    "Set-SnipeITHardwareAssignment",
    "Set-SnipeITCategory",
    "Set-SnipeITCompany",
    "Set-SnipeITCustomFieldset",
    "Set-SnipeITLcation",
    "Set-SnipeITLicense",
    "Set-SnipeITManufacturer",
    "Set-SnipeITModel",
    "Set-SnipeITStatusLabel",
    "Set-SnipeITUser"
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport   = @()

# Variables to export from this module
VariablesToExport = @()

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport   = @()

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        # ReleaseNotes = ''

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}
