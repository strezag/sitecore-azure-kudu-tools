function Invoke-SitecoreThumbprintValidation {
    <#
    .SYNOPSIS
        Verify Certificate Thumbprints across Sitecore Azure PaaS using Kudu   

    .DESCRIPTION
        This function will download ConnectionStrings.config and AppSettings.config files from all App Services in a given Resource Group, then display any certificate thumbprints discrepencies.

    .EXAMPLE
        Invoke-SitecoreThumbprintValidation -ResourceSubscriptionId "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -ResourceGroupName "xx-xxxxxxxxxx-XP2-SMALL-PRD1"

   .EXAMPLE
        Invoke-SitecoreThumbprintValidation -ID "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" -Group "xx-xxxxxxxxxx-XP2-SMALL-PRD1"
    #>

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [Alias("ID")]
        [string]$ResourceSubscriptionId,

        [Parameter(Mandatory = $true)]
        [Alias("Group")]
        [string]$ResourceGroupName

    )
    Write-Host "`n***********************************************`n  Thumbprint Verification `n***********************************************`n" -ForegroundColor Blue
    Login-AzureRmAccount -SubscriptionName $ResourceSubscriptionId -ErrorAction Stop -Verbose
    $BaseFolderPath = Get-BaseDownloadFolderPath
    Get-FilesFromAzure -ResourceSubscriptionId $ResourceSubscriptionId -ResourceGroupName $ResourceGroupName -OutputPath $baseFolderPath

}

function Get-FilesFromAzure {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$ResourceSubscriptionId,

        [Parameter(Mandatory = $true)]
        [string]$ResourceGroupName,

        [Parameter(Mandatory = $true)]
        [string]$OutputPath
    )

    $ResourcePrefixName = $($ResourceGroupName.ToLower())
    $currentDate = $((Get-Date).ToString('yyyyMMddhhmm'))
    $apps = "cd", "cm", "ma-ops", "ma-rep", "prc", "rep", "xc-collect", "xc-refdata", "xc-search"
    
    foreach ($app in $apps) {
        $base64AuthInfo = Get-AzureSubscriptionBase64Credentials -ResourceSubscriptionId $ResourceSubscriptionId -ResourceGroupName $ResourceGroupName -ResourceName "$($ResourcePrefixName)-$($app)"
        # $publishingCredentials = "$($ResourcePrefixName)-$($app)/publishingcredentials"
        # $creds = Invoke-AzureRmResourceAction -ResourceGroupName $ResourceGroupName -ResourceType Microsoft.Web/sites/config -ResourceName $publishingCredentials -Action list -ApiVersion 2015-08-01 -Force -ErrorAction Stop
        # $username = $creds.Properties.PublishingUserName
        # $password = $creds.Properties.PublishingPassword
        # $base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $username, $password)))   
        $apiBaseUrl = "https://$($ResourcePrefixName)-$app.scm.azurewebsites.net/api"
        $supportPackageName = "$($ResourcePrefixName)-$($app)_$((Get-Date).ToString('yyyyMMddhhmm'))" 
        $outfileRootPath = "$OutputPath\AzurePaaS_Thumbprints"
        If (!(Test-Path $outfileRootPath)) {
            New-Item -ItemType Directory -Force -Path $outfileRootPath | Out-Null
        }

        $downloadFolderName = "$($ResourceGroupName)_$currentDate"
        $outFileBasePath = "$outfileRootPath\$downloadFolderName" 
        If (!(Test-Path $outFileBasePath)) {
            New-Item -Path $outfileRootPath -Name $downloadFolderName -ItemType "directory" | Out-Null
        }

        $outTempPath = "$outfileRootPath\$downloadFolderName"
        New-Item -Path $outTempPath -Name $supportPackageName -ItemType "directory" -Force | Out-Null

        Write-Host "`n[" -NoNewline
        Write-Host "Certificate Thumbprint Verification" -ForegroundColor Blue -NoNewline
        Write-Host "]: " -NoNewline


        Write-Host "Resource: " -NoNewline
        Write-Host "$($ResourcePrefixName)-$($app)" -ForegroundColor Green

        Receive-AppServiceContents -Base64Auth  $base64AuthInfo -BaseApiUrl $apiBaseUrl -BaseOutputPath "$outTempPath\$supportPackageName"
    }
    
    Confirm-MatchingThumbprintValues -FileDirectoryPath $outTempPath
}

function Receive-AppServiceContents {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true)]
        [string]$Base64Auth,
        
        [Parameter(Mandatory = $true)]
        [string]$BaseApiUrl,

        [Parameter(Mandatory = $true)]
        [string]$BaseOutputPath
        
    )
    Write-Host "[" -NoNewline
    Write-Host "Certificate Thumbprint Verification" -ForegroundColor Blue -NoNewline
    Write-Host "]: " -NoNewline

    Write-Host "API URL: " -NoNewline
    Write-Host "$BaseApiUrl" -ForegroundColor Green 
    try {
        Get-NestedFolderFiles -Uri "$BaseApiUrl/vfs/site/wwwroot/App_Config/" -FolderDownloadPath $BaseOutputPath -Base64Auth $Base64Auth 
    }
    catch {
        Write-Host " X " -ForegroundColor Red
        Write-Host "  > $($_.Exception.Message)`n" -ForegroundColor Red
    }
}

function Get-NestedFolderFiles {
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

    foreach ($file in $FilesList | Where-Object { ($_.name -eq "ConnectionStrings.config") -or ($_.name -eq "AppSettings.config") }) {

        if ($file.mime -eq "inode/directory") {
         
            New-Item -Path $FolderDownloadPath -Name $file.name -ItemType "directory" | Out-Null
            $folderPath = "$FolderDownloadPath\$($file.name)"

            $nextUri = "$uri$($file.name)/"

            # Call Get-FileDownload
            Get-NestedFolderFiles -Uri $nextUri -FolderDownloadPath $folderPath -Base64Auth $Base64Auth 
            
        }
        else {
            Write-Host "[" -NoNewline
            Write-Host "Certificate Thumbprint Verification" -ForegroundColor Blue -NoNewline
            Write-Host "]: " -NoNewline

            Write-Host "Download: " -NoNewline
            Write-Host "$($file.name)..." -ForegroundColor Green -NoNewline
            Invoke-WebRequest  -Uri $file.href -Headers @{Authorization = ("{0}" -f $Base64Auth) } -OutFile "$FolderDownloadPath\$($file.name)"
            Write-Host " OK `n" -ForegroundColor Green -NoNewline
        }
    }
}

function Confirm-MatchingThumbprintValues {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true)]
        [string]$FileDirectoryPath
    )
    Write-Host "`n*********************************************************************`n" -ForegroundColor Blue

    
    $count = 0
    $cNameStringsWithThumbprint = "xconnect.collection.certificate|xdb.marketingautomation.operations.client.certificate|xdb.marketingautomation.reporting.client.certificate|xdb.referencedata.client.certificate"
    $ThumbprintToMatch = ''
    $listOfAppSettings = Get-ChildItem -Path $FileDirectoryPath -Recurse | Where-Object { $_.Name -eq "AppSettings.config" } 
    
    $xcCollectAppSetting = $listOfAppSettings | Where-Object { $_.DirectoryName -match "xc-collect" } | Select-Object
    
 
    $xml = [xml](Get-Content $xcCollectAppSetting.FullName)
    $xml.SelectNodes("//appSettings/add") | ForEach-Object { 
        if ($_.Attributes[0].Value -eq "validateCertificateThumbprint") {
            $ThumbprintToMatch = $_.Attributes[1].Value
            Write-Host "Thumbprint set on xConnect Collect Role AppSettings.config: $ThumbprintToMatch `n" -ForegroundColor Green 
        }
    }

    if ($ThumbprintToMatch -eq '') {
        Write-Host "Could not find thumbprint value in xConnect Collect Role AppSettings.config file." -ForegroundColor Red
        Exit
    }

    Write-Host "Comparing thumbprint values in AppSettings.config files..." -ForegroundColor Yellow

    foreach ($appConfig in $listOfAppSettings | Where-Object { $_.DirectoryName -notmatch "xc-collect" }) {
        $xml = [xml](Get-Content $appConfig.FullName)
        $xml.SelectNodes("//appSettings/add") | ForEach-Object { 
            if ($_.Attributes[0].Value -eq "validateCertificateThumbprint") {
            
                Write-Host "  > 'validateCertificateThumbprint' on $($appConfig.Directory.BaseName)..." -ForegroundColor DarkGray -NoNewline

                if ($_.Attributes[1].Value -eq $ThumbprintToMatch) {
                    Write-Host "matches`n" -ForegroundColor Green
                }
                else {
                    Write-Host "does not match" -ForegroundColor Red
                    Write-Host "  "$appConfig.FullName "`n" -ForegroundColor Red
                    $count++
                }           
            }
        }
    }

    $listOfConnectionStrings = Get-ChildItem -Path $FileDirectoryPath -Recurse | Where-Object { $_.Name -eq "ConnectionStrings.config" } 

    Write-Host "Checking Thumbprint Values in ConnectionStrings.config files..." -ForegroundColor Yellow
    foreach ($item in $listOfConnectionStrings) {

        $xml = [xml](Get-Content $item.FullName)

        $xml.SelectNodes("//connectionStrings/add") | ForEach-Object { 

            if ($_.Name -match $cNameStringsWithThumbprint) {
                Write-Host "  > $($_.Name) on $($item.Directory.BaseName)..." -ForegroundColor DarkGray -NoNewline
                if ($_.connectionString -match 'FindValue\=(.*)') {
                    $tpVal = $Matches[1]
                    if ($tpVal -match $ThumbprintToMatch) {
                        Write-Host "matches`n" -ForegroundColor Green
                    }
                    else {
                        Write-Host "does not match" -ForegroundColor Red
                        Write-Host "  "$item.FullName "`n" -ForegroundColor Red
                        $count++
                    }
                }
                else {
                    Write-Host "unable to determine match." -ForegroundColor Yellow
                }
            }
        }
    }

    if ($count -eq 0) {
        Write-Host "No thumbprint discrepencies found.`n" -ForegroundColor Green
    }
    else {
        Write-Host "$count thumbprint discrepencies found!`n" -ForegroundColor Red
    }
 
}