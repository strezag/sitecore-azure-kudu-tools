function Get-NestedFoldersFiles {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$Uri,
      
        [Parameter(Mandatory = $true)]
        [string]$FolderDownloadPath,

        [Parameter(Mandatory = $true)]
        [string]$Base64Auth     
    )
  
    $FilesList = Invoke-RestMethod -Uri $Uri -Headers @{Authorization = ("{0}" -f $Base64Auth) }   
  
    foreach ($file in $FilesList) {
        if ($file.mime -eq "inode/directory") {

            New-Item -Path $FolderDownloadPath -Name $file.name -ItemType "directory" | Out-Null
            $folderPath = "$FolderDownloadPath\$($file.name)"

            $nextUri = "$uri$($file.name)/"

            # Call Get-FileDownload
            Get-NestedFoldersFiles -Uri $nextUri -FolderDownloadPath $folderPath -Base64Auth $Base64Auth 
        }
        elseif ($file.mime -eq "application/octet-stream") {
            Invoke-WebRequest  -Uri $file.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile "$FolderDownloadPath\$($file.name)"
            if ($file.name -eq "ConnectionStrings.config") {
                $xml = [xml](Get-Content "$FolderDownloadPath\$($file.name)")               
                $xml.SelectNodes("//connectionStrings/add") | ForEach-Object { 
                    $_.Attributes[1].Value = ""
                }
                $xml.Save("$FolderDownloadPath\$($file.name)")
            }
        }
    }
}
