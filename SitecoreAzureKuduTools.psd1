﻿#
# Module manifest for module 'SitecoreAzureKuduTools'
#
# Generated by: Gabriel Strza
#
# Generated on: 04-25-2019
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'SitecoreAzureKuduTools.psm1'

# Version number of this module.
ModuleVersion = '1.0.0'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'b53a5852-dfaf-4fd7-8960-83f8cd054156'

# Author of this module
Author = 'Gabriel Streza'

# Company or vendor of this module
CompanyName = 'streza.dev'

# Copyright statement for this module
Copyright = '(c) 2019 Gabriel Streza. All rights reserved.'

# Description of the functionality provided by this module
Description = 'A collection of commands to obtain information from Sitecore instances on Azure PaaS via Kudu.'

# Minimum version of the Windows PowerShell engine required by this module
PowerShellVersion = '5.0'

# Name of the Windows PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the Windows PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
DotNetFrameworkVersion = '4.5.2'

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
CLRVersion = '4.0'

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
RequiredModules = @(
    @{ModuleName = 'AzureRM'; ModuleVersion = '6.3.0'}
)

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
#ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Get-SitecoreFileBackup',
    'Get-SitecoreSupportPackage',
    'Invoke-SitecoreThumbprintValidation'
)

# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
#VariablesToExport = '*'

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
# FileList = @(
#     # NOTE: This section should reference non-PowerShell files. 
#     # Things like json or xml documents, or other file resources that should be packaged with the module.
#     'Resources\Templates\TemplateResource.json'
# )

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    # NOTE: Private Data can be used to store constants for access within the module.
    # See Get-ModulePrivateDataConstant for an example.
    # Constants = @{
    #     ExampleStringConst = 'Test'
    #     ExampleIntConst = 1
    # }

    # NOTE: Private Data can also be used as a writeable cache section.
    # See the Get-ModuleCacheItems and Set-ModuleCacheItems files for examples.
    Cache = @{}

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        Tags = @('Sitecore', 'Azure', 'PaaS', 'Kudu', 'Support')

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'Initial 1.0.0 release.
        
        Includes three functions:
            > Get-SitecoreFileBackup
            > Get-SitecoreSupportPackage
            > Invoke-SitecoreThumbprintValidation
        '

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

