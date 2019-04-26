function Get-SitecoreSupportPackage {

    <#
    .SYNOPSIS
        Remotely generate a Sitecore Support Package

    .DESCRIPTION
        This function will download and zip files defined for Sitecore Support Packages: https://kb.sitecore.net/articles/406145
        > \App_Config\*
        > \Logs\*
        > eventlog.xml
        > Global.asax
        > license.xml
        > sitecore.version.xml
        > Web.config

    .EXAMPLE
        Get-SitecoreSupportPackage -ResourceSubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  -ResourceGroupName "xx-xxxxxxxxxx-XP2-SMALL-PRD1" -ResourceName "xx-xxxxxxxxxx-xp2-small-prd1-cd" -LogDaysBack 1
   
    .EXAMPLE        
        Get-SitecoreSupportPackage -ID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"  -Group "xx-xxxxxxxxxx-XP2-SMALL-PRD1" -Name "xx-xxxxxxxxxx-xp2-small-prd1-cd" -LogDays 1
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
        [string]$ResourceName,
        [Parameter(Mandatory = $true)]
        [Alias("LogDays")]
        [int]$LogDaysBack
    )

    Write-Host "`n******************************************`n  Sitecore Package Generator`n******************************************`n" -ForegroundColor Blue
    Login-AzureRmAccount -SubscriptionName $ResourceSubscriptionId -ErrorAction Stop -Verbose
    $Base64Auth = Get-AzureSubscriptionBase64Credentials -ResourceSubscriptionId $ResourceSubscriptionId -ResourceGroupName $ResourceGroupName -ResourceName $ResourceName
    $BaseFolderPath = Get-BaseDownloadFolderPath
    $BaseApiUrl = "https://$($ResourceName).scm.azurewebsites.net/api"
    $SupportPackageName = "scsupport_$($ResourceName)_$((Get-Date).ToString('yyyyMMddhhmm'))" 
    $OutFilePath = "$BaseFolderPath\SKPT-SitecoreSupportPackages"
    $BaseOutputPath = "$OutFilePath\$SupportPackageName"
 
    Write-Host "`n*** PowerShell SSPG Running...  ***" -ForegroundColor Blue

    <#### LOGS ####>
    $logDir = New-Item -Path $BaseOutputPath -Name "Logs" -ItemType "directory"
    try {
        Write-Host " > Downloading Application Insight logs..." -ForegroundColor DarkGray -NoNewline
        $kuduLogs = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/LogFiles/Application/" -Headers @{Authorization = ("{0}" -f $Base64Auth) } -ErrorAction SilentlyContinue
       
        foreach ($log in $kuduLogs) {
            $dateObj = [datetime]($log.mtime)
            if ($dateObj -gt [datetime]::Today.AddDays(-$LogDaysBack)) {
                $logName = $log.mtime -replace "\-|\:|\+", ""
                $output = "$logDir/$($logName).txt"
                Invoke-WebRequest  -Uri $log.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile $output
            }
        }
        Write-Host " OK " -ForegroundColor Green
    }
    catch { 
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
   
    try {
        Write-Host " > Downloading Sitecore logs..." -ForegroundColor DarkGray -NoNewline
        $scLogs = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/site/wwwroot/App_Data/logs/" -Headers @{Authorization = ("{0}" -f "$Base64Auth") } -ErrorAction SilentlyContinue
        foreach ($log in $scLogs) {
            if ($log.mime -eq "inode/directory") {
                $innerAzureLogs = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/site/wwwroot/App_Data/logs/$($log.name)/" -Headers @{Authorization = ("{0}" -f $Base64Auth) } -ErrorAction SilentlyContinue

                foreach ($innerAzureLog in  $innerAzureLogs) {
                    if ($innerAzureLog.mime -eq "text/plain") {
                        $dateObj = [datetime]($innerAzureLog.mtime)
                        if ($dateObj -gt [datetime]::Today.AddDays(-$LogDaysBack)) {
                            $output = "$logDir/$($innerAzureLog.name)"
                            Invoke-WebRequest  -Uri $innerAzureLog.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile $output
                        }
                    }
                }
            }
            else {
                $dateObj = [datetime]($log.mtime)
                if ($dateObj -gt [datetime]::Today.AddDays(-$LogDaysBack)) {
                    $output = "$logDir/$($log.name)"
                    Invoke-WebRequest  -Uri $log.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile $output -ErrorAction SilentlyContinue
                }
       
            }
        }
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
    

    <#### WEB.CONFIG ####>
    try {
        $kuduRootFiles = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/site/wwwroot/" -Headers @{Authorization = ("{0}" -f $Base64Auth) } -ErrorAction SilentlyContinue
        $webConfig = $kuduRootFiles | Where-Object { $_.name -eq "Web.config" }
        Write-Host " > Downloading Web.config..." -ForegroundColor DarkGray -NoNewline
        Invoke-WebRequest  -Uri $webConfig.href -Headers @{Authorization = ("{0}" -f $Base64Auth) }  -OutFile "$BaseOutputPath/Web.config"
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
  

    <#### GLOBAL ASAX ####>
    try {
        $globalAsax = $kuduRootFiles | Where-Object { $_.name -eq "Global.asax" }
        Write-Host " > Downloading Global.asax.config..." -ForegroundColor DarkGray -NoNewline
        Invoke-WebRequest  -Uri $globalAsax.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile "$BaseOutputPath/Global.asax"
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
 

    <#### APP_CONFIG ####>
    try {
        Write-Host " > Downloading App_Config folder..." -ForegroundColor DarkGray -NoNewline
        New-Item -Path $BaseOutputPath -Name "App_Config" -ItemType "directory" | Out-Null
        $outAppConfigPath = "$BaseOutputPath\App_Config" 
        Get-NestedFoldersFiles -Uri "$BaseApiUrl/vfs/site/wwwroot/App_Config/" -FolderDownloadPath $outAppConfigPath -Base64Auth $Base64Auth 
        Write-Host " OK " -ForegroundColor Green
        Write-Host " > Removing sensitive information from ConnectionStrings.config..." -ForegroundColor DarkGray -NoNewline
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }

    <#### SITECORE.VERSION.XML ####>
    try {
        $kuduRootFiles = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/site/wwwroot/sitecore/shell/" -Headers @{Authorization = ("{0}" -f $Base64Auth) }
        $webConfig = $kuduRootFiles | Where-Object { $_.name -eq "sitecore.version.xml" }
        Write-Host " > Downloading sitecore.version.xml..." -ForegroundColor DarkGray -NoNewline
        Invoke-WebRequest  -Uri $webConfig.href -Headers @{Authorization = ("{0}" -f $Base64Auth) }  -OutFile "$BaseOutputPath/sitecore.version.xml"
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }

    <#### LICENSE.XML ####>
    try {
        Write-Host " > Downloading license.xml..." -ForegroundColor DarkGray -NoNewline
        $kuduAppDataFiles = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/site/wwwroot/App_Data/" -Headers @{Authorization = ("{0}" -f $Base64Auth) } 
        $licenseXML = $kuduAppDataFiles | Where-Object { $_.name -eq "license.xml" }
        Invoke-WebRequest  -Uri $licenseXML.href -Headers @{Authorization = ("{0}" -f $Base64Auth) }  -OutFile "$BaseOutputPath/license.xml"
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }

    <#### EVENTLOG.XML ####>
    try {
        Write-Host " > Downloading eventlog.xml..." -ForegroundColor DarkGray -NoNewline
        $eventLog = Invoke-RestMethod -Uri "$BaseApiUrl/vfs/LogFiles/" -Headers @{Authorization = ("{0}" -f $Base64Auth) } -ErrorAction SilentlyContinue
        $eventLogXml = $eventLog | Where-Object { $_.name -eq "eventlog.xml" }
        Invoke-WebRequest  -Uri $eventLogXml.href -Headers @{Authorization = ("{0}" -f $Base64Auth) }  -OutFile "$BaseOutputPath/eventlog.xml"
        Write-Host " OK " -ForegroundColor Green
    }
    catch { 
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }


    # Zip the folder
    $SupportPackageZipName = "$($SupportPackageName).zip" 
    
    try {
        Write-Host "`n > Creating $SupportPackageZipName..." -ForegroundColor DarkGray -NoNewline
        Compress-Archive -Path $BaseOutputPath -DestinationPath "$BaseFolderPath\$SupportPackageZipName"
        Write-Host " OK " -ForegroundColor Green
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
    
    
    # Clean up
    try {
        Write-Host " > Cleaning up..." -ForegroundColor DarkGray -NoNewline
        Get-ChildItem -Path "$BaseOutputPath\" -File -Recurse | Remove-Item
        Get-ChildItem -Path "$OutFilePath\" -Directory -Recurse | Remove-Item -Recurse -Force
        Write-Host " OK `n " -ForegroundColor Green
    }
    catch {
        Write-Host " X `n " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
    
    Write-Host "Sitecore Support Package for $ResourceName generated:`n >> $BaseOutputPath `n" -ForegroundColor Green

}