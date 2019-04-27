foreach ($functionFile in (Get-ChildItem -Path "$PSScriptRoot\Functions" -Recurse -Include "*.ps1")) {
    . $functionFile
}