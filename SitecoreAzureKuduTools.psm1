<#
        .SYNOPSIS
        A collection of Windows PowerShell scripts that interact with Sitecore Azure PaaS files via Kudu

        .DESCRIPTION
        A collection of Windows PowerShell scripts that interact with Sitecore Azure PaaS files via Kudu


        .EXAMPLE 
        invoke-SomeMagic -NumberOfPeople 1 -DifficultyImpression 10

        Creates really difficult looking magic for one person

        .EXAMPLE 
        invoke-SomeMagic -NumberOfPeople 100 -DifficultyImpression 10

    #>

foreach ($functionFile in (Get-ChildItem -Path "$PSScriptRoot\Functions" -Recurse -Include "*.ps1")) {
    . $functionFile
}