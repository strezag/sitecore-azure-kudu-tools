function Get-SitecoreFileBackup {
    <#
    .SYNOPSIS
        Download full App Service file contents.

    .DESCRIPTION
        This function will download all files from in a given Resource.

    .EXAMPLE
        Get-SitecoreFileBackup -ResourceSubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  -ResourceGroupName "xx-xxxxxxxxxx-XP2-SMALL-PRD1" -ResourceName "xx-xxxxxxxxxx-xp2-small-prd1-cd"

   .EXAMPLE        
        Get-SitecoreFileBackup -ID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  -Group "xx-xxxxxxxxxx-XP2-SMALL-PRD1" -Name "xx-xxxxxxxxxx-xp2-small-prd1-cd"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("ID")]
        [string]$ResourceSubscriptionId,
        [Parameter(Mandatory = $true)]
        [Alias("Group")]
        [string]$ResourceGroupName,
        [Parameter(Mandatory = $true)]
        [Alias("Name")]
        [string]$ResourceName   
    )
    
    Write-Host "`n******************************************`n  Sitecore File Backup `n******************************************`n" -ForegroundColor Blue
    Login-AzureRmAccount -SubscriptionName $ResourceSubscriptionId -ErrorAction Stop -Verbose
    
    $Base64Auth = Get-AzureSubscriptionBase64Credentials -ResourceSubscriptionId $ResourceSubscriptionId -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName
    $BaseFolderPath = Get-BaseDownloadFolderPath
    $BaseApiUrl = "https://$($ResourceName).scm.azurewebsites.net/api"
    $backupFolderName = "_$($ResourceName)_$((Get-Date).ToString('yyyyMMddhhmm'))" 
    $outfilePath = "$baseFolderPath\SitecoreBackup"
    $BaseOutputPath = "$outfilePath\$backupFolderName"
    New-Item -Path $outfilePath -Name $backupFolderName -ItemType "directory" | Out-Null

    <#### WEB.CONFIG ####>
    try {
        Get-RecurseFolders -Uri "$BaseApiUrl/vfs/site/wwwroot/" -FolderDownloadPath $BaseOutputPath -Base64Auth $Base64Auth 
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }


    Write-Host "Website for $ResourceName backup completed:`n >> $DestinationPath\ `n" -ForegroundColor Green
}

function Get-RecurseFolders {
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
  
    $excludedFolders = "_DEV", "App_Data", "App_Browsers", "sitecore", "sitecore modules", "sitecore_files", "temp", "upload", "xsl"

    foreach ($file in $FilesList) {
        if ($file.mime -eq "inode/directory") {
            if ($excludedFolders -notcontains $file.name) {
                New-Item -Path $FolderDownloadPath -Name $file.name -ItemType "directory" | Out-Null
                $folderPath = "$FolderDownloadPath\$($file.name)"

                $nextUri = "$uri$($file.name)/"

                # Call Get-FileDownload
                Get-RecurseFolders -Uri $nextUri -FolderDownloadPath $folderPath -Base64Auth $Base64Auth 
            }
        }
        else {
            if ($file.path -match "bin") {
                if ($file.mime -eq "application/x-msdownload") {
                    Write-Host "Downloading $($file.name)..." -ForegroundColor DarkGray -NoNewline
                    Invoke-WebRequest  -Uri $file.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile "$FolderDownloadPath\$($file.name)"
                    Write-Host " OK " -ForegroundColor Green
                }
            }
            else {
                Write-Host "Downloading $($file.name)..." -ForegroundColor DarkGray -NoNewline
                Invoke-WebRequest  -Uri $file.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile "$FolderDownloadPath\$($file.name)"
                Write-Host " OK " -ForegroundColor Green
            }
          
        }
    }
}