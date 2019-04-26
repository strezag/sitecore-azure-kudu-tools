function Get-BaseDownloadFolderPath {
    [CmdletBinding()]

    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog -Property @{
        RootFolder          = 'MyComputer'
        ShowNewFolderButton = $false
    }

    Write-Host "Folder Browser opened...`nSelect a location where the Sitecore Package will be generated." -ForegroundColor Green
    [void]$FolderBrowser.ShowDialog()
    Write-Host $FolderBrowser.SelectedPath -ForegroundColor Green

    if ($FolderBrowser.SelectedPath -eq "") {
        Write-Host "Operation cancelled." -ForegroundColor Red
        throw 'Operation cancelled'
    }

    $FolderBrowser.SelectedPath
}